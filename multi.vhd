library ieee;
USE ieee.std_logic_1164.all;

library work;
USE work.renacuajo_pkg.all;

entity multi is
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
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
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
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
			d_sys		 : OUT STD_LOGIC;
            sys    : OUT STD_LOGIC
     );
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados
    TYPE state_t is (F, DEMW, SYSTEM);

    SIGNAL state: state_t; 

begin

    -- Aqui iria la m quina de estados del modelos de Moore que gestiona el multiciclo
    -- Aqui irian la generacion de las senales de control que su valor depende del ciclo en que se esta.
    PROCESS (clk, boot)
    BEGIN
        if boot = '1' then 
            state <= F;
        END if;

        if rising_edge(clk) then 
            case state IS
                when F => 
                    if except = '1' and exc_code = x"1" then
                        state <= SYSTEM;
                    else
                        state <= DEMW;
                    END if;
                when DEMW => 
                    if (intr = '1' and int_e = '1') or except = '1' then 
                        state <= SYSTEM;
                    else 
                        state <= F;
                    END if;
                when SYSTEM => 
                    state <= F;
                END case;
		 else 
			state <= state;
		 END if;
    END PROCESS;

    ldir <= '1' when state = F else '0';
    ins_dad <= '0' when state = F else '1';
    ei <= ei_l when state = DEMW else '0';
    di <= di_l when state = DEMW else '0';
    inta <= inta_l when state = DEMW else '0';
    d_sys <= '1' when state = SYSTEM else d_sys_l;
    wrd <= wrd_l when state = DEMW else
            '1' when state = SYSTEM else 
            '0';
    wr_m <= wr_m_l when state = DEMW else '0';
    word_byte <= w_b when state = DEMW else '0';
    ldpc <= ldpc_l when state = DEMW or state = SYSTEM else '0';
    in_d <= "10" when state = SYSTEM else in_d_l;
    addr_d <= "001" when state = SYSTEM else addr_d_l;
    addr_a <= "101" when state = SYSTEM else addr_a_l;
    op <= WRS_I when state = SYSTEM else op_l;
    sys <= '1' when state = SYSTEM else '0';

end Structure;