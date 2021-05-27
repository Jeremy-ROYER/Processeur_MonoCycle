-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Banc de test : Extension de signe sur 32 bits - Ext32_Sign
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Ext32_Sign is
end entity;

architecture test_bench of tb_Ext32_Sign is
	signal E : std_logic_vector(7 downto 0);
	signal S : std_logic_vector(31 downto 0);
begin
	
	UUT : entity work.Ext32_Sign(RTL) generic map(N => 8)
		  port map(E => E, S => S);
		  
	signal_gen : process is
	begin
		E <= x"A5"; -- -91
		wait for 20 ns;
		assert S = x"FFFFFFA5" report "ERROR on negative sign extension" severity error;
		
		E <= x"7D"; -- 125
		wait for 20 ns;
		assert S = x"0000007D" report "ERROR on positive sign extension" severity error;
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;
end architecture;