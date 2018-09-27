--------------------------------------------------------------------------------
-- Bloque de control para la ALU. Arq0 2018.
--
-- Rafael Sánchez Sánchez, Sergio Galán Martín.
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_control is
  port (
    -- Entradas:
    ALUOp      : in  std_logic_vector (2 downto 0);  -- Codigo control desde la unidad de control
    Funct      : in  std_logic_vector (5 downto 0);  -- Campo "funct" de la instruccion
    -- Salida de control para la ALU:
    ALUControl : out std_logic_vector (3 downto 0)  -- Define operacion a ejecutar por ALU
    );
end alu_control;

architecture rtl of alu_control is

begin
  ALUControl <= "0000" when ALUOp = "000" else  -- lw, sw and nop
                "0001" when ALUOp = "001"                                  else  -- beq
                "0000" when ALUOp = "010" and Funct(5 downto 0) = "100000" else  -- add
                "0001" when ALUOp = "010" and Funct(5 downto 0) = "100010" else  -- sub
                "0100" when ALUOp = "010" and Funct(5 downto 0) = "100100" else  -- and
                "0111" when ALUOp = "010" and Funct(5 downto 0) = "100101" else  -- or
                "1010" when ALUOp = "010" and Funct(5 downto 0) = "101010" else -- slt
                "0110" when ALUOp = "010" and Funct(5 downto 0) = "100110" else -- xor
                "1101" when ALUOp = "011"                                  else  -- lui
                "1010" when ALUOp = "100"                                  else  -- slti
                "----";
end architecture;
