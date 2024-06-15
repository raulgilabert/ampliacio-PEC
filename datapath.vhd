LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;


ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
          op        : IN INST;
          wrd      : IN  STD_LOGIC;
          vwrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		  Rb_N     : IN  STD_LOGIC;
		  d_sys	   : IN  STD_LOGIC;					
	      a_sys	   : IN  STD_LOGIC;
		  ei 	   : IN  STD_LOGIC;
		  di 	   : IN  STD_LOGIC;
		  reti	   : IN  STD_LOGIC;
		  rd_io	   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);	
		  boot	   : IN  STD_LOGIC;
		  except   : IN  std_logic;
		  exc_code : IN  std_logic_vector(3 downto 0);
		  va_old_vd	   : IN  STD_LOGIC;
		  vec_produce_sca : IN  STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  aluout   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  tknbr    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  wr_io    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  --intr		: IN STD_LOGIC;
		  int_e		: OUT STD_LOGIC;
		  sys		: IN STD_LOGIC;
		  pc_sys : OUT STD_LOGIC_VECTOR(15 downto 0);
		  div_zero : OUT std_logic
		  );
END datapath;


ARCHITECTURE Structure OF datapath IS

	COMPONENT regfile IS
   PORT (
		clk    	: IN  STD_LOGIC;
        wrd    	: IN  STD_LOGIC;
        d      	: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        addr_a 	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
	    addr_b 	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		addr_d 	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		d_sys	: IN  STD_LOGIC;					--WrD del banc de sistema
		a_sys	: IN  STD_LOGIC; 					-- Seleccina el mux
		ei 		: IN  STD_LOGIC;
		di		: IN  STD_LOGIC;
		reti	: IN  STD_LOGIC;
		boot	: IN  STD_LOGIC;
		sys		: IN  STD_LOGIC;
		PCret		: IN  STD_LOGIC_VECTOR(15 downto 0);
		a      	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		b		: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		int_e	: OUT STD_LOGIC; 					-- interrupt enable
		PCsys	: OUT STD_LOGIC_VECTOR(15 downto 0);
		addr_m	: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		except	: IN  STD_LOGIC;
		exc_code: IN  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT alu IS
		 PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : IN INST;
				 w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 z  : OUT STD_LOGIC;
				 div_zero : OUT std_logic
				 );
	END COMPONENT;

	COMPONENT vregfile IS
		PORT (
			clk 	: IN  std_logic;
			wrd		: IN  std_logic;
			d 		: IN  std_logic_vector(127 downto 0);
			addr_a  : IN  std_logic_vector(2 downto 0);
			addr_b  : IN  std_logic_vector(2 downto 0);
			addr_d  : IN  std_logic_vector(2 downto 0);
			a 		: OUT std_logic_vector(127 downto 0);
			b 		: OUT std_logic_vector(127 downto 0);
			old_d	: OUT  std_logic_vector(127 downto 0)
		);
	END COMPONENT;

	COMPONENT valu IS
		PORT (
			x_vec	: IN  STD_LOGIC_VECTOR(127 downto 0);
			x_sca	: IN  STD_LOGIC_VECTOR(15 downto 0);
			y		: IN  STD_LOGIC_VECTOR(127 downto 0);
			immed	: IN  STD_LOGIC_VECTOR(2 downto 0);
			op		: IN  INST;
			w_vec	: OUT STD_LOGIC_VECTOR(127 downto 0);
			w_sca	: OUT STD_LOGIC_VECTOR(15 downto 0);
			div_zero: OUT std_logic
		);
	END COMPONENT;
			
	SIGNAL ra: std_logic_vector(15 downto 0);	
	SIGNAL rb: std_logic_vector(15 downto 0);	
	--SIGNAL rd: std_logic_vector(15 downto 0);
	SIGNAL d: std_logic_vector(15 downto 0);
	SIGNAL rd_alu: std_logic_vector(15 downto 0);
	SIGNAL rd_alu_sca: std_logic_vector(15 downto 0);
	SIGNAL rd_alu_vec: std_logic_vector(15 downto 0);
	--SIGNAL rd_mem: std_logic_vector(15 downto 0);
	SIGNAL immed_out: std_logic_vector(15 downto 0);
	SIGNAL rb_out: std_logic_vector(15 downto 0);
	SIGNAL z: std_logic;
	SIGNAL new_pc: std_logic_vector(15 downto 0);
	SIGNAL addr_m_s: std_logic_vector(15 downto 0);
	SIGNAL vd: std_logic_vector(127 downto 0);
	SIGNAL va_s: std_logic_vector(127 downto 0);
	SIGNAL va: std_logic_vector(127 downto 0);
	SIGNAL vb: std_logic_vector(127 downto 0);
	SIGNAL old_vd: std_logic_vector(127 downto 0);
	SIGNAL div_zero_sca: std_logic;
	SIGNAL div_zero_vec: std_logic;
BEGIN

	reg0: regfile
		PORT map(
			clk => clk,
			wrd => wrd,
			d => d,
			addr_a => addr_a,
			addr_b => addr_b,
			addr_d => addr_d,
			a => ra,
			b => rb,
			d_sys => d_sys,
			a_sys => a_sys,
			ei => ei,
			di => di,
			reti => reti,
			boot => boot,
			--intr => intr,
			int_e => int_e,
			sys => sys,
			PCret => pc,
			PCsys => pc_sys,
			addr_m => addr_m_s,
			except => except,
			exc_code => exc_code
		);

	vreg0 : vregfile
		PORT map(
			clk => clk,
			wrd => vwrd,
			d => vd,
			addr_a => addr_a,
			addr_b => addr_b,
			addr_d => addr_d,
			a => va_s,
			b => vb,
			old_d => old_vd
		);
		
	alu0: alu
		PORT map(
			x => ra,
			y => rb_out,
			op => op,
			w => rd_alu_sca,
			z => z,
			div_zero => div_zero_sca
		);
	
	va <= va_s when va_old_vd = '0' else old_vd;

	valu0: valu
		PORT map(
			x_vec => va,
			x_sca => ra,
			y => vb,
			immed => rb_out(2 downto 0),
			op => op,
			w_vec => vd,
			w_sca => rd_alu_vec,
			div_zero => div_zero_vec
		);

	rd_alu <= rd_alu_sca when vec_produce_sca = '0' else rd_alu_vec;

	div_zero <= div_zero_sca when wrd = '1' else div_zero_vec when vwrd = '1' else '0';
	
	new_pc <= std_logic_vector(unsigned(pc) + 2);
		
	with in_d select
		d <= rd_alu when "00",
			  new_pc when "10",
			  rd_io	when "11",
			  datard_m  when others;
				
	with ins_dad select
		addr_m_s <= pc when '0',
					 rd_alu when others;
					 
	with immed_x2 select
		immed_out <= immed when '0',
						 immed(14 downto 0) & '0' when others;
	
	data_wr <= rb;

	with Rb_N select
		rb_out <= rb when '0',
				  immed_out when others; 

	aluout <= rd_alu;
	
	tknbr(1) <= z when op = BZ_I or op = JZ_I else
				not z when op = BNZ_I or op = JNZ_I else
				'1' when op = JMP_I or op = JAL_I else
				'0';

	tknbr(0) <= '1' when (op = BZ_I or op = BNZ_I) else '0';
	
	wr_io <= rb;
	addr_m <= addr_m_s;
	
END Structure;