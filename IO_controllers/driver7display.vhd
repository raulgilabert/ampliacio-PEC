LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY driver7display IS
	PORT(
			reset		: IN std_logic; 
			hex		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			n_hex		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			HEX0 	  	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
			HEX1 	  	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
			HEX2		: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
			HEX3		: OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000");
END driver7display;

ARCHITECTURE Structure OF driver7display IS
	SIGNAL HEX0_S	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL HEX1_S	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL HEX2_S	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL HEX3_S	: STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
	HEX0_S <= "1000000" when hex(3 DOWNTO 0) = x"0" else
				 "1111001" when hex(3 DOWNTO 0) = x"1" else
				 "0100100" when hex(3 DOWNTO 0) = x"2" else
				 "0110000" when hex(3 DOWNTO 0) = x"3" else
				 "0011001" when hex(3 DOWNTO 0) = x"4" else
				 "0010010" when hex(3 DOWNTO 0) = x"5" else
				 "0000010" when hex(3 DOWNTO 0) = x"6" else
				 "1111000" when hex(3 DOWNTO 0) = x"7" else
				 "0000000" when hex(3 DOWNTO 0) = x"8" else
				 "0010000" when hex(3 DOWNTO 0) = x"9" else
				 "0001000" when hex(3 DOWNTO 0) = x"A" else
				 "0000011" when hex(3 DOWNTO 0) = x"B" else
				 "0100111" when hex(3 DOWNTO 0) = x"C" else
				 "0100001" when hex(3 DOWNTO 0) = x"D" else
				 "0000110" when hex(3 DOWNTO 0) = x"E" else
				 "0001110" when hex(3 DOWNTO 0) = x"F" else
				 "1111111";

	HEX1_S <= "1000000" when hex(7 DOWNTO 4) = x"0" else
				 "1111001" when hex(7 DOWNTO 4) = x"1" else
				 "0100100" when hex(7 DOWNTO 4) = x"2" else
				 "0110000" when hex(7 DOWNTO 4) = x"3" else
				 "0011001" when hex(7 DOWNTO 4) = x"4" else
				 "0010010" when hex(7 DOWNTO 4) = x"5" else
				 "0000010" when hex(7 DOWNTO 4) = x"6" else
				 "1111000" when hex(7 DOWNTO 4) = x"7" else
				 "0000000" when hex(7 DOWNTO 4) = x"8" else
				 "0010000" when hex(7 DOWNTO 4) = x"9" else
				 "0001000" when hex(7 DOWNTO 4) = x"A" else
				 "0000011" when hex(7 DOWNTO 4) = x"B" else
				 "0100111" when hex(7 DOWNTO 4) = x"C" else
				 "0100001" when hex(7 DOWNTO 4) = x"D" else
				 "0000110" when hex(7 DOWNTO 4) = x"E" else
				 "0001110" when hex(7 DOWNTO 4) = x"F" else
				 "1111111";
				 
	HEX2_S <= "1000000" when hex(11 DOWNTO 8) = x"0" else
				 "1111001" when hex(11 DOWNTO 8) = x"1" else
				 "0100100" when hex(11 DOWNTO 8) = x"2" else
				 "0110000" when hex(11 DOWNTO 8) = x"3" else
				 "0011001" when hex(11 DOWNTO 8) = x"4" else
				 "0010010" when hex(11 DOWNTO 8) = x"5" else
				 "0000010" when hex(11 DOWNTO 8) = x"6" else
				 "1111000" when hex(11 DOWNTO 8) = x"7" else
				 "0000000" when hex(11 DOWNTO 8) = x"8" else
				 "0010000" when hex(11 DOWNTO 8) = x"9" else
				 "0001000" when hex(11 DOWNTO 8) = x"A" else
				 "0000011" when hex(11 DOWNTO 8) = x"B" else
				 "0100111" when hex(11 DOWNTO 8) = x"C" else
				 "0100001" when hex(11 DOWNTO 8) = x"D" else
				 "0000110" when hex(11 DOWNTO 8) = x"E" else
				 "0001110" when hex(11 DOWNTO 8) = x"F" else
				 "1111111";
				 
	HEX3_S <= "1000000" when hex(15 DOWNTO 12) = x"0" else
				 "1111001" when hex(15 DOWNTO 12) = x"1" else
				 "0100100" when hex(15 DOWNTO 12) = x"2" else
				 "0110000" when hex(15 DOWNTO 12) = x"3" else
				 "0011001" when hex(15 DOWNTO 12) = x"4" else
				 "0010010" when hex(15 DOWNTO 12) = x"5" else
				 "0000010" when hex(15 DOWNTO 12) = x"6" else
				 "1111000" when hex(15 DOWNTO 12) = x"7" else
				 "0000000" when hex(15 DOWNTO 12) = x"8" else
				 "0010000" when hex(15 DOWNTO 12) = x"9" else
				 "0001000" when hex(15 DOWNTO 12) = x"A" else
				 "0000011" when hex(15 DOWNTO 12) = x"B" else
				 "0100111" when hex(15 DOWNTO 12) = x"C" else
				 "0100001" when hex(15 DOWNTO 12) = x"D" else
				 "0000110" when hex(15 DOWNTO 12) = x"E" else
				 "0001110" when hex(15 DOWNTO 12) = x"F" else
				 "1111111";
				 
	HEX0 <= "1111111" when n_hex(0) = '0' or reset = '1' else HEX0_S;
	HEX1 <= "1111111" when n_hex(1) = '0' or reset = '1' else HEX1_S;
	HEX2 <= "1111111" when n_hex(2) = '0' or reset = '1' else HEX2_S;
	HEX3 <= "1111111" when n_hex(3) = '0' or reset = '1' else HEX3_S;
	
				 
	
END Structure;