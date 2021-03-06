-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 05/03/2021

-- Banc de test : Unité de traitement - UT
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_UT is
end entity;

architecture test_bench of tb_UT is
	signal clk, rst, WE, N : std_logic;
	signal Ra, Rb, Rw      : std_logic_vector(3 downto 0);
	signal W, Y            : std_logic_vector(31 downto 0);
	signal OP              : std_logic_vector(1 downto 0);
	
	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin

	UUT : entity work.UT(struct) port map(clk => clk, reset => rst, WE => WE, W => W, Ra => Ra, Rb => Rb, Rw => Rw, OP => OP, Y => Y, N => N);
	
	-- Rebouclage sortie entrée
	W <= Y;
	
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
		Rb <= "0000";
		Ra <= "0000";
		OP <= "00";
		wait until clk = '1';
		
		-- R(1) = R(15)
		WE <= '1';
		Rw <= "0001";
		Rb <= "1111";
		OP <= "01";
		wait for 1 ps;
		assert W = x"00000030" report "ERROR on R(15) read for R(1) = R(15)" severity error;
		wait until clk = '1';
		
		-- R(1) = R(1) + R(15)
		WE <= '1';
		Rb <= "1111";
		Ra <= "0001";
		Rw <= "0001";		
		OP <= "00";
		wait for 1 ps;
		assert W = x"00000060" report "ERROR on R(1) + R(15) result" severity error;
		wait until clk = '1';
		
		-- R(2) = R(1) + R(15)
		WE <= '1';
		Rb <= "0001";
		Ra <= "1111";
		OP <= "00";
		Rw <= "0010";
		wait for 1 ps;
		assert W = x"00000090" report "ERROR on R(1) + R(15) result (second time)" severity error;
		wait until clk = '1';

		-- R(3) = R(1) - R(15)
		WE <= '1';
		Rb <= "1111";
		Ra <= "0001";
		OP <= "10";
		Rw <= "0011";
		wait for 1 ps;
		assert W = x"00000030" report "ERROR on R(1) - R(15) result" severity error;
		wait until clk = '1';
		
		-- R(5) = R(7) - R(15)
		WE <= '1';
		Rb <= "1111";
		Ra <= "0111";
		OP <= "10";
		Rw <= "0101";
		wait for 1 ps;
		assert W = x"FFFFFFD0" report "ERROR on R(7) - R(15) result" severity error;
		wait until clk = '1';
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		done <= '1';
		wait;
	end process;
	
end architecture;