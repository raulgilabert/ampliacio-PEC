LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

-- Do compare operations
ENTITY cmp is
    PORT (
        x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op: IN INST;
        w : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END cmp;

ARCHITECTURE Structural of cmp is
    SIGNAL less : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL eq : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    less <= x"0001" when (op = CMPLT_I or op = CMPLE_I) and signed(x) < signed(y) else
            x"0001" when (op = CMPLTU_I or op = CMPLEU_I) and unsigned(x) < unsigned(y) else
            x"0000";
    
    eq <= x"0001" when x = y else 
          x"0000";
    
    w <= less or eq or x"0000" when op = CMPLE_I or op = CMPLEU_I else
         less       or x"0000" when op = CMPLT_I or op = CMPLTU_I else
         eq         or x"0000" when op = CMPEQ_I else
         x"0000";

END Structural;