LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY dataVisualizer IS
	PORT (
		num: IN std_logic_vector(15 downto 0);
		HEX0 : OUT std_logic_vector(6 downto 0);
		HEX1 : OUT std_logic_vector(6 downto 0);
		HEX2 : OUT std_logic_vector(6 downto 0);
		HEX3 : OUT std_logic_vector(6 downto 0)
	);
END dataVisualizer;


ARCHITECTURE Structure OF dataVisualizer IS
	COMPONENT driver7display IS
		PORT (
			codigoCaracter: IN std_logic_vector(3 downto 0);
			bitsCaracter: OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

BEGIN
	Visor0: driver7display
	PORT map(codigoCaracter=>num (3 downto 0),
				bitsCaracter => HEX0);

	Visor1: driver7display
	PORT map(codigoCaracter=>num (7 downto 4),
				bitsCaracter => HEX1);

	Visor2: driver7display
	PORT map(codigoCaracter=>num (11 downto 8),
				bitsCaracter => HEX2);

	Visor3: driver7display
	PORT map(codigoCaracter=>num (15 downto 12),
				bitsCaracter => HEX3);
	
END Structure;

