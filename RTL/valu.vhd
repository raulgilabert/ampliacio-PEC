LIBRARY ieee;
USE ieee.numeric_std.all;
USE ieee.std_logic_1164.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY valu IS
    PORT (
        x_vec       : IN  STD_LOGIC_VECTOR(127 downto 0);
        x_sca       : IN  STD_LOGIC_VECTOR(15 downto 0);
        y           : IN  STD_LOGIC_VECTOR(127 downto 0);
        immed       : IN  STD_LOGIC_VECTOR(2 downto 0);
        op          : IN  INST;
        w_vec       : OUT STD_LOGIC_VECTOR(127 downto 0);
        w_sca       : OUT STD_LOGIC_VECTOR(15 downto 0);
        div_zero    : OUT STD_LOGIC
    );
END valu;

ARCHITECTURE Structure OF valu IS
    COMPONENT addsub IS
        PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : IN INST;
              w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT mul IS
        PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : IN INST;
              w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT shift IS
        PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : IN INST;
              w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    END COMPONENT;

    SIGNAL new_vec_reg: STD_LOGIC_VECTOR(127 downto 0);
    SIGNAL add_sub_res: STD_LOGIC_VECTOR(127 downto 0);
    SIGNAL mul_res:     STD_LOGIC_VECTOR(127 downto 0);
    SIGNAL shift_res:   STD_LOGIC_VECTOR(127 downto 0);

BEGIN
    -- Asignación de new_vec_reg basada en immed
    with immed select
        new_vec_reg <= (x_vec(127 downto 16) & x_sca) when "000",  -- Selección para immed "000"
                       (x_vec(127 downto 32) & x_sca & x_vec(15 downto 0)) when "001",  -- Selección para immed "001"
                       (x_vec(127 downto 48) & x_sca & x_vec(31 downto 0)) when "010",  -- Selección para immed "010"
                       (x_vec(127 downto 64) & x_sca & x_vec(47 downto 0)) when "011",  -- Selección para immed "011"
                       (x_vec(127 downto 80) & x_sca & x_vec(63 downto 0)) when "100",  -- Selección para immed "100"
                       (x_vec(127 downto 96) & x_sca & x_vec(79 downto 0)) when "101",  -- Selección para immed "101"
                       (x_vec(127 downto 112) & x_sca & x_vec(95 downto 0)) when "110",  -- Selección para immed "110"
                       (x_sca & x_vec(111 downto 0)) when "111",  -- Selección para immed "111"
                       (others => 'X') when others;  -- Caso por defecto

    -- Asignación de w_vec basada en op
    with op select
        w_vec <= new_vec_reg when MVRV_I,
                 add_sub_res when ADDV_I,
                 add_sub_res when SUBV_I,
                 mul_res when MULV_I,
                 mul_res when MULHV_I,
                 mul_res when MULHUV_I,
                 shift_res when SHAV_I,
                 shift_res when SHLV_I,
                 (others => 'X') when others;

    -- Inicialización de señales no utilizadas
    with immed select
        w_sca <= x_vec(15 downto 0) when "000",
                 x_vec(31 downto 16) when "001",
                 x_vec(47 downto 32) when "010",
                 x_vec(63 downto 48) when "011",
                 x_vec(79 downto 64) when "100",
                 x_vec(95 downto 80) when "101",
                 x_vec(111 downto 96) when "110",
                 x_vec(127 downto 112) when "111",
                 (others => 'X') when others;

    div_zero <= '0';

    add_sub_gen: for i in 0 to 7 generate
        add_sub_i: addsub PORT MAP(
            x => x_vec(15 + 16*i downto 16*i),
            y => y(15 + 16*i downto 16*i),
            op => op,
            w => add_sub_res(15 + 16*i downto 16*i)
        );
    end generate;

    mul_gen: for i in 0 to 7 generate
        mul_i: mul PORT MAP(
            x => x_vec(15 + 16*i downto 16*i),
            y => y(15 + 16*i downto 16*i),
            op => op,
            w => mul_res(15 + 16*i downto 16*i)
        );
    end generate;

   shift_gen: for i in 0 to 7 generate
        shift_i: shift PORT MAP(
            x => x_vec(15 + 16*i downto 16*i),
            y => y(15 + 16*i downto 16*i),
            op => op,
            w => shift_res(15 + 16*i downto 16*i)
        );
    end generate;


END Structure;