--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2018-19
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
  port(
    Clk      : in  std_logic;           -- Reloj activo flanco subida
    Reset    : in  std_logic;           -- Reset asincrono activo nivel alto
    -- Instruction memory
    IAddr    : out std_logic_vector(31 downto 0);  -- Direccion
    IDataIn  : in  std_logic_vector(31 downto 0);  -- Dato leido
    -- Data memory
    DAddr    : out std_logic_vector(31 downto 0);  -- Direccion
    DRdEn    : out std_logic;           -- Habilitacion lectura
    DWrEn    : out std_logic;           -- Habilitacion escritura
    DDataOut : out std_logic_vector(31 downto 0);  -- Dato escrito
    DDataIn  : in  std_logic_vector(31 downto 0)   -- Dato leido
    );
end processor;

architecture rtl of processor is

    signal PC, ReadData1, ReadData2, AluSrcMux, DataAddr, MemToRegMux, JumpMux, BranchZMux, ExtendedInm, JumpAddr: std_logic_vector (31 downto 0);
    signal RegDstMux: std_logic_vector (4 downto 0);
    signal AluControl: std_logic_vector (3 downto 0);
    signal AluOp: std_logic_vector (2 downto 0);
    signal Z, RegWrite, Branch, Jump, MemToReg, MemWrite, MemRead, AluSrc, RegDst: std_logic;

    component reg_bank
        port (
            Clk : in std_logic; -- Reloj
            Reset : in std_logic; -- Reset asincrono a nivel alto
            Wd3 : in std_logic_vector(31 downto 0); -- Dato de escritura
            We3 : in std_logic; -- Write enable
            A1 : in std_logic_vector(4 downto 0); -- Direccion Registro Lectura 1
            A2 : in std_logic_vector(4 downto 0); -- Direccion Registro Lectura 2
            A3 : in std_logic_vector(4 downto 0); -- Direccion Registro Escritura
            Rd1 : out std_logic_vector(31 downto 0); -- Salida 1
            Rd2 : out std_logic_vector(31 downto 0) --Salida 2
            );
    end component;

    component alu
        port (
           OpA     : in  std_logic_vector (31 downto 0); -- Operando A
           OpB     : in  std_logic_vector (31 downto 0); -- Operando B
           Control : in  std_logic_vector ( 3 downto 0); -- Codigo de control=op. a ejecutar
           Result  : out std_logic_vector (31 downto 0); -- Resultado
           ZFlag   : out std_logic                       -- Flag Z
        );
    end component;

    component control_unit
      port (
        -- Entrada = codigo de operacion en la instruccion:
        OpCode   : in  std_logic_vector (5 downto 0);
        Branch   : out std_logic;           -- 1 = Ejecutandose instruccion branch
        Jump     : out std_logic;           -- 1 = Ejecutandose instruccion jump
        MemToReg : out std_logic;  -- 1=Escribir en registro la salida de la mem.
        MemWrite : out std_logic;           -- Escribir la memoria
        MemRead  : out std_logic;           -- Leer la memoria
        ALUSrc   : out std_logic;  -- 0=oper.B es registro, 1=es valor inm.
        ALUOp    : out std_logic_vector (2 downto 0);  -- Tipo operacion para control de la ALU
        RegWrite : out std_logic;           -- 1=Escribir registro
        RegDst   : out std_logic            -- 0=Reg. destino es rt, 1=rd
        );
    end component;

    component alu_control
      port (
        ALUOp      : in  std_logic_vector (2 downto 0);  -- Codigo control desde la unidad de control
        Funct      : in  std_logic_vector (5 downto 0);  -- Campo "funct" de la instruccion
        ALUControl : out std_logic_vector (3 downto 0)  -- Define operacion a ejecutar por ALU
        );
    end component;

begin
    ControlUnit: control_unit
    port map(
      OpCode   => IDataIn(31 downto 26),
      Branch   => Branch,
      Jump     => Jump,
      MemToReg => MemToReg,
      MemWrite => MemWrite,
      MemRead  => MemRead,
      ALUSrc   => AluSrc,
      ALUOp    => AluOp,
      RegWrite => RegWrite,
      RegDst   => RegDst
      );

    ALUControlUnit: alu_control
      port map(
        ALUOp => AluOp,
        Funct => IDataIn(5 downto 0),
        ALUControl => AluControl
        );

    Registry: reg_bank
    port map(
        Clk => Clk,
        Reset => Reset,
        Wd3 => MemToRegMux,
        We3 => RegWrite,
        A1 => IDataIn(25 downto 21), -- CHECK
        A2 => IDataIn(20 downto 16), -- Direccion Registro Lectura 2
        A3 => RegDstMux, -- Direccion Registro Escritura
        Rd1 => ReadData1, -- Salida 1
        Rd2 => ReadData2
        );

    ArithmeticLogicUnit: alu
    port map(
        OpA => ReadData1,
        OpB => AluSrcMux,
        Control => AluControl,
        Result => DataAddr,
        ZFlag => Z
        );

    ExtendedInm(31 downto 16) <= (others => IDataIn(15));
    ExtendedInm(15 downto 0) <= IDataIn(15 downto 0);

    RegDstMux <= IDataIn(20 downto 16) when RegDst = '0' else
                 IDataIn(15 downto 11);

    AluSrcMux <= ExtendedInm when ALUSrc = '1' else
                 ReadData2;

    MemToRegMux <= DDataIn when MemToReg = '1' else
                   DataAddr;

    PC4 <= PC + 4;

    JumpAddr(31 downto 28) <= PC4(31 downto 28);
    JumpAddr(27 downto 0) <= (IDataIn(25 downto 0) & "00");

    JumpMux <= JumpAddr when Jump = '1' else
               BranchZMux;

    BranchZMux <= PC4 when Branch = '0' or Z = '0' else
                  (ExtendedInm(29 downto 0) & "00") + PC4;

    IAddr <= PC;

    DAddr <= DataAddr;
    DDataOut <= ReadData2;
    DRdEn <= MemRead;
    DWrEn <= MemWrite;

   process (Reset, Clk)
   begin
   if (Reset = '1') then
       PC <= (others => '0');
   elsif rising_edge(Clk) then
       PC <= JumpMux; -- TODO:
   end if;
   end process;

   process (Reset, Clk) --ID/EX
   begin
   if (Reset = '1') then
       RegWriteID/EX <= '0',
       MemToRegID/EX <= '0',
       MemReadID/EX <= '0',
       MemWriteID/EX <= '0'
       BranchID/EX <= '0',
       RegDestID/EX <= '0',
       AluSrcID/EX <= '0',
       AluOpID/EX <= "000",
       ReadData1ID/EX <= (others => '0'),
       ReadData2ID/EX <= (others => '0'),
       PC4ID/EX <= (others => '0');
    elsif rising_edge(Clk) then
       RegWriteID/EX <= RegWrite,
       MemToRegID/EX <= MemToReg,
       MemReadID/EX <= MemRead,
       MemWriteID/EX <= MemWrite,
       BranchID/EX <= Branch,
       RegDestID/EX <= RegDest,
       AluSrcID/EX <= AluSrc,
       AluOpID/EX <= AluOp,
       ReadData1ID/EX <= ReadData1,
       ReadData2ID/EX <= ReadData2,
       PC4ID/EX <= PC4IF/ID;
end architecture;
