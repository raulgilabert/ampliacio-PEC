library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bf16_unit is
    port(
        clk: in std_logic;
        reset: in std_logic;
        in1: in std_logic_vector(15 downto 0) ;
        in2: in std_logic_vector(15 downto 0) ;
        funct5: in std_logic_vector(4 downto 0) ;
        result: out std_logic_vector(15 downto 0);
        of_fp : out std_logic
    );
end bf16_unit;

architecture rtl of bf16_unit is
    component bf16_add_sub
        port(
            clk: in std_logic;
            reset: in std_logic;
            in1: in std_logic_vector(15 downto 0) ;
            in2: in std_logic_vector(15 downto 0) ;
            funct5: in std_logic_vector(4 downto 0) ;
            result: out std_logic_vector(15 downto 0);
            of_add_sub: out std_logic
        );
    end component;

    component bf16_mult
        port(
            clk: in std_logic;
            reset: in std_logic;
            in1: in std_logic_vector(15 downto 0) ;
            in2: in std_logic_vector(15 downto 0) ;
            result: out std_logic_vector(15 downto 0);
            of_mult: out std_logic
        );
    end component;

    component bf16_div
        port(
            clk: in std_logic;
            reset: in std_logic;
            in1: in std_logic_vector(15 downto 0) ;
            in2: in std_logic_vector(15 downto 0) ;
            result: out std_logic_vector(15 downto 0);
            of_div: out std_logic
        );
    end component;

    component mux_funct5
        port(
            add_sub: in std_logic_vector(15 downto 0) ;
            mult: in std_logic_vector(15 downto 0) ;
            div: in std_logic_vector(15 downto 0) ;
            funct5: in std_logic_vector(4 downto 0) ;
            result: out std_logic_vector(15 downto 0)
        );
    end component;

    -- We have to save the value of funct5 in pipeline registers
    signal p1_funct5: std_logic_vector(4 downto 0) ;
    signal p2_funct5: std_logic_vector(4 downto 0) ;
    signal p3_funct5: std_logic_vector(4 downto 0) ;

    -- Connect output of each circuit to multiplexer
    signal mux_add_sub: std_logic_vector(15 downto 0) ;
    signal mux_mult: std_logic_vector(15 downto 0) ;
    signal mux_div: std_logic_vector(15 downto 0) ;

    signal of_add_sub, of_mult, of_div : std_logic;

begin
    add_sub: bf16_add_sub port map (    clk => clk,
                                        reset => reset,
                                        in1 => in1,
                                        in2 => in2,
                                        funct5 => funct5,
                                    	result => mux_add_sub,
                                        of_add_sub => of_add_sub );

    mult: bf16_mult port map (  clk => clk,
                                reset => reset,
                                in1 => in1,
                                in2 => in2,
                                result => mux_mult,
                                of_mult => of_mult );

    div: bf16_div port map (    clk => clk,
				                reset => reset,
				                in1 => in1,
                        	    in2 => in2,
                             	result => mux_div,
                                of_div => of_div );

    mux: mux_funct5 port map (   add_sub => mux_add_sub,
                                 mult => mux_mult,
                                 div => mux_div,
                                 funct5 => p3_funct5,
                                 result => result );
    
    p_reg: process (clk, reset) is
        begin
            if (reset = '0') then
                p1_funct5 <= (others => '0');
                p2_funct5 <= (others => '0');
                p3_funct5 <= (others => '0');
            elsif rising_edge(clk) then
                p1_funct5 <= funct5;
                p2_funct5 <= p1_funct5;
                p3_funct5 <= p2_funct5;
            end if;
    end process p_reg;

    with p3_funct5
        select of_fp <= of_add_sub when "00000",
                        of_add_sub when "00001",
                        of_mult when "00010",
                        of_div when "00011",
                        '0' when others;
end architecture;





