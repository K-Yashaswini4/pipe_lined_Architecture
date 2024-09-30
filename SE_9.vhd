library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend_9 is
  port(
	inp_9bit : in std_logic_vector(8 downto 0);
	outp_16bit : out std_logic_vector(15 downto 0)
  ) ;
end entity ; 

architecture SE of sign_extend_9 is

begin
	SE:process(inp_9bit)
	begin 
		
			outp_16bit(8 downto 0) <= inp_9bit(8 downto 0);
			outp_16bit(9)  <= inp_9bit(8);
			outp_16bit(10) <= inp_9bit(8);
			outp_16bit(11) <= inp_9bit(8);
			outp_16bit(12) <= inp_9bit(8);
			outp_16bit(13) <= inp_9bit(8);
			outp_16bit(14) <= inp_9bit(8);
			outp_16bit(15) <= inp_9bit(8);
		
	end process;
end SE ;