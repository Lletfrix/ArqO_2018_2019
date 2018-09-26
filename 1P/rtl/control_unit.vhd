--------------------------------------------------------------------------------
-- Unidad de control principal del micro. Arq0 2018
--
-- Rafael Sánchez Sánchez, Sergio Galán Martín.
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
  port (
    -- Entrada = codigo de operacion en la instruccion:
    OpCode   : in  std_logic_vector (5 downto 0);
    -- Seniales para el PC
    Branch   : out std_logic;           -- 1 = Ejecutandose instruccion branch
    Jump     : out std_logic;           -- 1 = Ejecutandose instruccion jump
    -- Seniales relativas a la memoria
    MemToReg : out std_logic;  -- 1=Escribir en registro la salida de la mem.
    MemWrite : out std_logic;           -- Escribir la memoria
    MemRead  : out std_logic;           -- Leer la memoria
    -- Seniales para la ALU
    ALUSrc   : out std_logic;  -- 0=oper.B es registro, 1=es valor inm.
    ALUOp    : out std_logic_vector (2 downto 0);  -- Tipo operacion para control de la ALU
    -- Seniales para el GPR
    RegWrite : out std_logic;           -- 1=Escribir registro
    RegDst   : out std_logic            -- 0=Reg. destino es rt, 1=rd
    );
end control_unit;

architecture rtl of control_unit is

  -- Tipo para los codigos de operacion:
  subtype t_OpCode is std_logic_vector (5 downto 0);

  -- Codigos de operacion para las diferentes instrucciones:
  constant OP_RTYPE : t_OpCode := "000000";
  constant OP_BEQ   : t_OpCode := "000100";
  constant OP_SW    : t_OpCode := "101011";
  constant OP_LW    : t_OpCode := "100011";
  constant OP_LUI   : t_OpCode := "001111";
  constant OP_J     : t_opCpde := "000010";
  constant OP_SLTI  : t_OpCode := "001010";

begin

  Branch <= '1' when OpCode = OP_J or OpCode = OP_BEQ else
            '0';
  RegDst <= '1' when OpCode = OP_RTYPE else
            '0';
  MemRead <= '1' when OpCode = OP_LW else
             '0';
  MemtoReg <= '1' when OpCode = OP_LW else
              '0';
  MemWrite <= '1' when OpCode = OP_SW else
              '0';
  ALUSrc <= '1' when OpCode = OP_BEQ or OpCode = OP_SW or OpCode = OP_LW or OpCode = OP_LUI or OpCode = OP_SLTI else
            '0';
  RegWrite <= '1' when OpCode = OP_RTYPE or OpCode = OP_LW or OpCode = OP_LUI or OpCode = OP_SLTI else
              '0';
  Jump <= '1' when OpCode = OP_J else
          '0';
  AluOP <= "001" when OpCode = OP_BEQ else
           "010" when OpCode = OP_RTYPE else
           "011" when OpCode = OP_LUI else
           "100" when OpCode = OP_SLTI else
           "000";
end architecture;
