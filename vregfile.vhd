LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY vregfile IS
    PORT (
        clk         : IN  std_logic;
        wrd         : IN  std_logic;
        d           : IN  std_logic_vector(127 downto 0);
        addr_a 	    : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
	    addr_b 	    : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		addr_d 	    : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
        a           : OUT STD_LOGIC_VECTOR(127 downto 0);
        b           : OUT STD_LOGIC_VECTOR(127 downto 0);
        old_d       : OUT STD_LOGIC_VECTOR(127 downto 0)
    );
end vregfile;

ARCHITECTURE Structure of vregfile IS
	TYPE t_vregs is array(0 to 7) of std_logic_vector(127 downto 0);

    SIGNAL vregs: t_vregs;
BEGIN
    PROCESS (clk)
    BEGIN
        if rising_edge(clk) then
            if (wrd = '1') then
                vregs(to_integer(unsigned(addr_d))) <= d;
            end if;
        old_d <= vregs(to_integer(unsigned(addr_d)));
        end if;
    END PROCESS;

    a <= vregs(to_integer(unsigned(addr_a)));
    b <= vregs(to_integer(unsigned(addr_b)));
END Structure;