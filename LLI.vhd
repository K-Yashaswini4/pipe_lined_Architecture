library ieee;
use ieee.std_logic_1164.all;


entity LLI  is
  port (LS_IN: in std_logic_vector(8 downto 0); LS_OUT: out std_logic_vector(15 downto 0));
end entity LLI;

architecture bhv of LLI is
begin
  LS_OUT(15 downto 0) <= "0000000" & LS_IN(8 downto 0);
end architecture;