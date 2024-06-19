library ieee;
use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SRAMController is
    port (clk         : in    std_logic;
          -- se�ales para la placa de desarrollo
          SRAM_ADDR   : out   std_logic_vector(17 downto 0); -- adreça dades
          SRAM_DQ     : inout std_logic_vector(15 downto 0); -- bus de dades
          SRAM_UB_N   : out   std_logic; -- upper byte
          SRAM_LB_N   : out   std_logic; -- lower byte
          SRAM_CE_N   : out   std_logic := '1'; -- chip enable
          SRAM_OE_N   : out   std_logic := '1'; -- output enable
          SRAM_WE_N   : out   std_logic := '1'; -- write enable
          -- se�ales internas del procesador
          address     : in    std_logic_vector(15 downto 0) := x"0000";
          dataReaded  : out   std_logic_vector(15 downto 0);
          dataToWrite : in    std_logic_vector(15 downto 0);
          WR          : in    std_logic;
          byte_m      : in    std_logic := '0');
end SRAMController;

architecture comportament of SRAMController is
	TYPE state_t is (WRITE_0, WRITE_1, WRITE_2);
	SIGNAL state: state_t;
	SIGNAL data_wr: std_logic_vector(15 downto 0);
	SIGNAL condition_byte_select: std_logic;
	SIGNAL condition_byte_read: std_logic_vector(1 downto 0);
	
	begin
	-- combinational assignation
	SRAM_CE_N <= '0'; -- always downto
	SRAM_OE_N <= '0'; -- 0 on read, X on write => 0
	SRAM_ADDR <= "000" & address(15 downto 1);
	
	condition_byte_read <= byte_m & address(0);
	
	-- if byte access fill with Z the word space not used
	with condition_byte_read select
		data_wr <= "ZZZZZZZZ" & dataToWrite(7 downto 0) when "10",
					  dataToWrite(7 downto 0) & "ZZZZZZZZ" when "11",
		           dataToWrite when others;
	-- if write send data_wr if read set all Z
	with WR select
		SRAM_DQ <= "ZZZZZZZZZZZZZZZZ" when '0',
					  data_wr when others;

	 with condition_byte_read select
		dataReaded <= std_logic_vector(resize(signed(SRAM_DQ(7 downto 0)), 16)) when "10",
						  std_logic_vector(resize(signed(SRAM_DQ(15 downto 8)), 16)) when "11",
						  SRAM_DQ when others;
	
	-- write only enabled afther first cycle of write instruction
	
	
	PROCESS (state) 
	BEGIN 
		if (state = WRITE_1) then 
			SRAM_WE_N <= '0';
		else 
			SRAM_WE_N <= '1';
		END if;
	END PROCESS;
	
	--with state select
		--SRAM_WE_N <= '0' when WRITE_1,
			--			 '1' when others;
	
	-- byte selected only on write, when reading we read the full word and select the byte
	condition_byte_select <= WR and byte_m;
	
	with condition_byte_select select
		SRAM_LB_N <= address(0) when '1',
						 '0' when others;

	with condition_byte_select select
		SRAM_UB_N <= not address(0) when '1',
						 '0' when others;
 
	PROCESS (WR, clk)
	BEGIN
		if (WR = '0') then
			state <= WRITE_0;

		-- we only access here when clk changes and we are writing
		elsif rising_edge(clk) then
			case state is
				when WRITE_0 =>
					state <= WRITE_1;
				when WRITE_1 =>
					state <= WRITE_2;
				when others =>
					state <= state;
			end case;
		end if;
	END PROCESS;
end comportament;
