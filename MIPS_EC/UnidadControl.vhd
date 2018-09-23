----------------------------------------------------------------------
-- Fichero: UnidadControl.vhd
-- Descripci�n: Unidad de Control para el procesador
-- Fecha �ltima modificaci�n:

-- Autores: Rafael S�nchez S�nchez y Sergio Gal�n Martin
-- Asignatura: EC 1� grado
-- Grupo de Pr�cticas: 2101
-- Grupo de Teor�a: 210
-- Pr�ctica: 5
-- Ejercicio: 2
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UnidadControl is
  port(
    OPCode   : in  std_logic_vector (5 downto 0);  -- OPCode de la instrucci�n
    Funct    : in  std_logic_vector(5 downto 0);   -- Funct de la instrucci�n
    -- Se�ales para el PC
    Jump     : out std_logic;
    RegToPC  : out std_logic;
    Branch   : out std_logic;
    PCToReg  : out std_logic;
    -- Se�ales para la memoria
    MemToReg : out std_logic;
    MemWrite : out std_logic;

    -- Se�ales para la ALU
    ALUSrc     : out std_logic;
    ALUControl : out std_logic_vector (2 downto 0);
    ExtCero    : out std_logic;

    -- Se�ales para el GPR
    RegWrite : out std_logic;
    RegDest  : out std_logic
    );
end UnidadControl;
architecture behavioural of UnidadControl is
begin

  MemtoReg <= '1' when OPCODE = "100011" else  --lw
              '0';

  MemWrite <= '1' when OPCODE = "101011" else  --sw
              '0';


  Branch <= '1' when OPCODE = "000100" else  --beq
            '0';

  ALUControl <= "000" when OPCODE = "000000" and FUNCT = "100100" else  --and
                "010" when OPCODE = "000000" and FUNCT = "100000" else  --add
                "110" when OPCODE = "000000" and FUNCT = "100010" else  --sub
                "101" when OPCODE = "000000" and FUNCT = "100111" else  --nor
                "001" when OPCODE = "000000" and FUNCT = "100111" else  --or
                "111" when OPCODE = "000000" and FUNCT = "101010" else  --slt
                "010" when OPCODE = "100011"                      else  --lw
                "010" when OPCODE = "101011"                      else  --sw
                "110" when OPCODE = "000100"                      else  --beq
                "000" when OPCODE = "001100"                      else  --andi
                "001" when OPCODE = "001101"                      else  --ori
                "010" when OPCODE = "001000"                      else  --addi
                "111" when OPCODE = "001010"                      else  --slti
                "---" when OPCODE = "000010"                      else  --j
                "---" when OPCODE = "000011"                      else  --jal
                "---" when OPCODE = "000000" and FUNCT = "001000" else  --jr
                "---";

  ALUSrc <= '0' when OPCODE = "000000" else  --R-TYPE
            '0' when OPCODE = "000100" else  --beq
            '1';


  RegDest <= '1' when OPCODE = "000000" else  --R-TYPE
             '0';

  RegWrite <= '0' when OPCODE = "101011" else                       --sw
              '0' when OPCODE = "000100"                      else  --beq
              '0' when OPCODE = "000010"                      else  --j
              '0' when OPCODE = "000000" and FUNCT = "001000" else  --jr
              '1';

  RegToPc <= '1' when OPCODE = "000000" and FUNCT = "001000" else  --R-TYPE
             '0';

  ExtCero <= '1' when OPCODE = "001100" or OPCODE = "001101" else  --andi y ori
             '0';


  Jump <= '1' when OPCODE = "000010" else  --j
          '1' when OPCODE = "000011" else  --jal
          '0';

  PcToReg <= '1' when OPCODE = "000011" else  --jal
             '0';

end behavioural;
