library ieee;
USE ieee.std_logic_1164.all;

ENTITY interruptors IS
	PORT (
        boot        : IN  STD_LOGIC;
        clk         : IN  STD_LOGIC;
        inta        : IN  STD_LOGIC;
        switches    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        intr        : OUT STD_LOGIC;
        rd_switch   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END interruptors;

ARCHITECTURE Structure OF interruptors IS
    SIGNAL intr_s: STD_LOGIC;
    SIGNAL estat_actual: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL estat_anterior: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

    PROCESS (clk, boot) --potser s'hauria d'activar amb els switches?
    BEGIN
        if boot = '1' then 
            intr_s <= '0';
            estat_actual <= x"00";
            estat_anterior <= x"00";
        elsif rising_edge(clk) then

            estat_actual <= switches;

            if intr_s = '0' then 
                if estat_actual /= estat_anterior then 
                    intr_s <= '1';
                    rd_switch <= estat_anterior;
                else 
                    estat_anterior <= estat_actual;
                END if;

            elsif inta = '1' then
                intr_s <= '0';
                rd_switch <= "XXXXXXXX";
                estat_anterior <= estat_actual;
            END if;
        END if;
    END PROCESS;
	
    intr <= intr_s;

END Structure;