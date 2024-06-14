LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

-- Do operations ADD, SUB, ADDI and address calculation
ENTITY addsub is
    PORT (
        x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op: IN INST;
        w : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END addsub;

-- with this architecture, we can do ADD, SUB, ADDI and address calculation
-- and have ready for use other data like the carry out for operations
-- with overflow for example
ARCHITECTURE Structural of addsub is
    SIGNAL y_op : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL cin : STD_LOGIC_VECTOR(0 DOWNTO 0);
BEGIN
    WITH op SELECT
        y_op <= not y when SUB_I,
                y     when others;
    
    WITH op SELECT
        cin <= "1" when SUB_I,
               "0" when others;

    -- bit 16: carry out; else result
    result <= std_logic_vector(unsigned(x) + unsigned(y_op) + unsigned(cin));

    w <= result(15 DOWNTO 0);

END Structural;