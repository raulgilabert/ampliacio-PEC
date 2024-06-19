library ieee;
USE ieee.std_logic_1164.all;

library work;
USE work.renacuajo_pkg.all;

entity multi is
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         vwrd_l    : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
         intr      : IN  STD_LOGIC;
         inta_l    : IN  STD_LOGIC;
         ei_l      : IN  STD_LOGIC;
         di_l      : IN  STD_LOGIC;
         int_e     : IN  STD_LOGIC; -- interupt enable
		 in_d_l	   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
         addr_d_l  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
         addr_a_l  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
         op_l      : IN  INST;
			d_sys_l   : IN std_LOGIc;
         except   : IN  STD_LOGIC;
         exc_code : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			wrd_fpu_l : IN STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         vwrd      : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC;
         ei        : OUT STD_LOGIC;
         di        : OUT STD_LOGIC;
         inta      : OUT STD_LOGIC;
         in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
         addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         op        : OUT INST;
			wrd_fpu	 : OUT STD_LOGIC;
			d_sys		 : OUT STD_LOGIC;
            sys    : OUT STD_LOGIC;
            state     : OUT state_t
     );
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados
    SIGNAL state_s: state_t; 
    SIGNAL fp_op : boolean;

begin

    fp_op <= true when (op_l = ADDF_I or op_l = SUBF_I or op_l = MULF_I or op_l = DIVF_I or op_l = CMPLTF_I or op_l = CMPLEF_I or op_l = CMPEQF_I) else false;

    -- Aqui iria la m quina de estados del modelos de Moore que gestiona el multiciclo
    -- Aqui irian la generacion de las senales de control que su valor depende del ciclo en que se esta.
    PROCESS (clk, boot)
    BEGIN
        if boot = '1' then 
            state_s <= F;
        END if;

        if rising_edge(clk) then 
            case state_s IS
                when F => 
                    if except = '1' then
                        state_s <= SYSTEM;
                    else
                        state_s <= DEMW;
                    END if;
                when DEMW => 
                    if (intr = '1' and int_e = '1') or except = '1' then
                        state_s <= SYSTEM;
                    elsif (fp_op) then
                        state_s <= FP1;
                    else
                        state_s <= F;
                    END if;
                when SYSTEM => 
                    state_s <= F;
                when FP1 =>
                    state_s <= FP2;
                when FP2 =>
                    state_s <= FP3;
                when FP3 =>
                    state_s <= F;
            END case;
		 else 
			state_s <= state_s;
		 END if;
    END PROCESS;

    ldir <= '1' when state_s = F else '0';
    ins_dad <= '0' when state_s = F else '1';
    ei <= ei_l when state_s = DEMW else '0';
    di <= di_l when state_s = DEMW else '0';
    inta <= inta_l when state_s = DEMW else '0';
    d_sys <= '1' when state_s = SYSTEM and op_l /= RDS_I else d_sys_l;
    wrd <= wrd_l when state_s = DEMW or state_s = FP3 else
            '0' when state_s = SYSTEM else 
            '0';

    vwrd <= vwrd_l when state = DEMW else
            '0';
    wr_m <= wr_m_l when state_s = DEMW else '0';
    word_byte <= w_b when state_s = DEMW else '0';
    ldpc <= ldpc_l when (state_s = DEMW and not fp_op) or state_s = SYSTEM or state_s = FP3 else '0';
    in_d <= "10" when state_s = SYSTEM else in_d_l;
    addr_d <= "001" when state_s = SYSTEM else addr_d_l;
    addr_a <= "101" when state_s = SYSTEM else addr_a_l;
    op <= op_l;
    sys <= '1' when state_s = SYSTEM else '0';
    wrd_fpu <= wrd_fpu_l when state_s = DEMW or state_s = FP3 else '0';

    state <= state_s;
end Structure;
