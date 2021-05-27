-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 13/03/2021

-- Composant : Unité de MaJ du compteur de programme PC - Maj_Cpt_PC
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Maj_Cpt_PC is
	port(
		PCout, PCext : in std_logic_vector(31 downto 0);
		nPCsel       : in std_logic;
		PCin         : out std_logic_vector(31 downto 0)
	);
end entity;

architecture RTL of Maj_Cpt_PC is
begin
	with nPCsel select
		PCin <= std_logic_vector(signed(PCout) + 1)                 when '0',
				std_logic_vector(signed(PCout) + signed(PCext) + 1) when '1',
				(others => '-')                                     when others;
end architecture;