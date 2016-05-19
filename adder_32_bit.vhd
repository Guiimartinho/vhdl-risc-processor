-- 32-bit adder circuit
-- this circuit adds two 32-bit unsigned numbers together, and supports previous-carry addition and subtraction
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
		opcode	:	in		std_logic_vector(1 downto 0);
		enable	:	in		std_logic;
		sign		:	in		std_logic;
		
		-- outputs
		sum_32	:	out	std_logic_vector(31 downto 0);
		c_out		:	out	std_logic
	);
	
end entity adder_32_bit;

architecture adder_32_bit_arch of adder_32_bit is
	-- defining signals
	signal a_numeric		:	unsigned(32 downto 0);
	signal b_numeric		:	unsigned(32 downto 0);
	signal c_numeric		:	unsigned(32 downto 0);
	signal tmp_sum			:	unsigned(32 downto 0);
	
begin
	-- design implementation
	add	:	process(enable, opcode, a_32, b_32, c_in, a_numeric, b_numeric, c_numeric, tmp_sum)
	begin
		if enable = '1' then
			-- converting inputs to unsigned vectors
			a_numeric <= '0' & unsigned(a_32);
			b_numeric <= '0' & unsigned(b_32);
			
			-- converting previous carry so that it can be added to a and b
			c_numeric <= (0 => c_in, others => '0');
		
			-- performing addition/subtraction
			-- opcode 00 is add without carry
			if opcode = "00" then
				tmp_sum <= a_numeric + b_numeric;
			-- opcode 01 is add with carry
			elsif opcode = "01" then
				tmp_sum <= a_numeric + b_numeric + c_numeric;
			-- opcode 10 is subtract without borrow
			elsif opcode = "10" then
				tmp_sum <= a_numeric - b_numeric;
			-- opcode 11 is subtract with borrow
			elsif opcode = "11" then
				tmp_sum <= a_numeric - b_numeric - c_numeric;
			-- otherwise error case, output 0
			else
				tmp_sum <= (others => '0');
			end if;
			
			-- overflow bit is msb of tmp_sum
			c_out <= tmp_sum(32);
			-- sum is the other 32 bits
			sum_32 <= std_logic_vector(tmp_sum(31 downto 0));
		-- adder disabled, all outputs and signals 0
		else
			-- resetting internal signals
			a_numeric <= (others => '0');
			b_numeric <= (others => '0');
			c_numeric <= (others => '0');
			tmp_sum <= (others => '0');
			
			-- resetting outputs
			c_out <= '0';
			sum_32 <= (others => '0');
		end if;
	end process add;
	
end architecture adder_32_bit_arch;