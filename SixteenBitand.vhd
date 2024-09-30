library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity SixteenBitnand is
	port (a, b   : in std_logic_vector(15 downto 0);
		  output : out std_logic_vector(15 downto 0);
		  zero: out std_logic);
end entity;

architecture arch of SixteenBitnand is

signal temp: std_logic_vector(15 downto 0):=(others=>'0');
begin

	nand_loop : for i in 0 to 15 generate
		temp(i) <= not(a(i) and b(i));
	end generate nand_loop;
	
	   output<=temp;
		
		zero <= not(
		temp(0) or temp(1) or temp(2) or temp(3) or
		temp(4) or temp(5) or temp(6) or temp(7) or
		temp(8) or temp(9) or temp(10) or temp(11) or
		temp(12) or temp(13) or temp(14) or temp(15)
		);

end architecture;
