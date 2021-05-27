-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Composant : Extension de signe sur 32 bits - Ext32_Sign
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ext32_Sign is
	generic( N : integer := 8);
	port(
		E : in std_logic_vector(N-1 downto 0);
		S : out std_logic_vector(31 downto 0)
	);
end entity;

architecture RTL of Ext32_Sign is
	signal extension : std_logic_vector (31 downto N);
begin
	
	extension <= (others => E(N-1));
	S <= extension & E;

end architecture;