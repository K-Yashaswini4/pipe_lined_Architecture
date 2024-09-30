library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port (a, b        : in std_logic_vector(15 downto 0);
		   c_in          : in std_logic;
		   output         : out std_logic_vector(15 downto 0);
		   c_out , zero : out std_logic
	);
end adder;

architecture behave of adder is

signal sum,sum1: std_logic_vector(15 downto 0);
signal o: std_logic_vector(15 downto 0):=(others=>'0');
signal c,c1:std_logic;
component SixteenBitAdder is
  port (
    a    : in std_logic_vector (15 downto 0);
    b    : in std_logic_vector (15 downto 0);
    sum  : out std_logic_vector (15 downto 0);
    cout : out std_logic
  );
end component SixteenBitAdder;
  component OneBitAdder is
    port (
      a, b, cin : in std_logic;
      sum, cout : out std_logic
    );
  end component OneBitAdder;
begin
o(0)<=c_in;
add1:SixteenBitAdder port map(a,b,sum,c);
add2:SixteenBitAdder port map(sum,o,sum1,c1);
C_out<=c xor c1;
output<=sum1;
zero<= '1'when sum1="0000000000000000" else '0';
end behave;

