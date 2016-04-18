-- 32-bit shifter circuit
-- this circuit performs shifts (both logical and arithmetic) on inputs
-- all code (c) copyright 2016 Jay valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity shifter_32_bit is
	port (
		-- inputs
		a_32			:	in		std_logic_vector(31 downto 0);
		b_32			:	in		std_logic_vector(31 downto 0);
		opcode		:	in		std_logic_vector(1 downto 0);
		
		-- outputs
		result_32	:	out 	std_logic_vector(31 downto 0)
	);
	
end entity shifter_32_bit;

architecture shifter_32_bit_arch of shifter_32_bit is
	-- defining signals
	signal a_unsigned			:	unsigned(31 downto 0);
	signal a_signed			:	signed(31 downto 0);
	signal b_numeric			:	unsigned(31 downto 0);
	signal b_integer			:	integer;
	signal result_unsigned	:	unsigned(31 downto 0);
	signal result_signed		:	signed(31 downto 0);
	
begin
	-- design implementation
	process(a_32, b_32, opcode, a_unsigned, a_signed, b_numeric, b_integer, result_unsigned, result_signed)
	begin
		-- converting second operand to unsigned and then integer
		b_numeric <= unsigned(b_32);
		b_integer <= to_integer(b_numeric);
		
		-- if performing logical shift then a needs to be unsigned
		a_unsigned <= unsigned(a_32);
		-- if performing arithmetic shift then a needs to be signed
		a_signed <= signed(a_32);
	
		-- opcode 00 is shift left logical
		if opcode = "00" then
			result_unsigned <= shift_left(a_unsigned, b_integer);
			result_signed <= (others => '0');
		-- opcode 01 is shift right logical
		elsif opcode = "01" then
			result_unsigned <= shift_right(a_unsigned, b_integer);
			result_signed <= (others => '0');
		-- opcode 10 is shift right arithmetic
		-- shift left arithmetic is the same as logical so a fourth state is not needed
		elsif opcode = "10" then
			result_signed <= shift_right(a_signed, b_integer);
			result_unsigned <= (others => '0');
		-- any other opcode gives result 0
		else
			result_signed <= (others => '0');
			result_unsigned <= (others => '0');
		end if;
		
		if opcode(1) = '0' then
			result_32 <= std_logic_vector(result_unsigned);
		elsif opcode(1) = '1' then
			result_32 <= std_logic_vector(result_signed);
		else
			result_32 <= (others => '0');
		end if;
		
	end process;
	
end architecture shifter_32_bit_arch;