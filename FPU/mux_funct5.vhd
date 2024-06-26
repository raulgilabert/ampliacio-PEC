library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_funct5 is
    port(
        add_sub: in std_logic_vector(15 downto 0) ;
        mult: in std_logic_vector(15 downto 0) ;
        div: in std_logic_vector(15 downto 0) ;
        funct5: in std_logic_vector(4 downto 0) ;
        result: out std_logic_vector(15 downto 0)
    );
end mux_funct5;

architecture rtl of mux_funct5 is
    signal less : std_logic;
    signal eq : std_logic;
begin

    less <= add_sub(15);
    eq <= '1' when add_sub = x"0000" else '0';

    with funct5 select
        result <= add_sub when "00000"|"00001",
                  mult when "00010",
                  div when "00011",
                  "000000000000000" & less when "00100",
                  "000000000000000" & (less or eq) when "00101",
                  "000000000000000" & eq when "00111",
                  (others => '0') when others;
end architecture;