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
		opcode		:	in		std_logic_vector(1 downto 0);
		enable		:	in		std_logic;
		
		-- outputs
		result_32	:	out 	std_logic_vector(31 downto 0);
		carry_out	:	out	std_logic
	);
	
end entity shifter_32_bit;

architecture shifter_32_bit_arch of shifter_32_bit is
	-- defining signals
	signal a_unsigned			:	unsigned(31 downto 0);
	signal a_signed			:	signed(31 downto 0);
	signal result_unsigned	:	unsigned(31 downto 0);
	signal result_signed		:	signed(31 downto 0);
	
begin
	-- design implementation
	shift	:	process(opcode, enable, a_32, a_unsigned, a_signed, result_unsigned, result_signed)
	begin
		-- shifter enabled, perform specified shift function
		if enable = '1' then
			-- if performing logical shift then a needs to be unsigned
			a_unsigned <= unsigned(a_32);
			-- if performing arithmetic shift then a needs to be signed
			a_signed <= signed(a_32);
	
			-- opcode 00 is shift left logical
			if opcode = "00" then
				carry_out <= a_unsigned(31);
				result_unsigned <= shift_left(a_unsigned, 1);
				result_signed <= (others => '0');
			-- opcode 01 is shift right logical
			elsif opcode = "01" then
				carry_out <= a_unsigned(0);
				result_unsigned <= shift_right(a_unsigned, 1);
				result_signed <= (others => '0');
			-- opcode 10 is shift left arithmetic (copy lsb)
			elsif opcode = "10" then
				carry_out <= a_signed(31);
				result_signed <= shift_left(a_signed, 1);
				result_unsigned <= (others => '0');
			-- opcode 11 is shift right arithmetic (copy msb)
			elsif opcode = "11" then
				carry_out <= a_signed(0);
				result_signed <= shift_right(a_signed, 1);
				result_unsigned <= (others => '0');
			-- any other opcode gives result 0
			else
				carry_out <= '0';
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
		-- shifter disabled, all outputs and signals 0
		else
			result_32 <= (others => '0');
			
			a_unsigned <= (others => '0');
			a_signed <= (others => '0');
			
			result_unsigned <= (others => '0');
			result_signed <= (others => '0');
			
			carry_out <= '0';
		end if;
		
	end process shift;
	
end architecture shifter_32_bit_arch;