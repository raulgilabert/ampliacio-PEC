LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

entity MemoryController is
    port (CLOCK_50  : in  std_logic;
	      addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- señales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
        -- VGA
        -----------------------------------------------
        addr_VGA		: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        we_VGA		: OUT STD_LOGIC;
        wr_data_VGA	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        rd_data_VGA	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        vga_byte_m : out std_logic;
        mem_except: OUT STD_LOGIC;
        mem_op      : IN STD_LOGIC
	
          );
end MemoryController;

architecture comportament of MemoryController is
  COMPONENT SRAMController IS
    PORT (
      clk:          in      std_logic;
      SRAM_ADDR:    out     std_logic_vector(17 downto 0);
      SRAM_DQ:      inout   std_logic_vector(15 downto 0);
      SRAM_UB_N:    out     std_logic;
      SRAM_LB_N:    out     std_logic;
      SRAM_CE_N:    out     std_logic := '1';
      SRAM_OE_N:    out     std_logic := '1';
      SRAM_WE_N:    out     std_logic := '1';
      address:      in      std_logic_vector(15 downto 0) := x"0000";
      dataReaded:   out     std_logic_vector(15 downto 0);
      dataToWrite:  in      std_logic_vector(15 downto 0);
      WR:           in      std_logic;
      byte_m:       in      std_logic := '0'
    );
  END COMPONENT;

  SIGNAL write_s: std_logic;
  SIGNAL data: std_logic_vector(15 downto 0);
  SIGNAL VGA_addr_s: std_logic_vector(12 downto 0);

begin

  sram_c: SRAMController
    PORT map(
      clk           => CLOCK_50,
      SRAM_ADDR     => SRAM_ADDR,
      SRAM_DQ       => SRAM_DQ,
      SRAM_UB_N     => SRAM_UB_N,
      SRAM_LB_N     => SRAM_LB_N,
      SRAM_CE_N     => SRAM_CE_N,
      SRAM_OE_N     => SRAM_OE_N,
      SRAM_WE_N     => SRAM_WE_N,
      address       => addr,
      dataReaded    => rd_data,
      dataToWrite   => wr_data,
      WR            => write_s,
      byte_m        => byte_m
    );

	write_s <= we when addr < x"C000" else
			   '0';
				
	
	----------------------------------------------
	-- VGA
	VGA_addr_s <= addr(12 downto 0);--std_LOGIC_VECTOR(unsigned(addr) - x"A000");
	 
	addr_VGA <= VGA_addr_s when addr >= x"A000" and addr <= x"B2BE" else "0000000000000";
	we_VGA <= '1' when addr >= x"A000" and addr <= x"B2BE" else '0';
  wr_data_VGA <= wr_data;
  vga_byte_m <= byte_m;

  mem_except <= '1' when byte_m = '0' and addr(0) = '1' and mem_op = '1' else '0';

  --SRAM_DQ <= data;
	
end comportament;
