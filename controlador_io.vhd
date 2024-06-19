LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY controladores_io IS
	PORT (
		boot			: IN STD_LOGIC;
		CLOCK_50    : IN std_logic;
		addr_io		: in STD_LOGIC_VECTOR(7 DOWNTO 0);
		wr_io			: IN STD_LOGIC_VECTOR(15 downto 0);
		rd_io			: OUT STD_LOGIC_VECTOR(15 downto 0);
		wr_out		: IN std_LOGIC;
		rd_in			: IN STD_LOGIC;
		led_verdes  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_rojos	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		hex			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000"; -- numero en 16 bits per codificar en els 4 7seg
		n_hex			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; --indica quin hex es vol mostrar
		-- PS2
		-----------------------------------------------
		read_char	: IN STD_LOGIC_VECTOR(7 downto 0);
		clear_char	: OUT std_logic;
		data_ready	: IN std_logic;
		-----------------------------------------------
		-- switches i keys
		SW 		  	: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		KEY		  	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		-----------------------------------------------
		-- interrupcions
		iid			: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		rd_switch	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		read_key	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		int_e		: IN STD_LOGIC;
		inta		: IN STD_LOGIC
	);
END controladores_io;

ARCHITECTURE Structure of controladores_io is

	TYPE t_io is array(0 to 32) of std_logic_vector(15 downto 0);
	SIGNAL io_mem: t_io;
	SIGNAL butons: std_logic_vector(3 downto 0);
	SIGNAL interruptors: std_logic_vector(7 downto 0);

BEGIN

	butons <= KEY when int_e = '0' else read_key;
	interruptors <= SW(7 downto 0) when int_e = '0' else rd_switch;

	PROCESS (CLOCK_50)
	BEGIN
		if rising_edge(CLOCK_50) then
			clear_char <= '0';
			if (wr_out = '1') then
				if (addr_io = x"10") then
					clear_char <= '1';
					io_mem(to_integer(unsigned(addr_io))) <= x"0000";
				else
					io_mem(to_integer(unsigned(addr_io))) <= wr_io;
				end if;
			else 
				io_mem(7)(3 downto 0) <= butons;
				io_mem(8)(7 downto 0) <= interruptors;
				io_mem(15)(7 downto 0) <= read_char;
				io_mem(16)(0) <= data_ready;
			END if;
		END if;
	END PROCESS;
	
	--rd_io <= io_mem(to_integer(unsigned(addr_io))) when rd_in = '1' else "XXXXXXXX" & iid;
	
	rd_io <= x"00"&iid when inta = '1' else io_mem(to_integer(unsigned(addr_io))) when rd_in = '1' else "XXXXXXXXXXXXXXXX";

	led_verdes <= io_mem(5)(7 downto 0);
	led_rojos <= io_mem(6)(7 downto 0);
	n_hex <= io_mem(9)(3 downto 0);
	hex <= io_mem(10);

END Structure;