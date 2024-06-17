LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
--USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY regfile_fpu IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile_fpu;

ARCHITECTURE Structure OF regfile_fpu IS
    TYPE t_regs is array(0 to 7) of std_logic_vector(15 downto 0);
	SIGNAL fpu_regs: t_regs;

BEGIN
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(wrd = '1') then
				registre(conv_integer(addr_d)) <= d;
			end if;
		end if;
	end process;	
	
	a <= registre(conv_integer(addr_a));
	b <= registre(conv_integer(addr_b));

END Structure;