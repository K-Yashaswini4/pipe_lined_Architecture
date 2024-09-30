library work;
use work.all;
library ieee;
use ieee.std_logic_1164.all;

entity ALU is
	port (
		a, b        : in std_logic_vector(15 downto 0);
		s          : in std_logic_vector(2 downto 0);
		c           : out std_logic_vector(15 downto 0);
		zero, carry : out std_logic
	);
end ALU;


architecture struct of ALU is

	signal cout1,cout2: std_logic:='0';
	signal addition_result, nand_result,  add_comp_result,nand_comp_result, temp ,b_bar: std_logic_vector(15 downto 0):=(others=>'0');

	component SixteenBitAdder is
		port (
			a    : in std_logic_vector (15 downto 0);
			b    : in std_logic_vector (15 downto 0);
			sum  : out std_logic_vector (15 downto 0);
			cout : out std_logic
		);
	end component SixteenBitAdder;
	
 	
	component SixteenBitnand is
		port (
			a, b   : in std_logic_vector(15 downto 0);
			output : out std_logic_vector(15 downto 0)
		);
	end component SixteenBitnand;
	
	
   
--	component MUX16_6x1 is
--		port (
--			a, b,c,d,e,f : in std_logic_vector(15 downto 0);
--			s2,s1,s0   : in std_logic;
--			y    : out std_logic_vector(15 downto 0)
--		);
--	end component MUX16_6x1;

begin
   
	b_bar<=not b;
	op_add : SixteenBitAdder
	port map(
		a    => a,
		b    => b,
		sum  => addition_result,
		cout => cout1
	);

	
		op_add_comp : SixteenBitAdder
	port map(
		a    => a,
		b    => b_bar,
		sum  => add_comp_result,
		cout => cout2
	);

	
	op_nand : SixteenBitnand
	port map(
		-- in
		a => a, b => b,
		-- out
		output => nand_result
	);
	
		op_nand_comp : SixteenBitnand
	port map(
		-- in
		a => a, b => b_bar,
		-- out
		output => nand_comp_result
	);
   
	-- If op = 1, then return nand result, else return addition result
--	selector : MUX16_6x1
--	port map(
--		-- in
--		a => addition_result, b => sub_result, c=>Mul_result, d=>and_result, e=>or_result, f=>imp_result,
--		-- select
--		s2=>s(2),s1 => s(1),s0=>s(0),
--		-- out
--		y => temp
--	);
process(a, b,b_bar, addition_result,add_comp_result,nand_result,nand_comp_result,s)
	begin
		if (s = "001") then
			temp <= addition_result;
			carry<=cout1;
		elsif (s = "011") then
			temp <= nand_result;
		elsif (s = "010") then
			temp <= add_comp_result;
			carry<=cout2;
		elsif (s = "100") then
			temp <= nand_comp_result;
		end if;
	end process;
	-- zero is 1 iff all bits of the c are 0
	zero <= not(
		temp(0) or temp(1) or temp(2) or temp(3) or
		temp(4) or temp(5) or temp(6) or temp(7) or
		temp(8) or temp(9) or temp(10) or temp(11) or
		temp(12) or temp(13) or temp(14) or temp(15)
		);

	c <= temp;
   
end architecture;
