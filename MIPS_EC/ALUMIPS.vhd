----------------------------------------------------------------------
-- Fichero: ALUMIPS.vhd
-- Descripción: ALU del microprocesador MIPS

-- Autores: Rafael Sánchez Sánchez y Sergio Galán Martín
-- Asignatura: EC 1º grado
-- Grupo de Prácticas: 2101
-- Grupo de Teoría: 210
-- Práctica: 3
-- Ejercicio: 1
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
entity AluMIPS is

-- Declaración de entradas y salidas
  port(
    Op1        : in  std_logic_vector (31 downto 0);
    Op2        : in  std_logic_vector (31 downto 0);
    ALUControl : in  std_logic_vector (2 downto 0);
    Res        : out std_logic_vector (31 downto 0);
    Z          : out std_logic
    );
end AluMIPS;

architecture behavioural of AluMIPS is

  -- Declaración de señales auxiliares
  signal signs       : std_logic_vector(1 downto 0);
  signal subtraction : std_logic_vector (31 downto 0);
  signal aux         : std_logic_vector (31 downto 0);

begin

  signs       <= OP1(31) & OP2(31);
  subtraction <= OP1 - OP2;  -- Guardamos los signos de los operandos y la diferencia para el SLT
  Res         <= aux;

  process(ALUControl, OP1, OP2, subtraction, signs)

  begin

    case ALUControl is
      when "010" =>
        aux <= OP1 + OP2;               --Suma
      when "110" =>
        aux <= OP1 - OP2;               --Resta
      when "000" =>
        aux <= OP1 and OP2;             --AND
      when "001" =>
        aux <= OP1 or OP2;              --OR
      when "101" =>
        aux <= OP1 nor OP2;             --NOR
      when "111" =>

        case signs is
          when "00" =>                  -- Caso ++
            aux(0)            <= subtraction(31);
            aux (31 downto 1) <= (others => '0');
          when "11" =>                  -- Caso --
            aux(0)            <= subtraction(31);
            aux (31 downto 1) <= (others => '0');
          when "01" =>                  -- Caso +-
            aux <= (others => '0');
          when others =>  -- Caso -+ (Others por si hay errores en la señal)
            aux(0)           <= '1';
            aux(31 downto 1) <= (others => '0');
        end case;

      when others =>  --Others por si hay alguna señal de control inesperada en la ALU
        aux <= (others => '0');
    end case;
  end process;

  process(aux)

  begin
    -- Flag z
    if (aux = x"00000000") then
      z <= '1';
    else z <= '0';
    end if;
  end process;



end behavioural;
