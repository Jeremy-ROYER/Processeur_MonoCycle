-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 19/03/2021

-- Composant : Unité de contrôle - UC
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
	port(
		clk, rst          : in std_logic;
		Instruction, Flag : in std_logic_vector(31 downto 0);
		Offset			  : out std_logic_vector(23 downto 0);
		Immediate		  : out std_logic_vector(7 downto 0);
		Rn, Rd, Rm        : out std_logic_vector(3 downto 0);
		UALctr            : out std_logic_vector(1 downto 0);
		nPCsel, RegWr, UALsrc, MemWr, WrSrc, RegSel : out std_logic
	);
end entity;

architecture struct of UC is
	signal PSRout : std_logic_vector(31 downto 0);
	signal PSRen  : std_logic;
begin

	Decode_Instruction : entity work.Decode_instruct(RTL)
	port map( Instruction => Instruction,
			  PSRout      => PSRout,
			  Offset	  => Offset,
			  Immediate   => Immediate,
			  Rn          => Rn,
			  Rm		  => Rm,
			  Rd 		  => Rd,
			  UALctr	  => UALctr,
			  nPCsel	  => nPCsel,
			  RegWr		  => RegWr,
			  UALsrc	  => UALsrc,
			  PSRen		  => PSRen,
			  MemWr		  => MemWr,
			  WrSrc		  => WrSrc,
			  RegSel	  => RegSel
	);
	
	PSR : entity work.PSR_Reg32(RTL)
	port map(
		clk     => clk,
		rst     => rst,
		WE      => PSRen,
		DATAIN  => Flag,
		DATAOUT => PSRout
	);
	
end architecture;