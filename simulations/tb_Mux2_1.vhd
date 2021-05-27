-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Banc de test : Multiplexeur 2 vers 1 - Mux2_1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Mux2_1 is
end entity;

architecture test_bench of tb_Mux2_1 is
	signal A, B, S : std_logic_vector(31 downto 0);
	signal COM     : std_logic;
begin

	UUT : entity work.Mux2_1(RTL) generic map(N => 32)
		  port map( A => A, B => B, COM => COM, S => S);
		  
	signal_gen : process is
	begin
		A <= x"FFFFFFD0"; -- -48
		B <= x"000001A9"; -- 425
		COM <= '0';      -- On choisit de prendre A en sortie
		wait for 20 ns;
		assert S = x"FFFFFFD0" report "ERROR on the selection of A" severity error;
		
		COM <= '1';      -- On choisit de prendre B en sortie
		wait for 20 ns;
		assert S = x"000001A9" report "ERROR on the selection of B" severity error;
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;

end architecture;
