-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 19/03/2021

-- Banc de test : Assemblage Processeur - Processeur
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Processeur is
end entity;

architecture test_bench of tb_Processeur is
	signal clk, rst: std_logic;
	
	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin

	UUT : entity work.Processeur(struct)
	port map( clk => clk,
			  rst => rst
	);

	-- Signal Reset début de test
	rst <= '1', '0' after clk_period;
	
	clock : process is 
	begin
		if done = '0' then
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		else
			wait;
		end if;
	end process;
	
	signal_gen : process is
	begin
		done <= '0';
		wait for clk_period*180;
		done <= '1';
		wait;
	end process;
end architecture;