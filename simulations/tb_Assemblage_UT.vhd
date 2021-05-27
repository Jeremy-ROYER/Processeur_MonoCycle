-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 10/03/2021

-- Banc de test : Assemblage Unité de Traitement - Assemblage_UT
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Assemblage_UT is
end entity;

architecture test_bench of tb_Assemblage_UT is
	signal clk, reset, UALsrc, WrSrc, RegWr, MemWr, RegSel : std_logic;
	signal Rn, Rd, Rm     : std_logic_vector(3 downto 0);
	signal UALctr         : std_logic_vector(1 downto 0);
	signal Imm            : std_logic_vector(7 downto 0);
	signal TestBusW, Flag : std_logic_vector(31 downto 0);
	
	signal done : std_logic := '0';
	constant clk_period : time:= 10 ns;
begin
	
	UUT : entity work.Assemblage_UT(struct)
	port map(	clk      => clk,
				rst      => reset,
				RegWr    => RegWr,
				MemWr    => MemWr,
				RegSel	 => RegSel,
				Rd       => Rd,
				Rn       => Rn,
				Rm       => Rm,
				UALsrc   => UALsrc,
				WrSrc    => WrSrc,
				UALctr   => UALctr,
				Imm      => Imm,
				TestBusW => TestBusW,
				Flag     => Flag
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
		RegWr <= '0';
		MemWr <= '0';
		UALsrc <= '0';
		WrSrc <= '0';
		UALctr <= "00";
		Rd <= (others => '0');
		Rn <= (others => '0');
		Rm <= (others => '0');
		Imm <= (others => '0');
		wait for clk_period;
		
		-- Addition de 2 registres
		-- R(2) = R(1) + R(15)    avec R(1)=0 et R(15)=48 (initialisation)
		Rd <= "0010";
		Rn <= "0001";
		Rm <= "1111";
		UALctr <= "00";
		UALsrc <= '0';
		WrSrc <= '0';
		RegWr <= '1';
		wait for clk_period;
		assert TestBusW = x"00000030" report "ERROR on ADD of 2 reg"         severity error;
		assert Flag = x"00000000"     report "ERROR on Flag of ADD of 2 reg" severity error;
		
		-- Addition d'un registre avec un immédiat
		-- R(14) = R(2) + 107
		Rd <= "1110";
		Rn <= "0010";
		Imm <= x"6B";
		UALsrc <= '1';
		wait for clk_period;
		assert TestBusW = x"0000009B" report "ERROR on ADD of reg and imm"         severity error;
		assert Flag = x"00000000"     report "ERROR on Flag of ADD of reg and imm" severity error;
		
		-- Soustraction de 2 registres
		-- R(2) = R(15) - R(14)
		Rn <= "1111";
		Rm <= "1110";
		Rd <= "0010";
		UALsrc <= '0';
		UALctr <= "10";
		wait for clk_period;
		assert TestBusW = x"FFFFFF95" report "ERROR on SUB of 2 reg"         severity error;
		assert Flag = x"80000000"     report "ERROR on Flag of SUB of 2 reg" severity error;
	
		-- Soustraction d'un immédiat à un registre
		-- R(14) = R(14) - 89
		Rn <= "1110";
		Rd <= "1110";
		Imm <= x"59";
		UALsrc <= '1';
		wait for 1 ps;
		assert TestBusW = x"00000042" report "ERROR on SUB of imm from reg"         severity error;
		assert Flag = x"00000000"     report "ERROR on Flag of SUB of imm from reg" severity error;
		wait until clk = '1';
	
		-- Copie de la valeur d'un registre dans un autre
		-- R(11) = R(2)
		Rn <= "0010";
		Rd <= "1011";
		UALctr <= "11";
		wait for clk_period;
		assert TestBusW = x"FFFFFF95" report "ERROR on copy from one register to another"         severity error;
		assert Flag = x"80000000"      report "ERROR on FLag of copy from one register to another" severity error;

		-- Ecriture d'un registre dans un mot mémoire
		-- Mem(35) = R(14)
		RegWr <= '0';
		Rm <= "1110";
		Imm <= x"23"; --35
		UALsrc <= '1';
		UALctr <= "01";
		wait for 1 ps;
		MemWr <= '1';
		wait until clk ='1';
		assert TestBusW = x"00000023" report "ERROR on Addr for write in memory" severity error;
		
		-- Lecture d'un mot mémoire dans un registre
		-- R(8) = Mem(35)
		MemWr <= '0';
		Rd <= "1000";
		WrSrc <= '1';
		RegWr <= '1';
		wait for clk_period;
		assert TestBusW = x"00000042" report "ERROR on write or read in memory" severity error;
		
		
		-- Fin de test
		report "End of test. Verify that no error was reported.";
		done <= '1';
		wait;
	end process;
	
end architecture;