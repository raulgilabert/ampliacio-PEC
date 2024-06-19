LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY timer IS
	PORT (
        boot        : IN  STD_LOGIC;
        clk         : IN  STD_LOGIC;
        inta        : IN  STD_LOGIC;
        intr        : OUT STD_LOGIC
	);
END timer;

ARCHITECTURE Structure OF timer IS

    SIGNAL counter: STD_LOGIC_VECTOR(21 DOWNTO 0) := "0000000000000000000000";
    SIGNAL intr_s:  STD_LOGIC := '0';
BEGIN

	PROCESS (clk, boot)
    BEGIN
        if boot = '1' then
            intr_s <= '0';
            counter <= "0000000000000000000000";
        elsif rising_edge(clk) then 
    
            if inta = '1' then 
                intr_s <= '0';
            END if;

            counter <= counter + 1;

            if counter = 312500 then
                intr_s <= '1';
                counter <= "0000000000000000000000";
            END if;

        END if;
    END PROCESS;

    intr <= intr_s;

END Structure;