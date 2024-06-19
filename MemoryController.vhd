LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

entity MemoryController is
    port (CLOCK_50  : in  std_logic;
	      addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- seÃ±ales para la placa de desarrollo
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
        mem_op      : IN STD_LOGIC;
		    vec				: IN STD_LOGIC;
			 wr_vdata		: IN STD_LOGIC_VECTOR(127 DOWNTO 0);
			 rd_vec			: OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
			 done 			: OUT STD_LOGIC
        
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
  TYPE wr_state_t is (INI, VEC_WRITE, VEC_WAIT);
  TYPE rd_state_t is (INI, VEC_READ, VEC_WAIT);
  SIGNAL wr_state: wr_state_t;
  SIGNAL rd_state: rd_state_t;
  SIGNAL counter_wr: std_LOGIC_VECTOR(3 downto 0);
  SIGNAL counter_rd: std_LOGIC_VECTOR(3 downto 0);
  SIGNAL wr_data_s: std_logic_vector(15 downto 0);
  SIGNAL addr_s: std_logic_vector(15 downto 0);
  SIGNAL wr_vec: std_logic_vector(15 downto 0);
  SIGNAL wr_done: std_logic;
  SIGNAL rd_done: stD_logic;
  SIGNAL rd_data_s: std_logic_vector(15 downto 0);
  SIGNAL rd_vec_s: std_logic_vector(127 downto 0);
  SIGNAL wr_vdata_s: std_logic_vector(127 downto 0);
  SIGNAL addr_s1: std_logic_vector(15 downto 0);
  SIGNAL addr_wr: std_logic_vector(15 downto 0);
  SIGNAL addr_rd: std_logic_vector(15 downto 0);
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
      address       => addr_s,
      dataReaded    => rd_data_s,
      dataToWrite   => wr_data_s,
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

  addr_s <= addr when vec = '0' else
            addr_s1;
				
	addr_s1 <= addr_rd when vec = '1' and we = '0' else
				  addr_wr;
				
	wr_data_s <= wr_data when vec = '0' else
					 wr_vec;

  -- control estat store
  PROCESS (CLOCK_50)  
  BEGIN
    if write_s = '0' then
      wr_state <= INI;
    elsif rising_edge(CLOCK_50) then 
      if vec = '1' and write_s = '1' then
        case wr_state is 
          when INI => 
            wr_state <= VEC_WRITE;
          when VEC_WRITE =>
            wr_state <= VEC_WAIT;
			 when VEC_WAIT =>
				wr_state <= VEC_WRITE;
          when others =>
            wr_state <= wr_state;
        END case;
      END if;
    END if;
  END PROCESS;

  PROCESS (CLOCK_50)
  BEGIN 
      case wr_state is 
        when INI => 
          wr_vec <= wr_vec;
			 counter_wr <= x"0";
			addr_wr <= addr;
        when VEC_WRITE => 
          wr_vec <= wr_vec;
        when VEC_WAIT =>
          counter_wr <= counter_wr + 1;
          addr_wr <= addr_wr + 2;
          wr_vdata_s <= std_logic_vector(shift_left(unsigned(wr_vdata), 16));
			 wr_vec <= wr_vdata_s(15 downto 0);
      END case;

      wr_done <= counter_wr(3);

  END PROCESS;



  rd_data <= rd_data_s;
  
  --load

  --todo 

  PROCESS (CLOCK_50)  
  BEGIN
    if write_s = '0' then
      rd_state <= INI;
    elsif rising_edge(CLOCK_50) then 
      if vec = '1' and write_s = '0' then
        case rd_state is 
          when INI => 
            rd_state <= VEC_READ;
          when VEC_READ =>
            rd_state <= VEC_WAIT;
			 when VEC_WAIT => 
				rd_state <= VEC_READ;
          when others =>
            rd_state <= rd_state;
        END case;
      END if;
    END if;
  END PROCESS;

  PROCESS (CLOCK_50)
  BEGIN 
      case rd_state is 
        when INI => 
          rd_vec_s <= rd_vec_s;
			 counter_rd <= x"0";
			 addr_rd <= addr + 16;
        when VEC_READ => 
          rd_vec_s <= rd_vec_s;
        when VEC_WAIT =>
          counter_rd <= counter_rd + 1;
          addr_rd <= addr_rd - 2;
			 rd_vec_s(15 downto 0) <= rd_data_s;
			 rd_vec_s <= std_logic_vector(shift_right(unsigned(rd_vec_s), 16));
      END case;

      rd_done <= counter_rd(3);
		
		if rd_done = '1' then 
			rd_vec <= rd_vec_s;
		END if;

  END PROCESS;
	
  done <= rd_done or wr_done;

end comportament;
