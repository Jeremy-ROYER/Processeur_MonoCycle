-- Projet VHDL - Processeur MonoCycle
-- Autheur   : ROYER Jérémy - EISE3 
-- Date      : 17/03/2021

-- Composant : Decodeur d'instructions - Decode_instruct
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decode_instruct is
	port(
		Instruction, PSRout : in std_logic_vector(31 downto 0);
		Offset				: out std_logic_vector(23 downto 0);
		Immediate			: out std_logic_vector(7 downto 0);
		Rn, Rm, Rd          : out std_logic_vector(3 downto 0);
		UALctr              : out std_logic_vector(1 downto 0);
		nPCsel, RegWr, UALsrc, PSRen, MemWr, WrSrc, RegSel : out std_logic
	);
end entity;

architecture RTL of Decode_instruct is
	type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, BNE, STRGT, ADDGT, XXX);
	
	signal instr_courante: enum_instruction;
begin
	
	process(Instruction)
	begin
		case Instruction(27 downto 26) is
			when "00"   => case Instruction(25 downto 23) is
										when "001"          => instr_courante <= ADDr;
										when "101"          => case Instruction(29) is
																				when '0'    => instr_courante <= ADDGT;
																				when '1'    => instr_courante <= ADDi;
																				when others => instr_courante <= XXX;
																			end case;
										when "110" | "010"  => instr_courante <= CMP;
										when "111"          => instr_courante <= MOV;
										when others         => instr_courante <= XXX;
									end case;
						   
			when "01"   => case Instruction(20) is
										when '0'    => case Instruction(29) is
																	when '0'    => instr_courante <= STRGT;
																	when '1'    => instr_courante <= STR;
																	when others => instr_courante <= XXX;
																end case;
										when '1'    => instr_courante <= LDR;
										when others => instr_courante <= XXX;
									end case;
						  
			when "10"   => case Instruction(29 downto 28) is
										when "01"	 => instr_courante <= BNE;
										when "10"    => instr_courante <= BAL;
										when "11"    => instr_courante <= BLT;
										when others => instr_courante <= XXX;
									end case;
						   
			when others => instr_courante <= XXX;
		end case; 
	end process;
	
	process(instr_courante)
	begin
		-- MemWr et RegSel
		case instr_courante is
			when STR	=> MemWr  <= '1';
						   RegSel <= '1';
			when STRGT	=> MemWr  <= not(PSRout(31));
						   RegSel <= not(PSRout(31));
			when others => MemWr  <= '0';
						   RegSel <= '0';			
		end case;
		
		-- WrSrc
		case instr_courante is
			when LDR	=> WrSrc <= '1';
			when others => WrSrc <= '0';
		end case;
		
		-- PSRen et UALctr
		case instr_courante is
			when CMP 	=> 	PSRen  <= '1';
									UALctr <= "10";
			when MOV	=> 	PSRen  <= '0';
									UALctr <= "01";
			when others => PSRen  <= '0';
									UALctr <= "00";
		end case;
		
		--UALsrc
		case instr_courante is
			when ADDr   => UALsrc <= '0';
			when CMP    => UALsrc <= Instruction(25);
			when others => UALsrc <= '1';
		end case;
		
		-- RegWr
		case instr_courante is
			when ADDi | ADDr | LDR | MOV => RegWr <= '1';
			when ADDGT                   => RegWr <= not(PSRout(31));
			when others                  => RegWr <= '0';
		end case;
		
		-- nPCsel
		case instr_courante is
			when BAL    => nPCsel <= '1';
			when BLT    => nPCsel <= PSRout(31);
			when BNE    => nPCsel <= not(PSRout(30));
			when others => nPCsel <= '0';
		end case;
		
	end process;
	
	Immediate <= Instruction(7  downto  0);
	Offset    <= Instruction(23 downto  0);
	Rn        <= Instruction(19 downto 16);
	Rd        <= Instruction(15 downto 12);
	Rm        <= Instruction(3  downto  0);
end architecture;