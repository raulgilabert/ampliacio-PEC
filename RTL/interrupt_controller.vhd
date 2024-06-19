library ieee;
USE ieee.std_logic_1164.all;

ENTITY interrupt_controller IS
	PORT (
		boot		: IN  STD_LOGIC;
		clk			: IN  STD_LOGIC;
		inta		: IN  STD_LOGIC;
		key_intr	: IN  STD_LOGIC;
		ps2_intr	: IN  STD_LOGIC;
		switch_intr	: IN  STD_LOGIC;
		timer_intr	: IN  STD_LOGIC;
		intr		: OUT STD_LOGIC;
		key_inta	: OUT STD_LOGIC;
		ps2_inta	: OUT STD_LOGIC;
		switch_inta	: OUT STD_LOGIC;
		timer_inta	: OUT STD_LOGIC;
		iid			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END interrupt_controller;

ARCHITECTURE Structure OF interrupt_controller IS

	SIGNAL iid_s: std_logic_vector(7 downto 0);

BEGIN

	PROCESS (boot, clk)
	BEGIN
		if rising_edge(clk) then
			if timer_intr = '1' then 
				iid_s <= x"00";
			elsif key_intr = '1' then 
				iid_s <= x"01";
			elsif switch_intr = '1' then 
				iid_s <= x"02";
			elsif ps2_intr = '1' then 
				iid_s <= x"03";
			END if;
		END if;
	END PROCESS;

	intr <= ps2_intr or timer_intr or switch_intr or key_intr when boot = '0' else '0';
	iid <= iid_s;

	timer_inta <= '1' when inta = '1' and iid_s = x"00" else '0';
	key_inta <= '1' when inta = '1' and iid_s = x"01" else '0';
	ps2_inta <= '1' when inta = '1' and iid_s = x"03" else '0';
	switch_inta <= '1' when inta = '1' and iid_s = x"02" else '0';

END Structure;
	