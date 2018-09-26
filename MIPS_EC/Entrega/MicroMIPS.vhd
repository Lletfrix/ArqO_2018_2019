----------------------------------------------------------------------
-- Fichero: MicroMIPS.vhd
-- Descripci�n: Microprocesador MIPS

-- Autores: Rafael S�nchez S�nchez y Sergio Gal�n Mart�n
-- Asignatura: EC 1� grado
-- Grupo de Pr�cticas: 2101
-- Grupo de Teor�a: 210
-- Pr�ctica: 5
-- Ejercicio: 3
----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_signed.ALL;
entity MicroMIPS is

-- Declaraci�n de entradas y salidas
port(
	MemProgData: in std_logic_vector (31 downto 0);
	MemDataDataRead: in std_logic_vector(31 downto 0);
	MemProgAddr: out std_logic_vector(31 downto 0);
	MemDataAddr: out std_logic_vector(31 downto 0);
	MemDataDataWrite: out std_logic_vector(31 downto 0);
	MemDataWE: out std_logic;
	Clk: in std_logic;
	NRst: in std_logic
	);
end MicroMIPS;

architecture behavioural of MicroMIPS is

--Se�ales
	signal A1, A2, A3,PC2RAuxAddr, RegDestAux: std_logic_vector (4 downto 0);
	signal OPCode, Funct: std_logic_vector (5 downto 0);
	signal AluControl: std_logic_vector (2 downto 0);
	signal Jump, RegToPC, Branch, PCToReg, MemToReg, MemWrite, AluSrc, ExtCero, RegWrite, RegDest, z, PCSrc: std_logic;
	signal Rd1, Rd2, Op2, PCOut, MemDataAddrAux, M2RAux, PCToRAux, PCSrcAux, JumpAux, RegToPCAux, ECAux, ESAux, ExtCeroAux, PCPLus4, JTA, BTA, BTAx4 : std_logic_vector (31 downto 0);


	--Componentes

	--ALU
	component AluMIPS
		port(
			Op1: in std_logic_vector (31 downto 0);
			Op2: in std_logic_vector (31 downto 0);
			ALUControl: in std_logic_vector (2 downto 0);
			Res: out std_logic_vector (31 downto 0);
			Z: out std_logic
			);
		end component;

	--Banco de registros
	component RegsMIPS
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
	end component;

	--Unidad de control
	component UnidadControl
		port(
				OPCode : in  std_logic_vector (5 downto 0); -- OPCode de la instrucci�n
				Funct : in std_logic_vector(5 downto 0); -- Funct de la instrucci�n
				-- Se�ales para el PC
				Jump : out  std_logic;
				RegToPC : out std_logic;
				Branch : out  std_logic;
				PCToReg : out std_logic;
				-- Se�ales para la memoria
				MemToReg : out  std_logic;
				MemWrite : out  std_logic;

				-- Se�ales para la ALU
				ALUSrc : out  std_logic;
				ALUControl : out  std_logic_vector (2 downto 0);
				ExtCero : out std_logic;

				-- Se�ales para el GPR
				RegWrite : out  std_logic;
				RegDest : out  std_logic
				);
		end component;

	begin

		ALU: AluMIPS
		port map(
			Op1 => Rd1,
			Op2 => Op2,
			AluControl => AluControl,
			Res => MemDataAddrAux,
			z => z
			);

		Bench: RegsMIPS
		port map(
			Clk => Clk,
			NRst => NRst,
			Wd3 => PCToRAux,
			We3 => RegWrite,
			A1 => A1,
			A2 => A2,
			A3 => A3,
			Rd1 => Rd1,
			Rd2 => Rd2
			);

		UnidadCtrl: UnidadControl
		port map(
			OPCode => OPCode,
			Funct => Funct,
			Jump => Jump,
			RegToPC => RegToPC,
			Branch => Branch,
			PCToReg => PCToReg,
			MemToReg => MemToReg,
			MemWrite => MemWrite,
			ALUSrc => ALUSrc,
			ALUControl => ALUControl,
			ExtCero => ExtCero,
			RegWrite => RegWrite,
			RegDest => RegDest
			);

		MemDataAddr <= MemDataAddrAux;
		MemDataWE <= MemWrite;
		MemProgAddr <= PCOut;
		MemDataDataWrite <= Rd2;
		Funct <= MemProgData (5 downto 0);
		OPCode <= MemProgData (31 downto 26);

		--Mux 2 a 1

		M2RAux <= MemDataAddrAux when MemToReg = '0' else MemDataDataRead;
		PCToRAux <= M2RAux when PCToReg = '0' else PCPlus4;
		PCSrc <= Branch and z;
		PCSrcAux <= PCPlus4 when PCSrc = '0' else BTA;
		JumpAux <= PCSrcAux when Jump = '0' else JTA;
		RegToPCAux <= JumpAux when RegToPC = '0' else Rd1;
		ECAux (15 downto 0)  <=  MemProgData (15 downto 0);
		ECAux (31 downto 16) <= (others => '0');
		ESAux (15 downto 0) <= MemProgData (15 downto 0);
		ESAux (31 downto 16) <= (others => MemProgData (15));
		Op2 <= Rd2 when ALUSrc = '0' else ExtCeroAux;
		ExtCeroAux <= ESAux when ExtCero = '0' else ECAux;
		RegDestAux <= MemProgData(20 downto 16) when RegDest = '0' else MemProgData(15 downto 11);
		PC2RAuxAddr <= RegDestAux when PCToReg = '0' else "11111";
		PCPlus4 <= PCOut + 4;
		JTA (31 downto 28)<= PCPlus4 (31 downto 28);
		JTA (27 downto 2) <= MemProgData (25 downto 0);
		JTA (1 downto 0) <= (others => '0');
		BTAx4 <= ESAux (29 downto 0) & "00";
		BTA <= BTAx4 + PCPlus4;
		A1 <= MemProgData (25 downto 21);
		A2 <= MemProgData (20 downto 16);
		A3 <= PC2RAuxAddr;
		process (NRst, Clk)
		begin
		if (NRst = '0') then
			PCOut <= (others => '0');
		elsif rising_edge(Clk) then
			PCOut <= RegToPCAux;
		end if;
		end process;






end behavioural;
