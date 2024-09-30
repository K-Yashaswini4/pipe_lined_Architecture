library ieee;
use ieee.std_logic_1164.all;

entity shift is 
port (SE_in:in std_logic_vector(15 downto 0);shift_out:out std_logic_vector(15 downto 0));
end entity shift;

architecture Struct of shift is
begin
l1:for i in 1 to 15 generate
 shift_out(0)<='0';
 shift_out(i) <= SE_in(i-1);
 end generate;
 
 end Struct;