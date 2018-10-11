--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2018-19
--
-- Rafael Sánchez Sánchez, Sergio Galán Martín.
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

  signal PC, ReadData1, ReadData2, AluSrcMux, DataAddr, MemToRegMux, JumpMux, BranchZMux, ExtendedInm, JumpAddr, PC4 : std_logic_vector (31 downto 0);
  signal ForwardAMux ForwardBMux                                                                                     : std_logic_vector (31 downto 0);
  signal PC4IFID, IDataInIFID                                                                                        : std_logic_vector (31 downto 0);
  signal ExtendedInmIDEX, ReadData1IDEX, ReadData2IDEX, PC4IDEX                                                      : std_logic_vector (31 downto 0);
  signal DataAddrEXMEM, ReadData2EXMEM                                                                               : std_logic_vector (31 downto 0);
  signal DataAddrMEMWB, DDataInMEMWB                                                                                 : std_logic_vector (31 downto 0);
  signal FunctIDEX                                                                                                   : std_logic_vector (5 downto 0);
  signal RegDstMux, RSIDEX, RTIDEX, RDIDEX, RegDstMuxEXMEM, RegDstMuxMEMWB                                           : std_logic_vector (4 downto 0);
  signal AluControl                                                                                                  : std_logic_vector (3 downto 0);
  signal AluOp, AluOpIDEX                                                                                            : std_logic_vector (2 downto 0);
  signal ForwardA, ForwardB                                                                                          : std_logic_vector (1 downto 0);
  signal Z, RegWrite, Branch, Jump, MemToReg, MemWrite, MemRead, AluSrc, RegDst                                      : std_logic;
  signal RegWriteIDEX, MemToRegIDEX, MemReadIDEX, MemWriteIDEX, BranchIDEX, RegDstIDEX, AluSrcIDEX                   : std_logic;
  signal RegWriteEXMEM, MemToRegEXMEM, MemReadEXMEM, MemWriteEXMEM                                                   : std_logic;
  signal RegWriteMEMWB, MemToRegMEMWB                                                                                : std_logic;
  component reg_bank
    port (
      Clk   : in  std_logic;            -- Reloj
      Reset : in  std_logic;            -- Reset asincrono a nivel alto
      Wd3   : in  std_logic_vector(31 downto 0);  -- Dato de escritura
      We3   : in  std_logic;            -- Write enable
      A1    : in  std_logic_vector(4 downto 0);  -- Direccion Registro Lectura 1
      A2    : in  std_logic_vector(4 downto 0);  -- Direccion Registro Lectura 2
      A3    : in  std_logic_vector(4 downto 0);  -- Direccion Registro Escritura
      Rd1   : out std_logic_vector(31 downto 0);  -- Salida 1
      Rd2   : out std_logic_vector(31 downto 0)  --Salida 2
      );
  end component;

  component alu
    port (
      OpA     : in  std_logic_vector (31 downto 0);  -- Operando A
      OpB     : in  std_logic_vector (31 downto 0);  -- Operando B
      Control : in  std_logic_vector (3 downto 0);  -- Codigo de control=op. a ejecutar
      Result  : out std_logic_vector (31 downto 0);  -- Resultado
      ZFlag   : out std_logic           -- Flag Z
      );
  end component;

  component control_unit
    port (
      -- Entrada = codigo de operacion en la instruccion:
      OpCode   : in  std_logic_vector (5 downto 0);
      Branch   : out std_logic;         -- 1 = Ejecutandose instruccion branch
      Jump     : out std_logic;         -- 1 = Ejecutandose instruccion jump
      MemToReg : out std_logic;  -- 1=Escribir en registro la salida de la mem.
      MemWrite : out std_logic;         -- Escribir la memoria
      MemRead  : out std_logic;         -- Leer la memoria
      ALUSrc   : out std_logic;  -- 0=oper.B es registro, 1=es valor inm.
      ALUOp    : out std_logic_vector (2 downto 0);  -- Tipo operacion para control de la ALU
      RegWrite : out std_logic;         -- 1=Escribir registro
      RegDst   : out std_logic          -- 0=Reg. destino es rt, 1=rd
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
  ControlUnit : control_unit
    port map(
      OpCode   => IDataInIFID(31 downto 26),
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

  ALUControlUnit : alu_control
    port map(
      ALUOp      => AluOpIDEX,
      Funct      => FunctIDEX,
      ALUControl => AluControl
      );

  Registry : reg_bank
    port map(
      Clk   => Clk,
      Reset => Reset,
      Wd3   => MemToRegMux,
      We3   => RegWriteMEMWB,
      A1    => IDataInIFID(25 downto 21),  -- CHECK
      A2    => IDataInIFID(20 downto 16),  -- Direccion Registro Lectura 2
      A3    => RegDstMuxMEMWB,             -- Direccion Registro Escritura
      Rd1   => ReadData1,                  -- Salida 1
      Rd2   => ReadData2
      );

  ArithmeticLogicUnit : alu
    port map(
      OpA     => ReadData1IDEX,
      OpB     => AluSrcMux,
      Control => AluControl,
      Result  => DataAddr,
      ZFlag   => Z
      );

  ExtendedInm(31 downto 16) <= (others => IDataInIFID(15));
  ExtendedInm(15 downto 0)  <= IDataInIFID(15 downto 0);

  RegDstMux <= RTIDEX when RegDstIDEX = '0' else
               RDIDEX;

  AluSrcMux <= ExtendedInmIDEX when ALUSrcIDEX = '1' else
               ForwardBMux;

  MemToRegMux <= DDataInMEMWB when MemToRegMEMWB = '1' else
                 DataAddrMEMWB;

  PC4 <= PC + 4;

  JumpAddr(31 downto 28) <= PC4IFID(31 downto 28);
  JumpAddr(27 downto 0)  <= (IDataInIFID(25 downto 0) & "00");

  JumpMux <= JumpAddr when Jump = '1' else
             BranchZMux;

  BranchZMux <= PC4 when BranchIDEX = '0' or Z = '0' else
                (ExtendedInmIDEX(29 downto 0) & "00") + PC4IDEX;

  ForwardA <= "01" when RegWriteMEMWB and (RegDstMuxMEMWB /= "0000") and not (RegWriteEXMEM and (RegDstMuxEXMEM /= "0000") and (RegDstMuxEXMEM = RSIDEX)) and (RegDstMuxMEMWB = RSIDEX) else
              "10" when RegWriteEXMEM and (RegDstMuxEXMEM /= "0000") and (RegDstMuxEXMEM = RSIDEX) else
              "00";

  ForwardB <= "01" when RegWriteMEMWB and (RegDstMuxMEMWB /= "0000") and not (RegWriteEXMEM and (RegDstMuxEXMEM /= "0000") and (RegDstMuxEXMEM = RTIDEX)) and (RegDstMuxMEMWB = RTIDEX) else
              "10" when RegWriteEXMEM and (RegDstMuxEXMEM /= "0000") and (RegDstMuxEXMEM = RTIDEX) else
              "00";

  ForwardAMux <= ReadData1IDEX when ForwardA = "00" else
                 MemToRegMux   when ForwardA = "10" else
                 DataAddrEXMEM when ForwardA = "01" else
                 "00";

  ForwardBMux <= ReadData2IDEX when ForwardA = "00" else
                 MemToRegMux   when ForwardA = "10" else
                 DataAddrEXMEM when ForwardA = "01" else
                 "00";

  IAddr <= PC;

  DAddr    <= DataAddrEXMEM;
  DDataOut <= ReadData2EXMEM;
  DRdEn    <= MemReadEXMEM;
  DWrEn    <= MemWriteEXMEM;

  process (Reset, Clk)
  begin
    if (Reset = '1') then
      PC <= (others => '0');
    elsif rising_edge(Clk) then
      PC <= JumpMux;
    end if;
  end process;

--IFID registry
  process (Reset, Clk)
  begin
    if (Reset = '1') then
      IDataInIFID <= (others => '0');
      PC4IFID     <= (others => '0');
    elsif rising_edge(Clk) then
      IDataInIFID <= IDataIn;
      PC4IFID     <= PC4;
    end if;
  end process;

-- ID/EX registry
  process (Reset, Clk)
  begin
    if (Reset = '1') then
      RegWriteIDEX    <= '0';
      MemToRegIDEX    <= '0';
      MemReadIDEX     <= '0';
      MemWriteIDEX    <= '0';
      BranchIDEX      <= '0';
      RegDstIDEX      <= '0';
      AluSrcIDEX      <= '0';
      RSIDEX          <= (others => '0');
      RTIDEX          <= (others => '0');
      RDIDEX          <= (others => '0');
      ExtendedInmIDEX <= (others => '0');
      AluOpIDEX       <= (others => '0');
      ReadData1IDEX   <= (others => '0');
      ReadData2IDEX   <= (others => '0');
      PC4IDEX         <= (others => '0');
      FunctIDEX       <= (others => '0');
    elsif rising_edge(Clk) then
      RegWriteIDEX    <= RegWrite;
      MemToRegIDEX    <= MemToReg;
      MemReadIDEX     <= MemRead;
      MemWriteIDEX    <= MemWrite;
      BranchIDEX      <= Branch;
      RegDstIDEX      <= RegDst;
      AluSrcIDEX      <= AluSrc;
      RSIDEX          <= IDataInIFID (25 downto 21);
      RTIDEX          <= IDataInIFID (20 downto 16);
      RDIDEX          <= IDataInIFID (15 downto 11);
      FunctIDEX       <= IDataInIFID (5 downto 0);
      ExtendedInmIDEX <= ExtendedInm;
      AluOpIDEX       <= AluOp;
      ReadData1IDEX   <= ReadData1;
      ReadData2IDEX   <= ReadData2;
      PC4IDEX         <= PC4IFID;
    end if;
  end process;

-- EX/MEM registry
  process(Reset, Clk)
  begin
    if(Reset = '1') then
      RegWriteEXMEM  <= '0';
      MemToRegEXMEM  <= '0';
      MemReadEXMEM   <= '0';
      MemWriteEXMEM  <= '0';
      RegDstMuxEXMEM <= (others => '0');
      DataAddrEXMEM  <= (others => '0');
      ReadData2EXMEM <= (others => '0');
    elsif rising_edge(Clk) then
      RegWriteEXMEM  <= RegWriteIDEX;
      MemToRegEXMEM  <= MemToRegIDEX;
      MemReadEXMEM   <= MemReadIDEX;
      MemWriteEXMEM  <= MemWriteIDEX;
      RegDstMuxEXMEM <= RegDstMux;
      DataAddrEXMEM  <= DataAddr;
      ReadData2EXMEM <= ReadData2IDEX;
    end if;
  end process;

-- MEM/WB Registry
  process(Reset, Clk)
  begin
    if(Reset = '1') then
      RegWriteMEMWB  <= '0';
      MemToRegMEMWB  <= '0';
      RegDstMuxMEMWB <= (others => '0');
      DataAddrMEMWB  <= (others => '0');
      DDataInMEMWB   <= (others => '0');
    elsif rising_edge(Clk) then
      RegWriteMEMWB  <= RegWriteEXMEM;
      MemToRegMEMWB  <= MemToRegEXMEM;
      RegDstMuxMEMWB <= RegDstMuxEXMEM;
      DataAddrMEMWB  <= DataAddrEXMEM;
      DDataInMEMWB   <= DDataIn;
    end if;
  end process;

end architecture;
