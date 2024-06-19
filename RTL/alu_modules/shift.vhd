LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY shift is
    PORT (
        x : IN std_logic_vector(15 DOWNTO 0);
        y : IN std_logic_vector(15 DOWNTO 0);
        op : IN INST;
        w : OUT std_logic_vector(15 DOWNTO 0)
    );
END shift;

ARCHITECTURE Structural of shift is
    SIGNAL shl : std_logic_vector(15 DOWNTO 0);
    SIGNAL sha : std_logic_vector(15 DOWNTO 0);
BEGIN
    shl <= std_logic_vector(shift_left(unsigned(x), to_integer(signed(y(4 downto 0))))) when y(4) = '0' else
           std_logic_vector(shift_right(unsigned(x), to_integer(-signed(y(4 downto 0)))));

    sha <= std_logic_vector(shift_left(signed(x), to_integer(signed(y(4 downto 0))))) when y(4) = '0' else
           std_logic_vector(shift_right(signed(x), to_integer(-signed(y(4 downto 0)))));
    
    w <= sha when op = SHA_I or op = SHAV_I else
         shl when op = SHL_I or op = SHLV_I else
         x"0000";
END Structural;

