-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 19/03/2021

-- Composant : Assemblage Processeur - Processeur
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processeur is
	port(
		clk, rst: in std_logic
	);
end entity;

architecture struct of Processeur is
	signal Instruction, Flag : std_logic_vector(31 downto 0);
	signal Offset            : std_logic_vector(23 downto 0);
	signal Immediate         : std_logic_vector(7 downto 0);
	signal Rd, Rn, Rm        : std_logic_vector(3 downto 0);
	signal UALctr	         : std_logic_vector(1 downto 0);
	signal nPCsel, RegWr, MemWr, RegSel, WrSrc, UALsrc : std_logic;
begin

	Unite_Gestion_Instruction : entity work.UG_instruct(struct)
	port map( clk => clk,
			  reset => rst,
			  Offset24 => Offset,
			  nPCsel => nPCsel,
			  Instruction => Instruction
	);
	
	Unite_Traitement : entity work.Assemblage_UT(struct)
	port map( clk    => clk,
			  rst    => rst,
			  RegWr  => RegWr,
			  MemWr  => MemWr,
			  RegSel => RegSel,
			  Rd     => Rd,
			  Rn 	 => Rn,
			  Rm	 	 => Rm,
			  UALsrc => UALsrc,
			  WrSrc  => WrSrc,
			  UALctr => UALctr,
			  Imm	 => Immediate,
			  Flag   => Flag
	);
	
	Unite_Controle : entity work.UC(struct)
	port map( clk => clk,
			  rst => rst,
			  Instruction => Instruction,
			  Flag 		  => Flag,
			  Offset	  => Offset,
			  Immediate   => Immediate,
			  Rn		  => Rn,
			  Rd 		  => Rd,
			  Rm 		  => Rm,
			  UALctr  	  => UALctr,
			  nPCsel	  => nPCsel,
			  RegWr		  => RegWr,
			  UALsrc	  => UALsrc,
			  MemWr		  => MemWr,
			  WrSrc		  => WrSrc,
			  RegSel	  => RegSel
	);
	
end architecture; 