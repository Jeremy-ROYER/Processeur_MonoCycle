-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Composant : Mémoires de données - Mem_Data
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mem_Data is
	port(
		clk, reset : in std_logic;
		DataIn     : in std_logic_vector(31 downto 0);
		Addr       : in std_logic_vector(5 downto 0);  -- Adresse pour la lecture et l'écriture 
		WE         : in std_logic;                     -- Write Enable
		DataOut    : out std_logic_vector(31 downto 0)
	);
end entity;

architecture RTL of Mem_Data is

	-- Declaration Type Tableau de mot mémoire
	type table is array(63 downto 0) of std_logic_vector(31 downto 0);
	
	-- Fonction d'Initialisation des mots mémoire
	function init_mem return table is
		variable result : table;
		begin
			for i in 63 downto 0 loop
				result(i) := (others=>'0');
			end loop;
		result(63) := X"00000030";
		
		-- Instruction memory 3
		result(38) := x"0000003F"; -- 63
		result(37) := x"0000009B"; -- 155
		result(36) := x"00000142"; -- 322
		result(35) := x"0000000C"; -- 12
		result(34) := x"0000001B"; -- 27
		result(33) := x"0000006B"; -- 107
		result(32) := x"00000003"; -- 3
		
		-- Instruction memory 2 et 1
		result(26) := x"0000004E"; -- 78
		result(25) := x"0000009B"; -- 155
		result(24) := x"0000009D"; -- 157
		result(23) := x"0000005A"; -- 90
		result(22) := x"00000879"; -- 2169
		result(21) := x"00000055"; -- 85
		result(20) := x"0000508B"; -- 20619
		result(19) := x"00000E00"; -- 3584
		result(18) := x"00000001"; -- 1
		result(17) := x"00000010"; -- 16
		result(16) := x"00000003"; -- 3
		
		return result;
	end init_mem;

	-- Déclaration et Initialisation des mots mémoire 64x32 bits
	signal Memoire : table:=init_mem;

begin

	process(clk, reset)
	begin
		if reset = '1' then
			Memoire <= init_mem; 
		
		elsif rising_edge(clk) then
			if WE = '1' then
				Memoire(to_integer(unsigned(Addr))) <= DataIn;
			end if;
		end if;
	end process;
	
	DataOut <= Memoire(to_integer(unsigned(Addr)));
	
end architecture;