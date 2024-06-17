LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

LIBRARY work;
USE work.renacuajo_pkg.all;



ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  tknbr		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		  aluout	: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  intr		: IN  STD_LOGIC;
		  int_e		: IN  STD_LOGIC;
		  except	: IN  STD_LOGIC;
		  exc_code	: IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
          op        : OUT INST;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
		  Rb_N 	    : OUT STD_LOGIC;
		  rd_in	    : OUT STD_LOGIC;
		  wr_out	: OUT STD_LOGIC;
		  addr_io   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  a_sys		: OUT STD_LOGIC;
		  a_fpu		: OUT STD_LOGIC;
		  d_sys		: OUT STD_LOGIC;
		  d_fpu		: OUT STD_LOGIC;
		  ei		: OUT STD_LOGIC;
		  di		: OUT STD_LOGIC;
		  reti		: OUT STD_LOGIC;
		  inta		: OUT STD_LOGIC;
		  sys		: OUT STD_LOGIC;
		  pc_sys : IN STD_LOGIC_VECTOR(15 downto 0);
		  call	 : OUT STD_LOGIC;
		  il_inst : OUT STD_LOGIC;
		  mem_op : OUT STD_LOGIC
		  );
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	COMPONENT control_l IS
	 PORT ( ir         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				op         : OUT INST;
				ldpc       : OUT STD_LOGIC;
				wrd        : OUT STD_LOGIC;
				addr_a     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				immed      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				wr_m       : OUT STD_LOGIC;
				in_d       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				immed_x2   : OUT STD_LOGIC;
				word_byte  : OUT STD_LOGIC;
				Rb_N       : OUT STD_LOGIC;
				addr_io	 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				wr_out	 : OUT STD_LOGIC;
				rd_in		 : OUT STD_LOGIC;
				a_sys		 : OUT STD_LOGIC;
				a_fpu		 : OUT STD_LOGIC;
				d_sys 	 : OUT STD_LOGIC;
				d_fpu	 : OUT STD_LOGIC;
				ei 		 : OUT STD_LOGIC;
				di		 : OUT STD_LOGIC;
				reti	 	 : OUT STD_LOGIC;
				geti		 : OUT STD_LOGIC;
				inta		 : OUT STD_LOGIC;
				call		 : OUT STD_LOGIC;
				il_inst	 : OUT STD_LOGIC;
				mem_op : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT multi IS 
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
		 op_l	   : IN  INST;
		 d_sys_l : IN STD_LOGIC;
		 except    : IN  STD_LOGIC;
         exc_code  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC;
         ei        : OUT STD_LOGIC;
         di        : OUT STD_LOGIC;
         inta      : OUT STD_LOGIC;
         in_d      : OUT STD_LOGIC_vector(1 downto 0);
         addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
         addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 op		   : OUT INST;
		 d_sys		: OUT STD_LOGIC;
		 sys		: OUT STD_LOGIC
 	);
	END COMPONENT;


	SIGNAL ir: std_logic_vector(15 downto 0);
	SIGNAL ir_reg: std_logic_vector(15 downto 0);
	SIGNAL pc_s: std_logic_vector(15 downto 0);
	SIGNAL ldpc: std_logic;
	SIGNAL ldir: std_logic;
	SIGNAL ldpc_s: std_logic;
	SIGNAL wrd_s: std_logic;
	SIGNAL wr_m_s: std_logic;
	SIGNAL word_byte_s: std_logic;
	SIGNAL pc_des: std_logic_vector(15 downto 0);
	SIGNAL immed_des: std_logic_vector(15 downto 0);
	SIGNAL reti_s : std_logic;
	SIGNAL inta_s : std_logic;
	SIGNAL ei_s : std_logic;
	SIGNAL di_s : std_logic;
	SIGNAL addr_a_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL addr_d_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL op_s : INST;
	SIGNAL in_d_s : std_logic_vector(1 downto 0);
	SIGNAL d_sys_s : STD_LOGIC;
	SIGNAL sys_s : STD_LOGIC;
	
BEGIN
	PROCESS (clk)
	BEGIN
		if rising_edge(clk) then
			if boot = '1' then
				pc_s <= x"C000";
			elsif ldpc = '0' then
				pc_s <= pc_s;
			else
				if sys_s = '1' then
					pc_s <= pc_sys;
				elsif tknbr = "10" then
					pc_s <= aluout;
				elsif tknbr = "11" then
					pc_s <= pc_des + 2;
				elsif reti_s = '1' then 
					pc_s <= aluout;
				else
					pc_s <= pc_s + 2;
				end if;
			END if;
			
			if boot = '1' then 
				ir <= x"0000";
			elsif ldir = '1' then
				ir <= datard_m;
			else
				ir <= ir;
			END if;
		END if;
	END PROCESS;

    --! Immediat x 2
	immed_des <= ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7 downto 0) & '0'; 
	--! Immeditat x 2 + PC
	pc_des <= std_logic_vector(unsigned(pc_s) + unsigned(immed_des));

	pc <= pc_s;
	
	m: multi
		PORT map(
			clk => clk,
			boot => boot,
			ldpc_l => ldpc_s,
			wrd_l => wrd_s,
			wr_m_l => wr_m_s,
			w_b => word_byte_s,
			intr => intr,
			inta_l => inta_s,
			ei_l => ei_s,
			di_l => di_s,
			int_e => int_e,
			in_d_l => in_d_s,
			addr_d_l => addr_d_s,
			addr_a_l => addr_a_s,
			op_l => op_s,
			d_sys_l => d_sys_s,
			ldpc => ldpc,
			wrd => wrd,
			wr_m => wr_m,
			ldir => ldir,
			ins_dad => ins_dad,
			word_byte => word_byte,
			ei => ei,
			di => di,
			inta => inta,
			in_d => in_d,
			addr_a => addr_a,
			addr_d => addr_d,
			op => op,
			d_sys => d_sys,
			sys => sys_s,
			except => except,
			exc_code => exc_code
		);
	
	c_l: control_l
		PORT map(
			ir => ir,
			op => op_s,
			ldpc => ldpc_s,
			wrd => wrd_s,
			addr_a => addr_a_s,
			addr_b => addr_b,
			addr_d => addr_d_s,
			immed => immed,
			wr_m => wr_m_s,
			in_d => in_d_s,
			immed_x2 => immed_x2,
			word_byte => word_byte_s,
			Rb_N => Rb_N,
			rd_in => rd_in,
			wr_out => wr_out,
			addr_io => addr_io,
			a_sys => a_sys,
			a_fpu => a_fpu,
			d_sys => d_sys_s,
			d_fpu => d_fpu,
			ei => ei_s,
			di => di_s, 
			reti => reti_s,
			inta => inta_s,
			call => call,
			il_inst => il_inst,
			mem_op => mem_op
		);
	
		reti <= reti_s;
		sys <= sys_s;
		
END Structure;