LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;
USE work.renacuajo_pkg.all;


ENTITY proc IS
	PORT (clk 			: IN STD_LOGIC;
			boot 			: IN STD_LOGIC;
			datard_m 	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m 		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m 			: OUT STD_LOGIC;
			word_byte 	: OUT STD_LOGIC;
			addr_io	  	: out std_LOGIC_VECTOR(7 DOWNTO 0);
			rd_io			: in std_LOGIC_vector(15 DOWNTO 0);
			wr_io			: out std_LOGIC_VECTOR(15 downto 0);
			rd_in			: out std_LOGIC;
			wr_out 		: out std_logic;
			intr		: in std_logic;
			inta		: out std_logic;
			int_e		: out std_logic;
			except 		: in std_logic;
			exc_code 	: in std_logic_vector(3 DOWNTO 0);
			div_zero 	: out std_logic;
			il_inst 	: out std_logic;
			call 		: out std_logic;
			mem_op 	: out std_logic;
			mode		: out mode_t;
			inst_prot	: out std_logic;
			of_en		: out std_logic;
			div_z_fp	: out std_logic;
			of_fp		: out std_logic
	);
END proc;


ARCHITECTURE Structure OF proc IS

	COMPONENT unidad_control IS
	    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 aluout    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		    tknbr     : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			intr	: IN  STD_LOGIC;
			int_e	: IN STD_LOGIC;
			except	: IN STD_LOGIC;
			exc_code	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
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
			 Rb_N		  : OUT STD_LOGIC;
			 rd_in	  : OUT STD_LOGIC;
			 wr_out	  : OUT STD_LOGIC;
			 addr_io   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			 d_sys	   : OUT STD_LOGIC;
			 a_sys	   : OUT STD_LOGIC;
			 ei 	   : OUT STD_LOGIC;
			 di		: OUT STD_LOGIC;
			 reti	   : OUT STD_LOGIC;
			 inta	   : OUT STD_LOGIC;
			 sys   	: OUT STD_LOGIC;
			 pc_sys  : IN STD_LOGIC_VECTOR(15 downto 0);
			 call   : OUT STD_LOGIC;
			 il_inst : OUT STD_LOGIC;
			 mem_op : OUT STD_LOGIC;
			 mode	: IN mode_t;
			 inst_prot : OUT std_logic;
			 wrd_fpu : OUT STD_LOGIC
		 );
	END COMPONENT;
	
	COMPONENT datapath IS
		 PORT (clk      : IN  STD_LOGIC;
				 op       : IN INST;
				 wrd      : IN  STD_LOGIC;
				 addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				 immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 immed_x2 : IN  STD_LOGIC;
				 datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 ins_dad  : IN  STD_LOGIC;
				 pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				 Rb_N     : IN STD_LOGIC;
				 rd_io	 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
				 d_sys	 : IN STD_LOGIC;
				 a_sys	 : IN STD_LOGIC;
				 ei 	 : IN STD_LOGIC;
				 di 	 : IN STD_LOGIC;
				 reti	 : IN STD_LOGIC;
				 boot	 : IN STD_LOGIC;
				 --intr	 : IN STD_LOGIC;
				 sys	: IN STD_LOGIC;
				 wrd_fpu  : IN STD_LOGIC;
				 addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 aluout	 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 tknbr    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				 wr_io    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 int_e	 : OUT STD_LOGIC;
				 pc_sys   : OUT STD_LOGIC_VECTOR(15 downto 0);
				 except	 : IN STD_LOGIC;
				 exc_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				 div_zero : OUT STD_LOGIC;
				 mode : OUT mode_t;
				 call : IN std_logic;
				 of_en : out std_logic;
				 div_z_fp : out std_logic;
				 of_fp: out std_logic
		 );	
	END COMPONENT;

		SIGNAL immed_x2: std_logic;
		SIGNAL in_d: std_logic_vector(1 downto 0);
		SIGNAL ins_dad: std_logic;
		SIGNAL wrd: std_logic;
		SIGNAL op: INST;
		SIGNAL addr_a: std_logic_vector(2 downto 0);
		SIGNAL addr_b: std_logic_vector(2 downto 0);
		SIGNAL addr_d: std_logic_vector(2 downto 0);
		SIGNAL immed: std_logic_vector(15 downto 0);
		SIGNAL pc: std_logic_vector(15 downto 0);
		SIGNAL Rb_N : std_logic;
		SIGNAL aluout: std_logic_vector(15 downto 0);
		SIGNAL tknbr: std_logic_vector(1 downto 0);
		SIGNAL d_sys_s : std_logic;
		SIGNAL a_sys_s : std_logic;
		SIGNAL ei_s : std_logic; 	 
		SIGNAL di_s : std_logic; 	 
		SIGNAL reti_s : std_logic;	
		SIGNAL int_e_s : std_logic;
		SIGNAL sys_s : STD_LOGIC;
		SIGNAL pc_sys : STD_LOGIC_VECTOR(15 downto 0);
		SIGNAL mode_s : mode_t;
		SIGNAL call_s : std_logic;
		SIGNAL wrd_fpu_s : STD_LOGIC;
BEGIN

		c0: unidad_control
			PORT map(
				boot => boot,
				clk => clk,
				datard_m => datard_m,
				aluout => aluout,
				tknbr => tknbr,
				op => op,
				wrd => wrd,
				addr_a => addr_a,
				addr_b => addr_b,
				addr_d => addr_d,
				immed => immed,
				pc => pc,
				ins_dad => ins_dad,
				in_d => in_d,
				immed_x2 => immed_x2,
				wr_m => wr_m,
				word_byte => word_byte,
				Rb_N => Rb_N,
				rd_in => rd_in,
				wr_out => wr_out,
				addr_io => addr_io,
				d_sys => d_sys_s,
				a_sys => a_sys_s, 
				ei => ei_s,
				di => di_s,
				reti => reti_s,
				intr => intr,
				inta => inta,
				int_e => int_e_s,
				sys => sys_s,
				pc_sys => pc_sys,
				except => except,
				exc_code => exc_code,
				call => call_s,
				il_inst => il_inst,
			mem_op => mem_op,
			mode => mode_s,
			inst_prot => inst_prot,
				wrd_fpu => wrd_fpu_s
			);
		
		e0: datapath
			PORT map(
				clk => clk,
				immed_x2 => immed_x2,
				in_d => in_d,
				ins_dad => ins_dad,
				wrd => wrd,
				op => op,
				addr_a => addr_a,
				addr_b => addr_b,
				addr_d => addr_d,
				immed => immed,
				datard_m => datard_m,
				pc => pc,
				addr_m => addr_m,
				data_wr => data_wr,
				Rb_N => Rb_N,
				aluout => aluout,
				tknbr => tknbr,
				rd_io => rd_io,
				wr_io => wr_io,
				d_sys => d_sys_s,
				a_sys => a_sys_s,
				ei => ei_s,
				di => di_s,
				reti => reti_s,
				boot => boot,
				--intr => intr,
				int_e => int_e_s,
				sys => sys_s,
				wrd_fpu => wrd_fpu_s,
				pc_sys => pc_sys,
				except => except,
				exc_code => exc_code,
				div_zero => div_zero,
				mode => mode_s,
				call => call_s,
				of_en => of_en,
				div_z_fp => div_z_fp,
				of_fp => of_fp
			);
			int_e <= int_e_s;
			mode <= mode_s;
			call <= call_s;
			
END Structure;
