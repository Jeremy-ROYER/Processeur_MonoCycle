-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 05/03/2021

-- Composant : Unité de Traitement - UT
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UT is 
port(
	clk        : in std_logic;
	reset      : in std_logic;
	WE         : in std_logic;
	W          : in std_logic_vector(31 downto 0);
	Ra, Rb, Rw : in std_logic_vector(3 downto 0);
	OP         : in std_logic_vector(1 downto 0);
	Y          : out std_logic_vector(31 downto 0);
	N          : out std_logic
);
end entity;

architecture struct of UT is
	signal A, B : std_logic_vector(31 downto 0);
begin
	
	C0 : entity work.Banc_Reg(RTL) port map(clk => clk, reset => reset, W => W, Ra => Ra, Rb => Rb, Rw => Rw, WE => WE, A => A, B => B);
	
	C1 : entity work.UAL(RTL) port map(A => A, B => B, OP => OP, Y => Y, N => N);
end architecture;