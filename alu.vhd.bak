LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;


ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : IN INST;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  z  : OUT STD_LOGIC;
          div_zero : OUT STD_LOGIC
             );
END alu;


ARCHITECTURE Structure OF alu IS
    COMPONENT addsub IS
        PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : IN INST;
              w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT cmp IS
        PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : IN INST;
              w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT div IS
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

    SIGNAL addsub_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL cmp_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL div_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mul_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL shift_res : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- BZ & BNZ not needed here because it checks if y = 0 and that is 
    -- controlled with z output signal
    w <= y                                when op = MOVI_I else
         y(7 downto 0) & x(7 downto 0)    when op = MOVHI_I else
         x and y                          when op = AND_I else
         x or y                           when op = OR_I else
         x xor y                          when op = XOR_I else
         not x                            when op = NOT_I else
         addsub_res                       when op = ADD_I or op = SUB_I or op = ADDI_I or op = LD_I or op = ST_I or op = LDB_I or op = STB_I or LDV_I or STV_I else
         cmp_res                          when op = CMPLT_I or op = CMPLE_I or op = CMPEQ_I or op = CMPLTU_I or op = CMPLEU_I else
         mul_res                          when op = MUL_I or op = MULH_I or op = MULHU_I else
         div_res                          when op = DIV_I or op = DIVU_I else
         shift_res                        when op = SHA_I or op = SHL_I else
         x                                when op = JZ_I or op = JNZ_I or op = JMP_I or op = JAL_I or op = RETI_I or op = EI_I or op = DI_I or op = WRS_I or op = RDS_I else
         "XXXXXXXXXXXXXXXX";

	z <= '1' when y = x"0000" else '0';

    div_zero <= '1' when y = x"0000" and (op = DIV_I or op = DIVU_I) else '0';

    addsub_inst : addsub PORT MAP (x, y, op, addsub_res);
    cmp_inst : cmp PORT MAP (x, y, op, cmp_res);
    div_inst : div PORT MAP (x, y, op, div_res);
    mul_inst : mul PORT MAP (x, y, op, mul_res);
    shift_inst : shift PORT MAP (x, y, op, shift_res);
END Structure;
