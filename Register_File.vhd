
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
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
end register_file;

architecture behav of register_file is
	type registerArray is array (0 to 7) of std_logic_vector(15 downto 0);
	type lmd is array (0 to 7) of std_logic_vector(15 downto 0);
	signal registers : registerArray:= (0=>"0000000000000000",
	                             1=>"0000000000000100",
										  2=>"0000000000000100",
										  3=>"0000000000001000",
										  4=>"0000000000010000",
										  5=>"0000000000010001",
										  6=>"0000000000000010",
										  7=>"0001000000000000");
	signal LM : lmd;
begin
	-- Read
	D1  <= registers(to_integer(unsigned(A1)));
	D2  <= registers(to_integer(unsigned(A2)));
	PCout <= registers(0);
	R0	<= registers(0);
	R1	<= registers(1);
	R2	<= registers(2);
	R3	<= registers(3);
	R4	<= registers(4);
	R5	<= registers(5);
	R6	<= registers(6);
	R7	<= registers(7);
	LM(0)<=LM0;
	LM(1)<=LM1;
	LM(2)<=LM2;
	LM(3)<=LM3;
	LM(4)<=LM4;
	LM(5)<=LM5;
	LM(6)<=LM6;
	LM(7)<=LM7;
	regs : process(LM_en,clk,en,wEN,wPC) is
	variable p : integer:=0;
	

	begin
		
		
		if (rising_edge(clk)) then
			
			-- If its not the case, then write to both separately
			if wEN = '1'  then
				
					registers(to_integer(unsigned(A3))) <= D3;

				end if;
				if wPC = '1' then
					registers(0) <= PCin;
				end if;
				if (LM_en='1') then
   for i in 0 to 7 loop 
	if (en(7-i)='1') then
	registers(7-i)<= LM(p);
	p:=p+1;
	end if;
	end loop;
	end if;
	end if;		
		
	end process;
	
	
	
end behav;
