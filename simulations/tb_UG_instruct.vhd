-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Banc de test : Unité de gestion des instructions - UG_instruct
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_UG_instruct is
end entity;

architecture test_bench of tb_UG_instruct is
	signal clk, reset, nPCsel  : std_logic;
	signal Offset              : std_logic_vector(23 downto 0);
	signal Instruction         : std_logic_vector(31 downto 0);
	
	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin

	UUT : entity work.UG_instruct(struct)
	port map( clk         => clk,
			  reset         => reset,
			  Offset24    => Offset,
			  nPCsel      => nPCsel,
			  Instruction => Instruction
	);

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
		nPCsel <= '0';
		Offset  <= (others => '0');
		wait for clk_period;
		assert Instruction = x"E3A01010" report "ERROR on first instruction" severity error;
		
		-- Test Instruction 0
		wait for clk_period;
		assert Instruction = x"E3A02000" report "ERROR on first instruction" severity error;

		-- Test saut de 2 instructions donc instruction 3
		nPCsel <= '1';
		Offset <= x"000001";
		wait for clk_period;
		assert Instruction = x"E0822000" report "ERROR on jump to 3rd instruction (<=> jump of two instructions)" severity error;
	
		-- Test instruction suivante
		nPCsel <= '0';
		wait for clk_period;
		assert Instruction = x"E2811001" report "ERROR on next instruction (4th instruction)" severity error;
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		done <= '1';
		wait;
	end process;
	
end architecture;