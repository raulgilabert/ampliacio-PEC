LIBRARY ieee;
USE ieee.std_logic_1164.all;

package renacuajo_pkg is
    type INST is (
        AND_I, OR_I, XOR_I, NOT_I, ADD_I, SUB_I, SHA_I, SHL_I,      -- Arithmetic-logical instructions
        CMPLT_I, CMPLE_I, CMPEQ_I, CMPLTU_I, CMPLEU_I,              -- Comparison instructions
        ADDI_I,                                                     -- Immediate arithmetic instructions
        LD_I, ST_I,                                                 -- Memory instructions
        MOVI_I, MOVHI_I,                                            -- Immediate move instructions
        BZ_I, BNZ_I,                                                -- Branch instructions
		IN_I, OUT_I,																  -- Input/output instructions
        MUL_I, MULH_I, MULHU_I, DIV_I, DIVU_I,                      -- Multiplication and division instructions

        JZ_I, JNZ_I, JMP_I, JAL_I, CALL_I,                          -- Jump instructions
        
        LDB_I, STB_I,                                               -- Byte memory instructions

        EI_I, DI_I, RETI_I, GETIID_I, RDS_I, WRS_I, HALT_I,        -- Special instruction
        NOP_I, ILLEGAL_I                                            -- No operation and illegal instruction
    );

    TYPE state_t is (F, DEMW, SYSTEM);
    TYPE mode_t is (USER, SYSTEM);

-- OP CODES--
    constant OP_ARIT    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    constant OP_CMP     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    constant OP_ADDI    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
    constant OP_LD      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
    constant OP_ST      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
    constant OP_MOV     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
    constant OP_BRANCH  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
    constant OP_IO      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
    constant OP_MULDIV  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
    constant OP_JUMP    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
    constant OP_LDB     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
    constant OP_STB     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
    constant OP_SPECIAL : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";

-- FUNCTION CODES ARITH LOGIC
    constant F_AND      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    constant F_OR       : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    constant F_XOR      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    constant F_NOT      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    constant F_ADD      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    constant F_SUB      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";
    constant F_SHA      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";
    constant F_SHL      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";

-- FUNCTION CODES CMP
    constant F_CMPLT    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    constant F_CMPLE    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    constant F_CMPEQ    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    constant F_CMPLTU   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    constant F_CMPLEU   : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

-- FUNCTION CODES MUL/DIV
    constant F_MUL      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    constant F_MULH     : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    constant F_MULHU    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    constant F_DIV      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    constant F_DIVU     : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

-- FUNCTION CODES JUMP
    constant F_JZ       : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    constant F_JNZ      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    constant F_JMP      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    constant F_JAL      : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    constant F_CALL     : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";

-- FUNCTION CODES SPECIAL
    constant F_EI       : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100000";
    constant F_DI       : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100001";
    constant F_RETI     : STD_LOGIC_VECTOR(5 DOWNTO 0) := "100100";
    constant F_GETIID   : STD_LOGIC_VECTOR(5 DOWNTO 0) := "101000";
    constant F_RDS      : STD_LOGIC_VECTOR(5 DOWNTO 0) := "101100";
    constant F_WRS      : STD_LOGIC_VECTOR(5 DOWNTO 0) := "110000";
    constant F_HALT     : STD_LOGIC_VECTOR(5 DOWNTO 0) := "111111";

end package renacuajo_pkg;

package body renacuajo_pkg is
end package body renacuajo_pkg;