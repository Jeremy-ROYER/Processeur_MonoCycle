-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 19/03/2021

-- Banc de test : Unité de contrôle - UC
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_UC is
end entity;

architecture test_bench of tb_UC is
	signal clk, rst, nPCsel, RegWr, UALsrc, MemWr, WrSrc, RegSel : std_logic;
	signal Instruction, Flag                                     : std_logic_vector(31 downto 0);
	signal Rn, Rd, Rm                                            : std_logic_vector(3 downto 0);
	signal UALctr                                                : std_logic_vector(1 downto 0);

	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin

	UUT : entity work.UC(struct)
	port map(
		clk         => clk,
		rst         => rst,
		Instruction => Instruction,
		Flag        => Flag,
		Rn          => Rn,
		Rm		    => Rm,
		Rd 		    => Rd,
		UALctr	    => UALctr,
		nPCsel	    => nPCsel,
		RegWr		=> RegWr,
		UALsrc	    => UALsrc,
		MemWr		=> MemWr,
		WrSrc		=> WrSrc,
		RegSel	    => RegSel
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
		-- Mise à zéro
		Instruction <= x"00000000";
		Flag <= x"00000000";
		
		-- Test avec valeurs mémoire d'instructions
		Instruction <= x"E3A01010";
		wait for clk_period;
		
		Instruction <= x"E3A02000";
		wait for clk_period;
		
		Instruction <= x"E6110000";
		wait for clk_period;
		
		Instruction <= x"E0822000";
		wait for clk_period;
		
		Instruction <= x"E2811001";
		wait for clk_period;
		
		Instruction <= x"E351002A";
		wait for clk_period;
		
		Instruction <= x"BAFFFFFB";
		wait for clk_period;
		
		Instruction <= x"E6012000";
		wait for clk_period;
		
		Instruction <= x"EAFFFFF7";
		wait for clk_period;
	
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		done <= '1';
		wait;
	end process;

end architecture;