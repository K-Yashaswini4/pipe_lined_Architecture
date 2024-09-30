library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity D_Memory is
	port(address, RAM_datain : in  std_logic_vector(15 downto 0);
	     SMEn,LMEn: in  std_logic;
		  en:in  std_logic_vector(7 downto 0);
	     SM_d0,SM_d1,SM_d2,SM_d3, SM_d5,SM_d6,SM_d7,SM_d4 :in  std_logic_vector(15 downto 0);
		  LM_d0,LM_d1,LM_d2,LM_d3, LM_d5,LM_d6,LM_d7,LM_d4 :out  std_logic_vector(15 downto 0);
	     clk,rst,RAM_wr      : in  std_logic;
	     RAM_dataout         : out std_logic_vector(15 downto 0));
end entity;

architecture Form of D_Memory is
	type regarray is array (0 to 50) of std_logic_vector(7 downto 0);
   type smd is array (0 to 15) of std_logic_vector(7 downto 0);	-- defining a new type
	signal Memory : regarray := (0=>"11110000",
	                             1=>"00000000",
										  2=>"00000000",
										  3=>"00001110",
										  4=>"00000001",
										  5=>"00000001",
										  6=>"00000100",
										  7=>"00010000",
										  others=>"00000000");
	signal SM : smd;
	

begin
	--RAM_dataout <= Memory(to_integer(unsigned((address(5 downto 0)))));
	RAM_dataout(7 downto 0) <= Memory(conv_integer(address)+1);
	RAM_dataout(15 downto 8) <= Memory(conv_integer(address));
	
	  
	Mem_write : process(RAM_wr, clk,SMEn,en,LMEn)
	variable p : integer:=0;
	begin
	  if(LMEn='1') then
	   
	  LM_d0(7 downto 0) <= Memory(conv_integer(address)+1);
	  LM_d0(15 downto 8) <= Memory(conv_integer(address));
	   
	  LM_d1(7 downto 0) <= Memory(conv_integer(address)+3);
	  LM_d1(15 downto 8) <= Memory(conv_integer(address)+2);
	   
	  LM_d2(7 downto 0) <= Memory(conv_integer(address)+5);
	  LM_d2(15 downto 8) <= Memory(conv_integer(address)+4);
	  
	   
	  LM_d3(7 downto 0) <= Memory(conv_integer(address)+7);
	  LM_d3(15 downto 8) <= Memory(conv_integer(address)+6);
	  
	   
	  LM_d4(7 downto 0) <= Memory(conv_integer(address)+9);
	  LM_d4(15 downto 8) <= Memory(conv_integer(address)+8);
	  
	  LM_d5(7 downto 0) <= Memory(conv_integer(address)+11);
	  LM_d5(15 downto 8) <= Memory(conv_integer(address)+10);
	  
	  LM_d6(7 downto 0) <= Memory(conv_integer(address)+13);
	  LM_d6(15 downto 8) <= Memory(conv_integer(address)+12);
	  
	  LM_d7(7 downto 0) <= Memory(conv_integer(address)+15);
	  LM_d7(15 downto 8) <= Memory(conv_integer(address)+14);
	  
	end if;
	if (SMEn = '1') then
	SM(0)<=SM_d0(15 downto 8);
	SM(1)<=SM_d0(7 downto 0);
	SM(2)<=SM_d1(15 downto 8);
	SM(3)<=SM_d1(7 downto 0);
	SM(4)<=SM_d2(15 downto 8);
	SM(5)<=SM_d2(7 downto 0);
	SM(6)<=SM_d3(15 downto 8);
	SM(7)<=SM_d3(7 downto 0);
	SM(8)<=SM_d4(15 downto 8);
	SM(9)<=SM_d4(7 downto 0);
	SM(10)<=SM_d5(15 downto 8);
	SM(11)<=SM_d5(7 downto 0);
	SM(12)<=SM_d6(15 downto 8);
	SM(13)<=SM_d6(7 downto 0);
	SM(14)<=SM_d7(15 downto 8);
	SM(15)<=SM_d7(7 downto 0); 
	end if;
	   if (rising_edge(clk)) then
		if (RAM_wr = '1') then
			
				--Memory(to_integer(unsigned((address(5 downto 0))))) <= RAM_datain;
				Memory(conv_integer(address)) <= RAM_datain(15 downto 8);
				Memory(conv_integer(address)+1) <= RAM_datain(7 downto 0);
			end if;
			
			for i in 0 to 7 loop
			if (en(7-i)= '1') then
			  
				Memory(conv_integer(address)+p) <= SM(2*(7-i));
				Memory(conv_integer(address)+(p+1)) <=SM((2*(7-i))+1);
				p:=p+1;
			end if;
			end loop;
			end if;	
		
	end process;
	
	
	
	
	
	
end Form;