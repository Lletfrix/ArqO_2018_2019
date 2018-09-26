----------------------------------------------------------------------
-- Fichero: RegsMIPS.vhd
-- Descripci�n: Registro para MIPS

-- Autores: Rafael S�nchez S�nchez y Sergio Gal�n Mart�n
-- Asignatura: EC 1� grado
-- Grupo de Pr�cticas: 2101
-- Grupo de Teor�a: 210
-- Pr�ctica: 3
-- Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity RegsMIPS is
    port (
        Clk : in std_logic; -- Reloj
        NRst : in std_logic; -- Reset as�ncrono a nivel bajo
        Wd3 : in std_logic_vector(31 downto 0); -- Dato de escritura
        We3 : in std_logic; -- Write enable
        A1 : in std_logic_vector(4 downto 0); -- Direcci�n Registro Lectura 1
        A2 : in std_logic_vector(4 downto 0); -- Direcci�n Registro Lectura 2
        A3 : in std_logic_vector(4 downto 0); -- Direcci�n Registro Escritura
        Rd1 : out std_logic_vector(31 downto 0); -- Salida 1
        Rd2 : out std_logic_vector(31 downto 0) --Salida 2
    );
end RegsMIPS;

architecture Practica of RegsMIPS is

    -- Tipo para almacenar los registros
    type regs_t is array (0 to 31) of std_logic_vector(31 downto 0);

    -- Esta es la se�al que contiene los registros. El acceso es de la
    -- siguiente manera: regs(i) acceso al registro i, donde i es
    -- un entero. Para convertir del tipo std_logic_vector a entero se
    -- hace de la siguiente manera: conv_integer(slv), donde
    -- slv es un elemento de tipo std_logic_vector

    -- Registros inicializados a '0'
    -- NOTA: no cambie el nombre de esta se�al.
    signal regs : regs_t;
begin  -- PRACTICA

    ------------------------------------------------------
                -- Escritura --
    ------------------------------------------------------
    process (NRst, Clk)
    begin
        if NRst = '0' then -- Si el Reset est� activado (activo a nivel bajo)
            for i in 0 to 31 loop
                regs(i)<=(others=>'0'); --Todos los registros a 0
            end loop;

        elsif rising_edge(Clk) then --Escritura sincrona
        if (We3 = '1')    then --Si el WriteEnable est� activo
            if (conv_integer(A3)/=0) then --Y la direcci�n A3 no es el registro 0
            regs(conv_integer(A3))<=Wd3; --Escribimos el dato de entrada en ese registro
            end if;
        end if;
        end if;
    end process;
    ------------------------------------------------------
               -- Lectura --
    ------------------------------------------------------
    Rd1 <= regs(conv_integer(A1)); --Lectura as�ncrona del registro indicado por A1
    Rd2 <= regs(conv_integer(A2)); --Lectura asincrona del registro indicado por A2

end Practica;
