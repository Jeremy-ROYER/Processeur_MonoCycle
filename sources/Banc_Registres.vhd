-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 05/03/2021

-- Composant : Banc de Registres (16x 32bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Banc_Reg is
port(
	clk        : in std_logic;
	reset      : in std_logic;
	W          : in std_logic_vector(31 downto 0);
	Ra, Rb, Rw : in std_logic_vector(3 downto 0);  -- Adresses des registres pour la lecture et l'écriture 
	WE         : in std_logic;                     -- Write Enable
	A, B       : out std_logic_vector(31 downto 0)
);
end entity;

architecture RTL of Banc_Reg is

	-- Declaration Type Tableau Memoire
	type table is array(15 downto 0) of std_logic_vector(31 downto 0);
	
	-- Fonction d'Initialisation du Banc de Registres
	function init_banc return table is
		variable result : table;
		begin
			for i in 14 downto 0 loop
			result(i) := (others=>'0');
			end loop;
		result(15):=X"00000030";
		return result;
	end init_banc;

	-- Déclaration et Initialisation du Banc de Registres 16x32 bits
	signal Banc : table:=init_banc;

begin

	process(clk, reset)
	begin
		if reset = '1' then
			Banc <= init_banc; 
		
		elsif rising_edge(clk) then
			if WE = '1' then
				Banc(to_integer(unsigned(Rw))) <= W;
			end if;
		end if;
	end process;
	
	A <= Banc(to_integer(unsigned(Ra)));
	B <= Banc(to_integer(unsigned(Rb)));

end architecture;