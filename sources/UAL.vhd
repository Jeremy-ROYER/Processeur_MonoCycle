-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 05/03/2021

-- Composant : Unité Arithmétique et Logique - UAL
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UAL is
port(
	A, B : in std_logic_vector(31 downto 0);
	OP   : in std_logic_vector(1 downto 0);
	Y    : out std_logic_vector(31 downto 0);
	N    : out std_logic;
	Z	 : out std_logic
);
end entity;

Architecture RTL of UAL is
	signal Ytemp : std_logic_vector(31 downto 0);
begin

	with OP select
		Ytemp <= std_logic_vector(signed(A)+signed(B)) when "00",
				 B                                     when "01",
				 std_logic_vector(signed(A)-signed(B)) when "10",
				 A                                     when others;
	
	with Ytemp select
		Z <= '1' when x"00000000",
			 '0' when others;
	Y <= Ytemp;
	N <= Ytemp(31);
	
	
end architecture;