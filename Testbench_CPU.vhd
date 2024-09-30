library ieee;
use ieee.std_logic_1164.all;

entity Testbench_CPU is
end entity Testbench_CPU;


architecture struct of Testbench_CPU is

component datapath is
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
end component;


signal CT,RT :std_logic:='1';


signal PCT,R0T,R1T,R2T,R3T,R4T,R5T,R6T,R7T,IoT: std_logic_vector(15 downto 0):=(others=>'0');


begin
CT<= not CT after 100 ns;
RT<= '0','1' after 10000 ns,'0' after 10300 ns;
dut_instance: datapath port map(CT,RT,PCT,R0T,R1T,R2T,R3T,R4T,R5T,R6T,R7T,IoT);
end struct;