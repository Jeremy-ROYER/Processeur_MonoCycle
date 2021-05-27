-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Banc de test : Mémoires de données - Mem_Data
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Mem_Data is
end entity;

architecture test_bench of tb_Mem_Data is
	signal clk, reset, WE : std_logic;
	signal DataIn, DataOut : std_logic_vector(31 downto 0);
	signal Addr            : std_logic_vector(5 downto 0);
	
	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin
	UUT : entity work.Mem_Data(RTL) port map(clk => clk, reset => reset, WE => WE, DataIn => DataIn, DataOut => DataOut, Addr => Addr);
	
	-- Signal Reset début de test
	reset <= '1', '0' after clk_period;
	
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
		-- Mise à zéro
		WE <= '0';
		DataIn <= (others => '0');
		Addr <= (others => '0');
		wait for clk_period;
		
		-- Ecriture sur le quatrième mot
		WE <= '1';
		DataIn <= x"0000022C"; -- 556
		Addr <= "000011";
		wait for clk_period;
		assert DataOut = x"0000022C" report "ERROR on write (4th word)" severity error;

		
		-- Lecture sans écriture sur le quatrième mot
		DataIn <= x"000022FB"; -- 8955
		Addr <= "000011";
		WE <= '0';
		wait for clk_period;
		assert DataOut = x"0000022C" report "ERROR on read without write (4th word)" severity error;

	
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		done <= '1';
		wait;
	end process;
	
end architecture;