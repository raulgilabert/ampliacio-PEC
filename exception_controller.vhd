LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;  

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY exception_controller IS
    PORT (
        clk     : IN  STD_LOGIC;
        boot    : IN  STD_LOGIC;
        alu_in  : IN  STD_LOGIC; -- div_zero
        mem_in  : IN  STD_LOGIC; -- alinacio impar
        con_in  : IN  STD_LOGIC; -- inst ilegal
        int_in  : IN  STD_LOGIC; -- interrupcio
        call_in : IN  STD_LOGIC; -- syscall
        inst_prot : IN  STD_LOGIC; -- instruccio protegida
        mem_prot  : IN  STD_LOGIC; -- memoria protegida
        exc_code: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        except  : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE Structure OF exception_controller IS


BEGIN

    PROCESS (clk)
    BEGIN
        if rising_edge(clk) then 
            if alu_in = '1' then 
                exc_code <= x"4";
            elsif mem_in = '1' then 
                exc_code <= x"1";
            elsif con_in = '1' then 
                exc_code <= x"0";
            elsif inst_prot = '1' then
                exc_code <= x"D";
            elsif mem_prot = '1' then
                exc_code <= x"B";
            elsif call_in = '1' then 
                exc_code <= x"E";
            elsif int_in = '1' then 
                exc_code <= x"F";
           END if;
        END if;
    END PROCESS;

    except <= alu_in or mem_in or con_in or inst_prot or mem_prot or call_in when boot = '0' else '0';


END Structure;