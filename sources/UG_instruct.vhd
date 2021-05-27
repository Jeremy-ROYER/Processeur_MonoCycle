-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 16/03/2021

-- Composant : Unité de gestion des instructions - UG_instruct
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UG_instruct is
	port(
		clk, reset  : in std_logic;
		Offset24    : in std_logic_vector(23 downto 0);
		nPCsel      : in std_logic;
		Instruction : out std_logic_vector(31 downto 0)
	);
end entity;

architecture struct of UG_instruct is 
	signal Offset32, PCout, PCin : std_logic_vector(31 downto 0);
begin

	PC_Extender : entity work.Ext32_sign(RTL)
	generic map(N => 24)
	port map(	E => Offset24,
				S => Offset32
	);
	
	Maj_Compteur : entity work.Maj_Cpt_PC(RTL)
	port map( PCout  => PCout,
			  PCext  => Offset32,
			  nPCsel => nPCsel,
			  PCin   => PCin
	);
	
	Registre_PC : entity work.Reg_PC(RTL)
	port map( clk   => clk,
			  rst   => reset,
			  in32  => PCin,
			  PCout => PCout
	);
	
	Instruction_Memory : entity work.Instruction_Memory3(RTL)
	port map( PC          => PCout,
			  Instruction => Instruction
	);
end architecture;
