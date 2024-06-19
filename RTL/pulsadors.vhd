library ieee;
USE ieee.std_logic_1164.all;

ENTITY pulsadors IS
	PORT (
        boot        : IN  STD_LOGIC;
        clk         : IN  STD_LOGIC;
        inta        : IN  STD_LOGIC;
        keys        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        intr        : OUT STD_LOGIC;
        read_key    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END pulsadors;

ARCHITECTURE Structure OF pulsadors IS
    SIGNAL intr_s: STD_LOGIC;
    SIGNAL estat_actual: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL estat_anterior: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
 

PROCESS (clk, boot)
BEGIN
    if boot = '1' then 
        intr_s <= '0';
        estat_actual <= x"0";
        estat_anterior <= x"0";
    elsif rising_edge(clk) then
        
        estat_actual <= keys;

        if intr_s = '0' then 
            if estat_actual /= estat_anterior then 
                intr_s <= '1';
                read_key <= estat_anterior;
            else 
                estat_anterior <= estat_actual;
            END if;

        elsif inta = '1' then
            intr_s <= '0';
            read_key <= "XXXX";
            estat_anterior <= estat_actual;
        END if;
    END if;
END PROCESS;

intr <= intr_s;	

END Structure;