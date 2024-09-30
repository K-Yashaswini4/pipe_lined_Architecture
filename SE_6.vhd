library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend_6 is
  port(
   inp_6bit : in std_logic_vector(5 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end entity ; 

architecture SE of sign_extend_6 is

begin
	SE:process(inp_6bit)
	begin 
		
			outp_16bit(5 downto 0) <= inp_6bit(5 downto 0);
			outp_16bit(6) <= inp_6bit(5);
			outp_16bit(7) <= inp_6bit(5);
			outp_16bit(8) <= inp_6bit(5);
			outp_16bit(9) <= inp_6bit(5);
			outp_16bit(10) <= inp_6bit(5);
			outp_16bit(11) <= inp_6bit(5);
			outp_16bit(12) <= inp_6bit(5);
			outp_16bit(13) <= inp_6bit(5);
			outp_16bit(14) <= inp_6bit(5);
			outp_16bit(15) <= inp_6bit(5);
	  
	end process;
end SE ;