LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.renacuajo_pkg.all;

ENTITY control_l IS
    PORT (ir         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
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
		  d_sys 	 : OUT STD_LOGIC;
		  ei 		 : OUT STD_LOGIC;
		  di		 : OUT STD_LOGIC;
		  reti	 	 : OUT STD_LOGIC;
		  geti		 : OUT STD_LOGIC;
		  inta		 : OUT STD_LOGIC;
		  call       : OUT STD_LOGIC;
		  il_inst	 : OUT STD_LOGIC;
		  mem_op     : OUT STD_LOGIC
		 );
END control_l; 

ARCHITECTURE Structure OF control_l IS
	SIGNAL arit_log: INST;
	SIGNAL cmp: INST;
	SIGNAL mul_div: INST;
	SIGNAL jump: INST;
	SIGNAL move: INST;
	SIGNAL branch: INST;
	SIGNAL IO: INST;
	SIGNAL jump_wd: std_logic;
	SIGNAL special: INST;
	SIGNAL op_s: INST;
BEGIN

	with ir(5 downto 3) select
		arit_log <= AND_I when F_AND, -- AND
					OR_I  WHEN F_OR, -- OR
					XOR_I WHEN F_XOR, -- XOR
					NOT_I WHEN F_NOT, -- NOT
					ADD_I WHEN F_ADD, -- ADD
					SUB_I WHEN F_SUB, -- SUB
					SHA_I WHEN F_SHA, -- SHA
					SHL_I WHEN F_SHL,
					ILLEGAL_I WHEN others;-- SHL
						
	with ir(5 downto 3) select
		cmp <= CMPLT_I when F_CMPLT, -- CMPLT
			   CMPLE_I WHEN F_CMPLE, -- CMPLE
			   CMPEQ_I WHEN F_CMPEQ, -- CMPEQ
			   CMPLTU_I WHEN F_CMPLTU, -- CMPLTU
			   CMPLEU_I WHEN F_CMPLEU,-- CMPLEU
			   ILLEGAL_I WHEN others;

	with ir(5 downto 3) select
		mul_div <= MUL_I when F_MUL, -- MUL
				   MULH_I WHEN F_MULH, -- MULH
				   MULHU_I WHEN F_MULHU, -- MULHU
				   DIV_I WHEN F_DIV, -- DIV
				   DIVU_I WHEN F_DIVU,-- DIVU
				   ILLEGAL_I WHEN others;
				 
	with ir(2 downto 0) select
		jump <= JZ_I when F_JZ, -- JZ
				JNZ_I when F_JNZ, -- JNZ
				JMP_I when F_JMP, -- JMP
				JAL_I when F_JAL,
				CALL_I when F_CALL,
				ILLEGAL_I when others;-- JAL

	with ir(5 downto 0) select 
		special <= EI_I when F_EI,
				   DI_I when F_DI,
				   RETI_I when F_RETI,
				   RDS_I when F_RDS,
				   WRS_I when F_WRS,
				   GETIID_I when F_GETIID,
				   HALT_I when F_HALT,
				   ILLEGAL_I when others;

	with ir(8) select
		move <= MOVI_I when '0', -- MOVI
				MOVHI_I when others; -- MOVHI
	
	with ir(8) select
		branch <= BZ_I when '0', -- BZ
				  BNZ_I when others; -- BNZ
				  
	with ir(8) select
		io <= IN_I when '0', -- BZ
				OUT_I when others; -- BNZ
				  
				  
	with ir(15 DOWNTO 12) select
		op_s <= arit_log when OP_ARIT, --ARIT_LOGIC
			    cmp when OP_CMP, --CMP
			    ADDI_I when OP_ADDI, -- ADDI
			    LD_I when OP_LD, --LD
			    ST_I when OP_ST, -- ST
			    move when OP_MOV, --MOVI i MOVHI
			    branch when OP_BRANCH, -- BZ & BNZ
				io when OP_IO, --IN & OUT
			    mul_div when OP_MULDIV, --MUL & DIV
			    jump when OP_JUMP, --JAL
		        LDB_I when OP_LDB, --LDB
			    STB_I when OP_STB, -- STB
			    special when OP_SPECIAL, -- HALT
			    ILLEGAL_I when others;

	op <= op_s;

	il_inst <= '1' when op_s = ILLEGAL_I else '0';
	call <= '1' when op_s = CALL_I else '0';

	with ir(15 downto 12) select
		Rb_N <= '1' when OP_ADDI, --ADDI
				'1' when OP_LD, --LD	
				'1' when OP_ST, --ST
				'1' when OP_MOV, --MOVI i MOVHI
				'1' when OP_LDB, --LDB
				'1' when OP_STB, --STB
				'0' when others;

	addr_a <= ir(11 downto 9) when ir(15 downto 12) = OP_MOV else
			  "001" when ir(15 downto 12) = OP_SPECIAL and special = RETI_I else --hardcodegem que baixi el registre s1
			  ir(8 downto 6);

	addr_d <= ir(11 downto 9);

	ei <= '1' when ir(15 downto 12) = OP_SPECIAL and special = EI_I else '0';
	di <= '1' when ir(15 downto 12) = OP_SPECIAL and special = DI_I else
		  '1' when ir(15 downto 12) = OP_SPECIAL and special = HALT_I else
	'0';

	reti <= '1' when ir(15 downto 12) = OP_SPECIAL and special = RETI_I else '0';

	with ir(15 downto 12) select
		addr_b <= ir(11 downto 9) when OP_ST,
					 ir(11 downto 9) when OP_STB,
					 ir(11 downto 9) when OP_BRANCH,
					 ir(11 downto 9) when OP_IO,
					 ir(11 downto 9) when OP_JUMP,
					 ir(2 downto 0) when others;

	immed <= ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7) & ir(7 downto 0) when ir(15 downto 12) = OP_MOV else
			ir(5) & ir(5) & ir(5) & ir(5) & ir(5) & ir(5) & ir(5) & ir(5) & ir(5) & ir(5) & ir(5 downto 0);
	
	with ir(2 downto 0) select
		jump_wd <= '1' when F_JAL,
					  '0' when others;
					
	wrd <= '1' when ir(15 downto 12) = OP_ARIT else --op arit
			 '1' when ir(15 downto 12) = OP_CMP else --cmp
			 '1' when ir(15 downto 12) = OP_ADDI else --addi
			 '1' when ir(15 downto 12) = OP_LD else --ld
			 '1' when ir(15 downto 12) = OP_MOV else --movi movhiÃ‚Âº
			 '1' when ir(15 downto 12) = OP_MULDIV else -- mul & div
			 jump_wd when ir(15 downto 12) = OP_JUMP else --jal
			 '1' when ir(15 downto 12) = OP_LDB else --ldb
			 '1' when ir(15 downto 12) = OP_IO and ir(8) = '0' else --in
			 '1' when ir(15 downto 12) = OP_SPECIAL and (special = WRS_I or special = GETIID_I) else --wrs
			 '0';
					
	--with ir(15 downto 12) select
		--wrd <= '1' when "0000", 						--op arit
			--   '1' when "0001", 						--comparacions
			  -- '1' when "0010", 						--addi
			   --'1' when "0011", 						--ld
			  -- '1' when "0101", 						--movi i movhi
				--'1' when "1000",						-- mul & div
			   --jump_wd when "1010", 	--jal
			   --'1' when "1101",			--ldb
			   --'0' when others;

	 with ir(15 downto 12) select
		wr_m <= '1' when OP_ST,
				  '1' when OP_STB,
				  '0' when others;
				  
	with ir(15 downto 12) select
		word_byte <= '1' when OP_LDB,
						 '1' when OP_STB,
						 '0' when others;

	with (ir) select
		ldpc <= '0' when x"FFFF",
				  '1' when others;
				  
	with ir(15 downto 12) select
		immed_x2 <= '1' when OP_LD,
						'1' when OP_ST,
						'1' when OP_BRANCH,
						'0' when others;
		
	in_d <= "01" when ir(15 downto 12) = OP_LD else --ld
			"01" when ir(15 downto 12) = OP_LDB else --ldb
			"10" when ir(15 downto 12) = OP_JUMP else --jal
			"11" when ir(15 downto 12) = OP_IO and ir(8) = '0' else --in
			"11" when ir(15 downto 12) = OP_SPECIAL and special = GETIID_I else --in
			"00";
		
	--with ir(15 downto 12) select -- ara in_d te dos bits
		--in_d <= "01" when "0011",   --st
			--	  "01" when "1101", --stb
				--  "10" when "1010", --jal
				  --"00" when others;
	
	wr_out <= '1' when ir(15 downto 12) = OP_IO and ir(8) = '1'  else --OUT
				 '0';

	rd_in <= '1' when ir(15 downto 12) = OP_IO and ir(8) = '0' else --IN
				'0';
	
	addr_io <= x"00" when ir(15 downto 12) = OP_SPECIAL and special = GETIID_I else ir(7 downto 0);

	inta <= '1' when ir(15 downto 12) = OP_SPECIAL and special = GETIID_I else '0';

	a_sys <= '1' when ir(15 downto 12) = OP_SPECIAL and (special = RDS_I or special = RETI_I) else --en reti activem pq el pc pugui sortir
			 '0';
	
	d_sys <= '1' when ir(15 downto 12) = OP_SPECIAL and special = WRS_I else 
			 '0';
	
	mem_op <= '1' when (ir(15 downto 12) = OP_LD or ir(15 downto 12) = OP_LDB or
				        ir(15 downto 12) = OP_ST or ir(15 downto 12) = OP_STB) else
			  '0';
END Structure;
