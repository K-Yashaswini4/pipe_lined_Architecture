library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity datapath is
port(clk: in std_logic;
reset:in std_logic;
PCout: out std_logic_vector(15 downto 0);
R0: out std_logic_vector(15 downto 0);
R1: out std_logic_vector(15 downto 0);
R2: out std_logic_vector(15 downto 0);
R3: out std_logic_vector(15 downto 0);
R4: out std_logic_vector(15 downto 0);
R5: out std_logic_vector(15 downto 0);
R6: out std_logic_vector(15 downto 0);
R7: out std_logic_vector(15 downto 0);
Io: out std_logic_vector(15 downto 0)
);
end entity;

architecture behav of datapath is
constant ADD: std_logic_vector(3 downto 0) := "0001";
	constant ADI: std_logic_vector(3 downto 0) := "0000";
	constant NND: std_logic_vector(3 downto 0) := "0010";
	constant LS7: std_logic_vector(3 downto 0) := "0011";
	constant LW:  std_logic_vector(3 downto 0) := "0100";
	constant SW:  std_logic_vector(3 downto 0) := "0101";
	constant LM:  std_logic_vector(3 downto 0) := "0110";
	constant SM:  std_logic_vector(3 downto 0) := "0111";
	constant BEQ: std_logic_vector(3 downto 0) := "1000";
	constant BLT: std_logic_vector(3 downto 0) := "1001";
	constant BLE: std_logic_vector(3 downto 0) := "1010";
	constant JAL: std_logic_vector(3 downto 0) := "1100";
	constant JLR: std_logic_vector(3 downto 0) := "1101";
	constant JRI: std_logic_vector(3 downto 0) := "1111";
	signal PC,Iout,PC_IF,PC_ID,IR_IF,SE6,SE9,LLIout,s_out,s1_out,SE_ID,SE_RR,D1,D2,coutp,D3,D_MA,R0_v,R1_v,R2_v,R3_v,R4_v,R5_v,R6_v, R7_v,
           PCin,LM0,LM1,LM2,LM3,LM4,LM5,LM6,LM7,R7_MA,R6_MA,R5_MA,R4_MA,R3_MA,R2_MA,
			  R1_MA,R0_MA,R0_t,R1_t,R2_t,R3_t,R4_t,R5_t,R6_t,R7_t,a,b,outA,outB,PC_RR,outp,forwarded_data_2,D,D_EXvar,D_EX
			  ,Addr_Ex,SM0,SM1,SM2,SM3,SM4,SM5,SM6,SM7,RAM_out,PC_MA,PC_Ex,Y: std_logic_vector(15 downto 0);
	signal IF_en,ID_en,rst,valid_IDvar,valid_IF,valid_ID,valid_RR,flush_ID,c1_out,
	flush_RR,SEa_ID,LMen_MA,RR_en,z1_out,Reg_wr_Ex,valid_EX,eq1,eq2,eq3  : std_logic;
	signal opcode,opcode_ID,opcode_RR,opcode_Ex,opcode_MA : std_logic_vector(3 downto 0);
	signal A1_ID,A2_ID,Aw_ID,CZ_ID,Aw,Aw_MA,Aw_RR,CZ_RR,A1_RR,A2_RR: std_logic_vector(2 downto 0);
	
	signal ALUop,ALUop_RR,Aw_EX    : std_logic_vector(2 downto 0);
	signal Cmod_ID,Zmod_ID,PCstore_ID,PCstore_RR,PCcompute_ID,PCcompute_RR,Reg_wr_ID ,LMen_ID,LMen,SMen_ID,load_type_ID,RAM_write,
	Cmod_RR,Zmod_RR,store_type_ID,load_type_RR,SMen_RR,LMen_RR,LM_en,flush_MA,RAM_wr,store_type_RR,carry ,zero,c1_in, 
	c_m,z_var,C_mod_var,Z_mod_var,Reg_wr_Exvar,z_m,Z_LWvar,lw_flag_update,
	valid_EXvar,flush_Ex,LMen_Ex,SMen_Ex,RAM_wr_Ex,load_type_Ex,store_type_Ex,
	SMen_Ex_var,LMen_ex_var,wRAM,valid_MAvar,haz_lw_r0,haz_Ex_r0,
	haz_beq,haz_blt,haz_ble,haz_jal_ex,haz_jri,haz_jlr_ex,haz_lhi_r0,haz_jal_jlr_r0,
	lw_stall,haz_load_dep,lmSm_stall,haz_lw_zero_dep,haz_lmsm1,haz_lmsm2,haz_lmsm3,haz_lli_r0,flush_IF: std_logic;
	
	signal useALUa_ID,useALUb_ID ,useALUa_RR,useALUb_RR,wPC_ID,wPC,Reg_wr,Reg_wr_MA,Reg_wr_RR,valid_MA,valid_RRvar,RAM_wr_ID,RAM_wr_RR,SEa_RR: std_logic;
	signal IMM_ID,en,Imm_MA,Imm_RR,Imm_Ex :std_logic_vector(7 downto 0);  
	signal outA_RR,outB_RR,R0_RR,R1_RR,R2_RR,R3_RR,R4_RR,R5_RR,R6_RR,
	forwarded_data_1,D_MAvar,R7_RR,PC_inc,a1, b1,R0_Ex,R1_Ex,R2_Ex,R3_Ex,R4_Ex,R5_Ex,
	R6_Ex,R7_Ex : std_logic_vector(15 downto 0);
	signal C_main, Z_main:std_logic:='0';
	
	
	
	
	
	
	component I_Memory is 
	port (addr: in std_logic_vector(15 downto 0); 
	
				data_read: out std_logic_vector(15 downto 0)
				);
