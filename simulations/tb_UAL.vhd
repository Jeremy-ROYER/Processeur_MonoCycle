-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 05/03/2021

-- Banc de test : Unité Arithmétique et Logique - UAL
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_UAL is
end entity;

architecture test_bench of tb_UAL is
	signal A, B, Y : std_logic_vector(31 downto 0);
	signal OP      : std_logic_vector(1 downto 0);
	signal N       : std_logic;
begin

	UUT : entity work.UAL(RTL) port map(A => A, B => B, OP => OP, Y => Y, N => N);

	signal_gen : process is
	begin
		-- Test addition positive
		A  <= x"00000060"; -- A = 96
		B  <= x"00000011"; -- B = 17
		OP <= "00";
		wait for 20 ns;
		assert Y = x"00000071" report "ERROR on ADD Positive"           severity error;
		assert N = '0'         report "ERROR on flag sign ADD Positive" severity error;
		
		-- Test addition négative
		A  <= x"FFFFFFDB"; -- A = -37
		B  <= x"FFFFFFBF"; -- B = -65
		OP <= "00";
		wait for 20 ns;
		assert Y = x"FFFFFF9A" report "ERROR on ADD Negative"           severity error;
		assert N = '1'         report "ERROR on flag sign ADD Negative" severity error;
		
		-- Test recopie B
		B <= x"0000001B"; -- B = 27
		OP <= "01";
		wait for 20 ns;
		assert Y = x"0000001B" report "ERROR on Copy B"           severity error;
		assert N = '0'         report "ERROR on flag sign Copy B" severity error;
		
		-- Test soustraction positive
		A  <= x"00000060"; -- A = 96
		B  <= x"00000011"; -- B = 17
		OP <= "10";
		wait for 20 ns;
		assert Y = x"0000004F" report "ERROR on SUB Positive"           severity error;
		assert N = '0'         report "ERROR on flag sign SUB Positive" severity error;
		
		-- Test soustraction négative
		A  <= x"FFFFFF64"; -- A = -156
		B  <= x"FFFFFFBF"; -- B = -65
		OP <= "10";
		wait for 20 ns;
		assert Y = x"FFFFFFA5" report "ERROR on SUB Negative"           severity error;
		assert N = '1'         report "ERROR on flag sign SUB Negative" severity error;
		
		-- Test recopie A
		A <= x"FFFFFCFA"; -- A = 27
		OP <= "11";
		wait for 20 ns;
		assert Y = x"FFFFFCFA" report "ERROR on Copy A"           severity error;
		assert N = '1'         report "ERROR on flag sign Copy A" severity error;
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;

end architecture;