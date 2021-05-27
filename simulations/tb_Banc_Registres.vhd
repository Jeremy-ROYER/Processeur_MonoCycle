-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 05/03/2021

-- Banc de test : Banc de Registres (16x 32bits)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Banc_Reg is
end entity;

architecture test_bench of tb_Banc_Reg is
	signal clk, rst, WE : std_logic;
	signal W, A, B      : std_logic_vector(31 downto 0);
	signal Rw, Ra, Rb   : std_logic_vector(3 downto 0);
	
	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin

	UUT : entity work.Banc_Reg(RTL) port map(clk => clk, reset => rst, W => W, Ra => Ra, Rb => Rb, Rw => Rw, WE => WE, A => A, B => B);

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
		-- Mise à zero
		WE <= '0';
		Rw <= "0000";
		W  <= x"00000000";
		Rb <= "0000";
		Ra <= "0000";
		wait for clk_period;
		
		-- Test Ecriture dans 4e registre et Lecture sur B
		WE <= '1';
		Rw <= "0011";
		W  <= x"00000070";
		Rb <= "0011";
		wait for clk_period;
		assert B = x"00000070" report "ERROR on write or read B" severity error;
		
		-- Test Pas d'Ecriture
		WE <= '0';
		Rw <= "0011";
		W  <= x"00000D80";
		Rb <= "0011";
		wait for clk_period;
		assert B = x"00000070" report "ERROR on write or read B" severity error;
		
		-- Test Ecriture dans 11e registre et Lecture sur A
		WE <= '1';
		Rw <= "1010";
		W  <= x"0000FA05";
		Ra <= "1010";
		wait for clk_period;
		assert A = x"0000FA05" report "ERROR on write or read A" severity error;
		
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		done <= '1';
		wait;
	end process;
end architecture;