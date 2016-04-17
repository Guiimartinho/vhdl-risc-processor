-- 32-bit adder circuit
-- this circuit adds two 32-bit numbers together, and supports previous-carry addition
-- all code (c) 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity adder_32_bit is
	port (
		-- inputs
		a_32		:	in		std_logic_vector(31 downto 0);
		b_32		:	in		std_logic_vector(31 downto 0);
		c_in		:	in		std_logic;
		add		:	in		std_logic;
		
		-- outputs
		sum_32	:	out	std_logic_vector(31 downto 0);
		c_out		:	out	std_logic
	);
	
end entity adder_32_bit;

architecture adder_32_bit_arch of adder_32_bit is
	-- defining signals
	signal a_numeric		:	unsigned(31 downto 0);
	signal b_numeric		:	unsigned(31 downto 0);
	signal c_in_padded	:	std_logic_vector(31 downto 0);
	signal c_in_numeric	:	unsigned(31 downto 0);
	signal tmp_sum			:	unsigned(32 downto 0);
	
begin
	-- design implementation
	process(a_32, b_32, c_in, add, c_in_padded, a_numeric, b_numeric, c_in_numeric, tmp_sum)
	begin
		-- converting inputs to unsigned vectors
		a_numeric <= unsigned(a_32);
		b_numeric <= unsigned(b_32);
		
		-- converting previous carry so that it can be added to a and b
		c_in_padded <= (others => '0');
		c_in_padded(0) <= c_in;
		c_in_numeric <= unsigned(c_in_padded);
	
		-- temporary sum value
		if add = '1' then
			-- if adding then add carry-in to sum
			tmp_sum <= ('0' & a_numeric) + ('0' & b_numeric) + ('0' & c_in_numeric);
		elsif add = '0' then
			-- else if subtracting then subtract carry-in from sum
			tmp_sum <= ('0' & a_numeric) + ('0' & b_numeric) - ('0' & c_in_numeric);
		else
			-- else error, output is 0
			tmp_sum <= (others => '0');
		end if;
		
		-- overflow bit is msb of tmp_sum
		c_out <= tmp_sum(32);
		-- sum is the other 32 bits
		sum_32 <= std_logic_vector(tmp_sum(31 downto 0));
	end process;
	
end architecture adder_32_bit_arch;