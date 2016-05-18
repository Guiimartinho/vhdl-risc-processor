-- 32-bit incrementer circuit
-- increments an input value by another input value
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity incrementer_32_bit is
	port (
		-- 32-bit inputs
		a_32		:	in		std_logic_vector(31 downto 0);
		b_32		:	in		std_logic_vector(31 downto 0);
		
		-- 32-bit output
		out_32	:	out	std_logic_vector(31 downto 0)
	);
end entity incrementer_32_bit;

architecture incrementer_32_bit_arch of incrementer_32_bit is
	-- unsigned and signed conversions of inputs
	signal a_signed		:	signed(31 downto 0);
	signal b_signed		:	signed(31 downto 0);
	
begin
	increment	: process(a_32, b_32, a_signed, b_signed)
	begin
		-- convert inputs to signed representations
		a_signed <= signed(a_32);
		b_signed <= signed(b_32);
		
		-- add and output as std_logic_vector
		out_32 <= std_logic_vector(a_signed + b_signed);
	end process increment;
end architecture incrementer_32_bit_arch;