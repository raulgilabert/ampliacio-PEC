LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY div is
    PORT (
        x : IN std_logic_vector(15 DOWNTO 0);
        y : IN std_logic_vector(15 DOWNTO 0);
        op : IN INST;
        w : OUT std_logic_vector(15 DOWNTO 0)
    );
END div;

ARCHITECTURE Structural of div is
BEGIN
    w <= std_logic_vector(signed(x) / signed(y)) WHEN op = DIV_I else
         std_logic_vector(unsigned(x) / unsigned(y)) WHEN op = DIVU_I else
         x"0000";
END Structural;
