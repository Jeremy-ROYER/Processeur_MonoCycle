-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Composant : Multiplexeur 2 vers 1 - Mux2_1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2_1 is
	generic( N : integer := 32);
	port(
		A, B : in std_logic_vector(N-1 downto 0);
		COM  : in std_logic;
		S    : out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture RTL of Mux2_1 is
begin

	with COM select
		S <= A when '0',
			 B when '1',
			 (others => '0') when others;

end architecture;