end component;


component D_Memory is
	port(address, RAM_datain : in  std_logic_vector(15 downto 0);
	     SMEn,LMEn: in  std_logic;
		  en:in  std_logic_vector(7 downto 0);
	     SM_d0,SM_d1,SM_d2,SM_d3, SM_d5,SM_d6,SM_d7,SM_d4 :in  std_logic_vector(15 downto 0);
		  LM_d0,LM_d1,LM_d2,LM_d3, LM_d5,LM_d6,LM_d7,LM_d4 :out  std_logic_vector(15 downto 0);
	     clk,rst,RAM_wr      : in  std_logic;
	     RAM_dataout         : out std_logic_vector(15 downto 0));
end component;


component register_file is
	port(
		-- Master clock
		clk   : in  std_logic;
		rst: in std_logic;
		-- First read
		D1  : out std_logic_vector(15 downto 0);
		A1  : in  std_logic_vector(2 downto 0);
		-- Second read
		D2  : out std_logic_vector(15 downto 0);
		A2  : in  std_logic_vector(2 downto 0);
		-- Write
		D3 : in  std_logic_vector(15 downto 0);
		A3  : in  std_logic_vector(2 downto 0);
		wEN   : in  std_logic;
		-- R0 as PC control i/ps and o/ps
		PCin  : in  std_logic_vector(15 downto 0);
		PCout : out std_logic_vector(15 downto 0);
		wPC   : in  std_logic;

		R0	  : out std_logic_vector(15 downto 0);
		R1	  : out std_logic_vector(15 downto 0);
		R2	  : out std_logic_vector(15 downto 0);
		R3	  : out std_logic_vector(15 downto 0);
		R4	  : out std_logic_vector(15 downto 0);
		R5	  : out std_logic_vector(15 downto 0);
		R6	  : out std_logic_vector(15 downto 0);
		R7	  : out std_logic_vector(15 downto 0);
		LM0,LM1,LM2,LM3,LM4,LM5,LM6,LM7 : in std_logic_vector(15 downto 0);
		LM_en: in  std_logic;
		en : in std_logic_vector(7 downto 0)
	);
end component register_file;



component ALU is
	port (
		a, b        : in std_logic_vector(15 downto 0);
		s          : in std_logic_vector(2 downto 0);
		c           : out std_logic_vector(15 downto 0);
		zero, carry : out std_logic
	);
end component ALU;



component adder is
	port (a, b        : in std_logic_vector(15 downto 0);
		   c_in          : in std_logic;
		   output         : out std_logic_vector(15 downto 0);
		   c_out : out std_logic;
			zero : out std_logic
	);
end component adder;


