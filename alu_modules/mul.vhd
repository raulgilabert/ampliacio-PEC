LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY mul is
    PORT (
        x : IN std_logic_vector(15 DOWNTO 0);
        y : IN std_logic_vector(15 DOWNTO 0);
        op : IN INST;
        w : OUT std_logic_vector(15 DOWNTO 0)
    );
END mul;

ARCHITECTURE Structural of mul is
    SIGNAL mult_result : std_logic_vector(31 DOWNTO 0);
BEGIN
    mult_result <= std_logic_vector(signed(x) * signed(y)) WHEN op = MUL_I or op = MULH_I else
                   std_logic_vector(unsigned(x) * unsigned(y)) WHEN op = MULHU_I else
                   x"00000000";

    w <= mult_result(15 DOWNTO 0) when op = MUL_I else
         mult_result(31 DOWNTO 16) when op = MULH_I or op = MULHU_I else
         x"0000";
END Structural;

