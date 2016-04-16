-- shifter circuit
-- this circuit performs shifts (both logical and arithmetic) on inputs
-- all code (c) copyright 2016 Jay valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity shifter is
	port (
		-- inputs
		a_32			:	in		std_logic_vector(31 downto 0);
		b_32			:	in		std_logic_vector(31 downto 0);
		opcode		:	in		std_logic_vector(1 downto 0);
		
		-- outputs
		result_32	:	in 	std_logic_vector(31 downto 0)
	);
	
end entity shifter

architecture shifter_arch of shifter is
	-- defining signals
	signal a_numeric			:	unsigned(31 downto 0);
	signal b_numeric			:	unsigned(31 downto 0);
	signal b_integer			:	integer;
	signal result_numeric	:	unsigned(31 downto 0);
	
begin
	-- design implementation
	process(a_32, b_32, opcode, a_numeric, b_numeric, result_numeric)
	begin
		-- converting inputs to unsigned
		a_numeric <= unsigned(a_32);
		b_numeric <= unsigned(b_32);
	
		-- converting b to integer
		b_integer <= to_integer(b_numeric);
	
		-- opcode 00 is shift left logical
		if opcode = "00" then
			result_numeric <= a_numeric sll b_integer;
		-- opcode 01 is shift right logical
		elsif opcode = "01" then
			result_numeric <= a_numeric srl b_integer;
		-- opcode 10 is shift left arithmetic
		-- shift right arithmetic is the same as logical so a fourth state is not needed
		elsif opcode = "10" then
			result_numeric <= a_numeric sla b_integer;
		-- any other opcode gives result 0
		else
			result_numeric <= (others => 0);
		end if;
		
		result_32 <= std_logic_vector(result_numeric);
	end process;
	
end architecture shifter_arch;