component sign_extend_9 is
  port(
	inp_9bit : in std_logic_vector(8 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end component ;

component sign_extend_6 is
  port(
   inp_6bit : in std_logic_vector(5 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end component ;

component LLI  is
  port (LS_IN: in std_logic_vector(8 downto 0); LS_OUT: out std_logic_vector(15 downto 0));
end component LLI;

component shift is 
port (SE_in:in std_logic_vector(15 downto 0);shift_out:out std_logic_vector(15 downto 0));
end component shift;

begin
--Instruction Fetch------------------------------------------------------------------------------------------------

ROM: I_Memory port map (PC, Iout);
PCout<= PC;
Io<=Iout;

IF_PP : process(clk, rst, IF_en,Iout) is
	begin
		if rst = '1' then
			PC_IF <= (others => '0');
			IR_IF <= (others => '0');
			valid_IF <= '0';
		elsif (rising_edge(clk) and IF_en='1') then
			PC_IF <= PC;
			IR_IF <= Iout;
			valid_IF<= flush_IF;
		end if;
	end process IF_PP;
	
	
	
--Instruction Decode----------------------------------------------------------------------------------------------	
	
	opcode<= IR_IF(15 downto 12);
	S9: sign_extend_9 port map(IR_IF(8 downto 0),SE9);
	S6: sign_extend_6 port map(IR_IF(5 downto 0),SE6);
	LLI_1: LLI port map(IR_IF(8 downto 0),LLIout);
	
	valid_IDvar <= valid_IF and flush_ID;
	
	SH: shift port map (SE6,s_out);
	SH1: shift port map (SE9,s1_out);
	
	ID_PP : process(clk, rst, ID_en) is
	begin
		if rst = '1' then
			PC_ID     <= (others => '0');
			A1_ID     <= "000";
			A2_ID     <= "000";
			Aw_ID     <= "000";
			SE_ID     <= (others => '0');
			SEa_ID    <= '0';
			CZ_ID     <= "000";
			ALUop     <= "000";
			Cmod_ID   <= '0';
			Zmod_ID   <= '0';
			opcode_ID <= (others => '0');
			PCstore_ID   <= '0';
			PCcompute_ID <= '0';
			valid_ID  <= '0';
			Reg_wr_ID <= '0';
		   load_type_ID<= '0';
			store_type_ID<='0';
			useALUa_ID  <= '0';
			useALUb_ID  <= '0';
			RAM_wr    <='0';
			LMen_ID<='0';
			SMen_ID<='0';
		elsif rising_edge(clk)and ID_en='1'   then
			PC_ID        <= PC_IF;
			A1_ID        <= "000"; --rega
			A2_ID        <= "000";  --regb
			Aw_ID        <= "000"; --regc
			SE_ID        <= (others => '0');
			SEa_ID       <= '0';
			CZ_ID        <= "000";
			ALUop        <= "000";
			Cmod_ID      <= '0';
			Zmod_ID      <= '0';
			opcode_ID    <= opcode;
			PCstore_ID   <= '0';
			PCcompute_ID <= '0';
			valid_ID     <= valid_IDvar;
			Reg_wr_ID    <= '0';
			load_type_ID <= '0';
			store_type_ID<='0';
			useALUa_ID  <= '0';
			useALUb_ID  <= '0';
			RAM_wr    <='0';
			LMen_ID<='0';
			SMen_ID<='0';
			case opcode is
				when ADD =>
					A1_ID     <= IR_IF(11 downto 9);--rega
					A2_ID     <= IR_IF(8 downto 6); --regb
					Aw_ID     <= IR_IF(5 downto 3); --regc
					CZ_ID     <= IR_IF(2 downto 0); 
					Cmod_ID   <= '1';
					Zmod_ID   <= '1';
					Reg_wr_ID <= '1';
					
					if (CZ_ID="000" or CZ_ID="010" or CZ_ID="001") then 
					ALUop<="001";
					end if;
					if (CZ_ID="100" or CZ_ID="110" or CZ_ID="101") then 
					ALUop<="010";
					end if;
					
					useALUa_ID  <= '1';
					useALUb_ID  <= '1';
				when ADI =>
					A1_ID     <= IR_IF(11 downto 9);
					SE_ID     <= SE6;
					SEa_ID    <= '1'; --ALU B control
					Aw_ID     <= IR_IF(8 downto 6);
					Cmod_ID   <= '1';
					Zmod_ID   <= '1';
					Reg_wr_ID <= '1';
					useALUa_ID  <= '1';
					useALUb_ID  <= '1';
				when NND =>
					A1_ID     <= IR_IF(11 downto 9);
					A2_ID     <= IR_IF(8 downto 6);
					Aw_ID     <= IR_IF(5 downto 3);
	
					CZ_ID     <= IR_IF(2 downto 0);
					Zmod_ID   <= '1';
					Reg_wr_ID <= '1';
					
					if (CZ_ID="000" or CZ_ID="010" or CZ_ID="001") then
					ALUop<="011";
					end if;
					if (CZ_ID="100" or CZ_ID="110" or CZ_ID="101") then 
					ALUop<="100";
					end if;
					useALUa_ID  <= '1';
					useALUb_ID  <= '1';
				when LS7 =>
					Aw_ID     <= IR_IF(11 downto 9);
					SE_ID 	  <= LLIout;		
					SEa_ID	  <= '1';
					Reg_wr_ID <= '1';
				when LW =>
					A1_ID     <= IR_IF(8 downto 6);
					Aw_ID     <= IR_IF(11 downto 9);
					SE_ID     <= SE6;
					SEa_ID    <= '1';
					Reg_wr_ID <= '1';
					load_type_ID<= '1';
					useALUb_ID  <= '1';
					Zmod_ID   <= '1';
					ALUop<="001";
				when SW =>
					A1_ID   <= IR_IF(8 downto 6); -- regB
					A2_ID  	<= IR_IF(11 downto 9); -- regA
					SE_ID  	<= SE6;
					SEa_ID 	<= '1';
					RAM_wr_ID    <='1';
					useALUb_ID  <= '1';
					store_type_ID <='1';
					ALUop<="001";
				when LM =>
				   A1_ID  	<= IR_IF(11 downto 9); -- regA
					IMM_ID <=IR_IF(7 downto 0);--imm Lm
				
					LMen_ID<='1';

            when SM =>
				   A1_ID  	<= IR_IF(11 downto 9); -- regA
					IMM_ID <=IR_IF(7 downto 0);--imm Lm
					SMEn_ID<='1';
				when BEQ =>
					A1_ID        <= IR_IF(11 downto 9);
					A2_ID        <= IR_IF(8 downto 6);
					PCcompute_ID <= '1'; -- ALU Ctrl-A
					SE_ID        <= s_out;
					SEa_ID       <= '1';
					ALUop<="001";
				when BLT =>
					A1_ID        <= IR_IF(11 downto 9);
					A2_ID        <= IR_IF(8 downto 6);
					PCcompute_ID <= '1'; -- ALU Ctrl-A
					SE_ID        <= s_out;
					SEa_ID       <= '1';
					ALUop<="001";
				when BLE =>
					A1_ID        <= IR_IF(11 downto 9);
					A2_ID        <= IR_IF(8 downto 6);
					PCcompute_ID <= '1'; -- ALU Ctrl-A
					SE_ID        <= s_out;
					SEa_ID       <= '1';	
					ALUop<="001";
				when JAL =>
					PCcompute_ID <= '1';
					SE_ID        <= s1_out;
					SEa_ID       <= '1';
					wPC_ID          <='1';
					PCstore_ID   <= '1';
					Aw_ID        <= IR_IF(11 downto 9);
					Reg_wr_ID    <= '1';
					ALUop<="001";
				when JLR =>
					PCstore_ID <= '1';
					wPC_ID          <='1';
					Aw_ID      <= IR_IF(11 downto 9);--rega
					A1_ID      <= IR_IF(8 downto 6); --regb
					Reg_wr_ID  <= '1';
					
				when JRI =>
					PCstore_ID <= '1';
					wPC_ID          <='1';
					SE_ID        <= s1_out;
					SEa_ID       <= '1';
					A1_ID      <= IR_IF(11 downto 9);
					ALUop<="001";	
				when others => null;
			end case;
		end if;
	end process ID_PP;
	
	
	
	
	
--Register Read-------------------------------------------------------------------------------------------------------------	




R_F:Register_File port map(clk,rst,D1,A1_ID  ,D2  ,A2_ID  ,D3 ,Aw ,Reg_wr ,
		PCin ,   PC  ,wPC,R0_v	  ,R1_v	  ,R2_v	  ,R3_v	  ,R4_v	  ,R5_v	  ,R6_v	, R7_v  ,LM0,LM1,LM2,LM3,LM4,LM5,LM6,LM7 ,LM_en,en );
		R0<=R0_v;
		R1<=R1_v;
		R2<=R2_v;
		R3<=R3_v;
		R4<=R4_v;
		R5<=R5_v;
		R6<=R6_v;
		R7<=R7_v;
		
		outA <= D_MA when (A1_ID = Aw_MA) and Reg_wr_MA = '1' and valid_MA = '1'
		else D1;
	   outB <= D_MA when (A2_ID = Aw_MA) and Reg_wr_MA = '1' and valid_MA = '1'
		else D2;
	valid_RRvar <= valid_ID and flush_RR;
	
	
	RR_PP : process(clk, rst,RR_en) is
	begin
		if rst = '1' then
			PC_RR 	   <= (others => '0');
			Aw_RR      <= "000";
			SE_RR      <= (others => '0');
			SEa_RR     <= '0';
			opcode_RR  <= (others => '0');
			PCstore_RR <= '0';
			valid_RR   <= '0';
			Reg_wr_RR  <= '0';
			CZ_RR      <= "000";
			ALUop_RR  <= "000";
			Cmod_RR	   <= '0';
			Zmod_RR    <= '0';
			load_type_RR<= '0';
			store_type_RR<='0';
			A1_RR		<= "000";
			A2_RR 		<= "000";
			PCcompute_RR<= '0';
			useALUa_RR <= '0';
			useALUb_RR <= '0';
			RAM_wr_RR<='0';
			LMen_RR<='0';
			SMen_RR<='0';
			Imm_RR<=(others => '0');
			R0_RR <= (others => '0');
		   R1_RR <= (others => '0');
			R2_RR <= (others => '0');
			R3_RR <= (others => '0');
			R4_RR <= (others => '0');
			R5_RR <= (others => '0');
			R6_RR <= (others => '0');
			R7_RR <= (others => '0');
		elsif rising_edge(clk) and RR_en = '1' then
			PC_RR 	   <= PC_ID;
			Aw_RR      <= Aw_ID;
			SE_RR      <= SE_ID;
			SEa_RR     <= SEa_ID;
			opcode_RR  <= opcode_ID;
			PCstore_RR <= PCstore_ID;
			valid_RR   <= valid_RRvar;
			Reg_wr_RR  <= Reg_wr_ID;
			CZ_RR      <= CZ_ID;
			ALUop_RR  <= ALUop;
			Cmod_RR	   <= Cmod_ID;
			Zmod_RR	   <= Zmod_ID;
			Imm_RR      <= Imm_ID;
			load_type_RR<= load_type_ID;
			store_type_RR<=store_type_ID;
			LMen_RR<=LMen_ID;
			SMen_RR<=SMen_ID;
			A1_RR		<= A1_ID;
			A2_RR 	<= A2_ID;
			PCcompute_RR<=PCcompute_ID;
			RAM_wr_RR<=RAM_wr_ID;
		   R0_RR <= R0_v;
		   R1_RR <= R1_v;
			R2_RR <= R2_v;
			R3_RR <= R3_v;
			R4_RR <= R4_v;
			R5_RR <= R5_v;
			R6_RR <= R6_v;
			R7_RR <= R7_v;
			useALUa_RR <= useALUa_ID;
			useALUb_RR <= useALUb_ID;
		end if;
		if (rst='1') then
			outA_RR <= x"0000";
			outB_RR <= x"0000";
		elsif (rising_edge(clk)) then -- we need this so that outA_RR can always read from outA, bcoz in case of load dependency hazard(the inst. in WB stage) we can get a stale value
			outA_RR <= outA;
			outB_RR <= outB;
		end if;
	end process RR_PP;
	
-- Instruction Execute--------------------------------------------------------------------------------------------	

	aluex:ALU port map (a, b ,ALUop_RR ,coutp ,zero, carry );
  addrex:adder port map (a1, b1 ,c1_in ,outp, c1_out,z1_out );

  forwarded_data_1 <= D_MAvar when (A1_RR = Aw_EX) and Reg_wr_Ex = '1' and valid_EX = '1'
	               else D_MA when (A1_RR = Aw_MA) and Reg_wr_MA = '1' and valid_MA = '1'
	        	   else outA_RR;
	forwarded_data_2 <= D_MAvar when (A2_RR = Aw_EX) and Reg_wr_Ex = '1' and valid_EX = '1'
	       		   else D_MA when (A2_RR = Aw_MA) and Reg_wr_MA = '1' and valid_MA = '1'
	      		   else outB_RR;


       D <=    PC_RR when PCstore_RR = '1'
        else forwarded_data_2;
		  
    eq1 <= '1' when forwarded_data_1 = forwarded_data_2 else '0'; -- for BEQ
	 eq2 <= '1' when forwarded_data_1 < forwarded_data_2 else '0'; -- for BLT
	 eq3 <= '1' when ((forwarded_data_1 < forwarded_data_2) or (forwarded_data_1 = forwarded_data_2)) else '0'; -- for BLE
	
	a <= PC_RR when (PCcompute_RR = '1')
	    else forwarded_data_1;
	b <= SE_RR when SEa_RR = '1'
	     else forwarded_data_2 ;
		  
		
   a1<=forwarded_data_1 when(opcode_RR="0001" and (CZ_RR="011" or CZ_RR="111"));
	b1<=forwarded_data_2 when(opcode_RR="0001" and CZ_RR="011") else
       not(forwarded_data_2) when(opcode_RR="0001" and CZ_RR="111");
	c1_in<=C_main;
	
	c_m<= c1_out when (opcode_RR="0001" and (CZ_RR="011" or CZ_RR="111"))
            else carry ;
	
	z_var<= z1_out when (opcode_RR="0001" and (CZ_RR="011" or CZ_RR="111"))
	         else zero;
	
	C_mod_var    <= '0' when ((CZ_RR = "010" or CZ_RR = "110") and C_main = '0') else '1';
	Z_mod_var    <= '0' when ((CZ_RR = "001" or CZ_RR = "101") and Z_main = '0') else '1';
	
	Reg_wr_Exvar <= Reg_wr_RR and C_mod_var and Z_mod_var;
	
	
	Z_LWvar <= '1' when (D_MAvar = "0000000000000000")
		  else '0';
	z_m<= Z_LWvar when lw_flag_update='1'
	  else z_var;
	-----
	valid_EXvar <= valid_RR and flush_Ex;
	   
	
		
		
	D_EXvar      <= D when opcode_RR = SW or PCstore_RR = '1' -- SW or JAL/JLR
	                else SE_RR when opcode_RR = LS7 -- LLI
	                else outp when (opcode_RR="0001" and (CZ_RR="011" or CZ_RR="111")) 
						 else coutp;


EX_PP : process(clk, rst) is
	begin
		if rst = '1' then
			c_main         <= '0';
			z_main         <= '0';
			D_EX      <= (others => '0');
			
			opcode_EX <= (others => '0');
			valid_EX  <= '0';
			Reg_wr_Ex <= '0';
			Aw_Ex	  <= "000";
			LMen_Ex <= '0';
			SMen_Ex <= '0';
			RAM_wr_Ex <= '0'; 
			Imm_Ex<=(others => '0');
			R0_Ex <= (others => '0');
		   R1_Ex <= (others => '0');
			R2_Ex <= (others => '0');
			R3_Ex <= (others => '0');
			R4_Ex <= (others => '0');
			R5_Ex <= (others => '0');
			R6_Ex <= (others => '0');
			R7_Ex <= (others => '0');
			PC_Ex<= (others =>'0');
			load_type_Ex<= '0';
			store_type_Ex<='0';
		elsif rising_edge(clk) then
			if (Cmod_RR = '1' and C_mod_var = '1' and valid_RR='1') then
				c_main <= c_m;
			end if;
			if (Zmod_RR = '1' and Z_mod_var = '1' and valid_RR='1') or lw_flag_update = '1' then
				z_main <= z_m;
			end if;
			
			if (load_type_RR='1' or store_type_RR= '1') then
			Addr_Ex<= coutp ;	
			    elsif (LMen_RR='1' or SMen_RR='1'	) then
			Addr_Ex<= forwarded_data_1;
			end if;
			
			D_EX      <= D_EXvar;
			Aw_EX     <= Aw_RR;
			opcode_EX <= opcode_RR;
			valid_EX  <= valid_EXvar;
			Reg_wr_Ex <= Reg_wr_Exvar;
			load_type_Ex<=load_type_RR;
         store_type_Ex<=store_type_RR;
		   Imm_Ex <=Imm_RR;
			RAM_wr_Ex<=RAM_wr_RR;
			LMen_Ex <= LMen_RR;
			SMen_Ex <= SMen_RR;
			PC_Ex<=PC_RR;
		   R0_Ex <= R0_RR;
		   R1_Ex <= R1_RR;
			R2_Ex <= R2_RR;
			R3_Ex <= R3_RR;
			R4_Ex <= R4_RR;
			R5_Ex <= R5_RR;
			R6_Ex <= R6_RR;
			R7_Ex <= R7_RR;
		
		end if;
	end process EX_PP;

	
	

	----Memory Access----------------------------------------------------------------------------------------------
	
	mem_data: D_Memory 
	port map(Addr_Ex, D_Ex,SMen_Ex_var,LMen_ex_var,Imm_Ex,R0_Ex,R1_Ex,R2_Ex,R3_Ex,R4_Ex,R5_Ex,R6_Ex,R7_Ex,R0_t,R1_t,R2_t,R3_t,R4_t,R5_t,R6_t,R7_t
		 ,clk,rst,wRAM ,
	    RAM_out);
		
	
     
	   wRAM  <= '1' when opcode_EX = SW and valid_EX = '1' -- SW
	   else '0';
      SMen_Ex_var <='1' when opcode_EX = SM and valid_EX = '1' --SM
		 else '0';
		LMen_Ex_var <='1' when opcode_EX = LM and valid_EX = '1' --LM
		 else '0'; 
		 
		 D_MAvar <= RAM_out when load_type_Ex='1' -- LW
	      else D_EX;


	valid_MAvar <= valid_EX and flush_MA;
	MA_PP : process(clk, rst) is
	begin
		if rst = '1' then
			Aw_MA     <= (others => '0');
			D_MA      <= (others => '0');
			valid_MA  <= '0';
			Reg_wr_MA <= '0';
			Imm_MA <=(others => '0');
			 LMen_MA<='0';
			PC_MA <= (others => '0');
			R0_MA <= (others => '0');
			R1_MA <= (others => '0');
			R2_MA <= (others => '0');
			R3_MA <= (others => '0');
			R4_MA <= (others => '0');
			R5_MA <= (others => '0');
			R6_MA <= (others => '0');
			R7_MA <= (others => '0');
			opcode_MA<= (others => '0');
			
		elsif rising_edge(clk) then
			D_MA      <= D_MAvar;
			Aw_MA     <= Aw_EX;
			valid_MA  <= valid_MAvar;
			Reg_wr_MA <= Reg_wr_Ex;
			 Imm_MA <=Imm_Ex;
			 LMen_MA <= LMen_Ex;
			
			 
			opcode_MA<= opcode_EX;
			
			PC_MA <=PC_Ex;
			R0_MA <= R0_t;
			R1_MA <= R1_t;
			R2_MA <= R2_t;
			R3_MA <= R3_t;
			R4_MA <= R4_t;
			R5_MA <= R5_t;
			R6_MA <= R6_t;
			R7_MA <= R7_t;
		end if;
		
	end process MA_PP;
	
	
	---Register Write back----------------------------------------------------------------------------------------
	
	Reg_wr<= Reg_wr_MA and valid_MA;
	
	
	Aw<=Aw_MA;
	en<=Imm_MA;
	D3 <=Y when (opcode_MA = JAL or opcode_MA = JLR)    
	       else D_MA;
	Y<=std_logic_vector(unsigned(PC_MA)+2);		 
	LM0 <= R0_MA;
	LM1 <= R1_MA;
	LM2 <= R2_MA;
	LM3 <= R3_MA;
	LM4 <= R4_MA;
	LM5 <= R5_MA;
	LM6 <= R6_MA;
	LM7 <= R7_MA;
	
	LM_en<=LMen_MA; 
	
		--- PC Write
	PC_inc  <= std_logic_vector(unsigned(PC)+2);
	PCin  <= D_MAvar when haz_lw_r0='1' -- priority given to hazards at farthest stage
		else D_EXvar when haz_Ex_r0='1'
		else coutp   when haz_beq='1' or haz_blt='1' or haz_ble='1' or haz_jal_ex='1'or haz_jri='1' 
		else forwarded_data_1 when haz_jlr_ex='1'
		else LLIout when haz_lhi_r0='1'
		else PC_IF when haz_jal_jlr_r0='1'
		else PC_inc;
		
		
		
		wPC   <= not (lw_stall or haz_load_dep or lmSm_stall);
	----Hazard logic -------------------------------------------------------------------------------------------
	haz_lw_r0     <= '1' when (load_type_Ex='1' and Aw_EX = "000" and valid_EX = '1') else '0'; -- LW R0 detected from MA stage
	haz_beq        <= '1' when (opcode_RR = BEQ   and eq1 = '1' and valid_RR = '1') else '0'; -- BEQ taken;
	haz_blt    <= '1' when   (opcode_RR = BLT   and eq2 = '1' and valid_RR = '1') else '0'; -- BLT taken;
	haz_ble   <= '1' when   (opcode_RR = BLE   and eq3 = '1' and valid_RR = '1') else '0'; -- BLE taken;
	haz_jal_ex      <= '1' when (opcode_RR = JAL and valid_RR = '1') else '0';	-- JAL at Ex stage
	haz_jri<= '1' when (opcode_RR = JRI and valid_RR = '1') else '0';
	haz_Ex_r0      <= '1' when (load_type_RR='0' and valid_RR = '1' and Reg_wr_Exvar = '1' and Aw_RR = R0_v) else '0'; -- EX stage writing to R0
	haz_load_dep    <= '1' when (load_type_Ex='1' and ((A1_RR = Aw_EX and useALUa_RR='1') or (A2_RR = Aw_EX and useALUb_RR='1')) and Reg_wr_Ex = '1' and valid_EX = '1') else '0'; -- LW(at Mem) followed by dependency using ALU(at Ex)
	haz_lw_zero_dep <= '1' when (opcode_RR = LW and  (CZ_ID = "001" or CZ_ID = "101")  and valid_RR = '1') else '0'; -- ADZ/NDZ at RR stage dependent on LW(at Ex stage)
	haz_jlr_ex		<= '1' when (opcode_RR = JLR and valid_RR = '1') else '0'; -- JLR at RR stage, data forwarded to PC
	haz_lhi_r0		<= '1' when (opcode = LS7 and IR_IF(11 downto 9)=R0_v and valid_IF='1') else '0'; -- LHI R0, data transferred to PC at decode stage itself
	haz_jal_jlr_r0  <= '1' when (opcode(3 downto 1) = "100" and IR_IF(11 downto 9) = R0_v and valid_IF='1') else '0'; --- JAL/JLR with destination R0 : infinite loop
	
	haz_lmsm2<='1' when ((opcode_ID=SM or opcode_ID=LM) and valid_ID='1') else '0';
	haz_lmsm3<='1' when ((opcode_RR=SM or opcode_RR=LM) and valid_RR='1') else '0';
	haz_lmsm1<='1' when ((opcode_EX=SM or opcode_EX=LM) and valid_EX='1') else '0';
	----Flushes ------------------------------------------------------------------------------------------------
	flush_IF<= not( haz_jri or haz_jlr_ex or haz_jal_ex or haz_beq or haz_blt or haz_ble or haz_lw_r0);
	flush_ID        <= '0' when haz_Ex_r0 = '1' or haz_beq = '1'  or haz_blt = '1' or haz_ble = '1' or haz_lw_r0 = '1' or haz_jlr_ex = '1' or haz_lli_r0 = '1'
	                   or haz_jal_jlr_r0 = '1'
	                   or haz_jal_ex = '1'or haz_jri='1' or haz_lmsm2='1'
	              else '1';
	flush_RR <= not (haz_lw_r0 or haz_beq or haz_blt or haz_lmsm3 or haz_ble or haz_Ex_r0 or haz_jal_ex or haz_jri or lw_stall or haz_jlr_ex);
	flush_Ex <= not (haz_lw_r0 or haz_Ex_r0 or haz_load_dep or haz_lmsm1);
	flush_MA <= not haz_lw_r0;
	----- Stalls -------------------------------------------------------------------------------------==========
	lw_stall <= haz_lw_zero_dep;
	lmSm_stall<=(  haz_lmsm1 or haz_lmsm2 or haz_lmsm3) ;
	IF_en    <= not (lw_stall or lmsm_stall or haz_load_dep or haz_jal_jlr_r0 or haz_lmsm2 or haz_lmsm1 or haz_lmsm3 );
	ID_en	 <= not (lw_stall or haz_load_dep or haz_lmsm1 or haz_lmsm3);
	RR_en	 <= not (haz_load_dep or haz_lmsm1);
	lw_flag_update <= '1' when (valid_RR = '0' or Zmod_RR = '0') and (opcode_EX = LW and valid_EX = '1') else '0'; --LW flag update when next one doesnt modify flag or is NOP
	

	
	
	

end behav;