-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 17/03/2021

-- Composant : Registre PSR de 32 bits - PSR_Reg32
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PSR_Reg32 is
	port(
		clk, rst : in std_logic;
		WE		 : in std_logic;
		DATAIN   : in std_logic_vector(31 downto 0);
		DATAOUT  : out std_logic_vector(31 downto 0)
	);
end entity;

architecture RTL of PSR_Reg32 is

begin
	process(clk,rst)
	begin
		if rst = '1' then
			DATAOUT <= (others => '0');
		elsif rising_edge(clk) then
			if WE = '1' then
				DATAOUT <= DATAIN;
			end if;
		end if;
	end process;
end architecture;