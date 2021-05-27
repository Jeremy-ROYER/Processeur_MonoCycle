-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 12/03/2021

-- Composant : Assemblage Unité de Traitement - Assemblage_UT
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Assemblage_UT is
	port(
		clk, rst         : in std_logic;
		RegWr, MemWr     : in std_logic; --Write Enable 16x32bits registers & Data Memory
		RegSel           : in std_logic;
		Rd, Rn, Rm       : in std_logic_vector(3 downto 0);
		UALsrc, WrSrc    : in std_logic;
		UALctr           : in std_logic_vector(1 downto 0);
		Imm              : in std_logic_vector(7 downto 0);
		TestBusW         : out std_logic_vector(31 downto 0);
		Flag             : out std_logic_vector(31 downto 0)
	);
end entity;

architecture struct of Assemblage_UT is
	signal  busW, busA, busB, UALOut, 
			MuxRegOut, DataOut, ImmExtend : std_logic_vector(31 downto 0);
	signal Rd_m : std_logic_vector(3 downto 0);
begin

	Mux_Rm_Rd : entity work.Mux2_1(RTL)
	generic map(N   => 4)
	port map(	A   => Rm,
				B   => Rd,
				COM => RegSel,
				S   => Rd_m
	);
	
	Reg16_32 : entity work.Banc_Reg(RTL)
	port map (	clk   => clk,
				reset => rst,
				W     => busW,
				Ra    => Rn,    
				Rb    => Rd_m, 
				Rw    => Rd,
				WE    => RegWr,
				A     => busA,  
				B     => busB
	);

	Imm_Extender : entity work.Ext32_Sign(RTL)
	generic map(N => 8)
	port map(	E => Imm, 
				S => ImmExtend
	);
		
	Mux_Reg_Imm : entity work.Mux2_1(RTL)
	generic map(N   => 32)
	port map(	A   => busB, 
				B   => ImmExtend,
				COM => UALsrc,
				S   => MuxRegOut
	);
	
	UAL : entity work.UAL(RTL)
	port map(	A  => busA,
				B  => MuxRegOut,
				OP => UALctr,
				Y  => UALOut,
				N  => Flag(31),
				Z  => Flag(30)
	);
	
	Data_Memory : entity work.Mem_Data(RTL)
	port map(	clk     => clk,
				reset   => rst,
				WE      => MemWr,
				DataIn  => busB,
				DataOut => DataOut,
				Addr    => UALOut(5 downto 0)
	);
	
	Mux_UAL_Mem : entity work.Mux2_1(RTL)
	generic map(N => 32)
	port map(	A   => UALOut,
				B   => DataOut,
				COM => WrSrc,
				S   => busW
	);
				
	
	Flag(29 downto 0) <= (others => '0');
	
	-- Sortie de test pour le test_bench
	TestBusW <= busW;
	
end architecture;
