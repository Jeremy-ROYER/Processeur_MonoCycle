-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 13/03/2021

-- Composant : Registre PC 32 bits - Reg_PC
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_PC is 
	port(
		clk, rst : in std_logic;
		in32	 : in std_logic_vector(31 downto 0);
		PCout    : out std_logic_vector(31 downto 0)
	);
end entity;

architecture RTL of Reg_PC is
begin
	process(clk,rst)
	begin
		if rst = '1' then
			PCout <= (others => '0');
		elsif rising_edge(clk) then
			PCout <= in32;
		end if;
	end process;
end architecture;