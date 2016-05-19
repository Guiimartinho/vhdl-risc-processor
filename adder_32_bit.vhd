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
		opcode	:	in		std_logic_vector(1 downto 0);
		enable	:	in		std_logic;
		
		-- outputs
		sum_32	:	out	std_logic_vector(31 downto 0);
		carry		:	out	std_logic;
		overflow	:	out	std_logic
	);
	
end entity adder_32_bit;

architecture adder_32_bit_arch of adder_32_bit is
	-- signed values
	signal a_signed		:	signed(31 downto 0);
	signal b_signed		:	signed(31 downto 0);
	signal sum_signed		:	signed(31 downto 0);
	
	-- unsigned values
	signal a_unsigned		:	unsigned(32 downto 0);
	signal b_unsigned		:	unsigned(32 downto 0);
	signal sum_unsigned	:	unsigned(32 downto 0);
	
begin
	-- design implementation
	add	:	process(enable, opcode, a_32, b_32, a_signed, b_signed, sum_signed, a_unsigned, b_unsigned, sum_unsigned)
	begin
		if enable = '1' then
			-- converting inputs to signed vectors
			a_signed <= signed(a_32);
			b_signed <= signed(b_32);
			
			-- converting inputs to unsigned vectors
			a_unsigned <= '0' & unsigned(a_32);
			b_unsigned <= '0' & unsigned(b_32);
		
			-- performing addition/subtraction
			-- opcode 00 is add signed
			if opcode = "00" then
				-- calculating signed sum
				sum_signed <= a_signed + b_signed;
				-- set unsigned sum to 0
				sum_unsigned <= (others => '0');
				
				-- if sign bit of sum is not the same as the sign bits of the two operands, set overflow flag
				if a_signed(31) = '1' and b_signed(31) = '1' and sum_signed(31) = '0' then
					overflow <= '1';
				elsif a_signed(31) = '0' and b_signed(31) = '0' and sum_signed(31) = '1' then
					overflow <= '1';
				else
					overflow <= '0';
				end if;
				-- carry out set to 0
				carry <= '0';
				
			-- opcode 01 is add unsigned
			elsif opcode = "01" then
				-- set signed sum to 0
				sum_signed <= (others => '0');
				-- calculating unsigned sum
				sum_unsigned <= a_unsigned + b_unsigned;
				
				-- msb of sum is carry out
				carry <= sum_unsigned(32);
				-- overflow flag set to 0
				overflow <= '0';
				
			-- opcode 10 is subtract signed
			elsif opcode = "10" then
				-- calculate signed sum
				sum_signed <= a_signed - b_signed;
				-- set unsigned sum to 0
				sum_unsigned <= (others => '0');
				
				-- if sign bit of sum is not the same as the sign bits of the two operands, set overflow flag
				if a_signed(31) = '0' and b_signed(31) = '1' and sum_signed(31) = '1' then
					overflow <= '1';
				elsif a_signed(31) = '1' and b_signed(31) = '0' and sum_signed(31) = '0' then
					overflow <= '1';
				else
					overflow <= '0';
				end if;
				-- carry out set to 0
				carry <= '0';
				
			-- opcode 11 is subtract unsigned
			elsif opcode = "11" then
				-- set signed sum to 0
				sum_signed <= (others => '0');
				-- calculate unsigned sum
				sum_unsigned <= a_unsigned - b_unsigned;
				
				-- if b > a set carry to 1
				if b_unsigned > a_unsigned then
					carry <= '1';
				else
					carry <= '0';
				end if;
				-- overflow set to 0
				overflow <= '0';
				
			-- otherwise error case, output 0
			else
				sum_signed <= (others => '0');
				sum_unsigned <= (others => '0');
				overflow <= '0';
				carry <= '0';
			end if;
			
			if opcode(0) = '0' then
				sum_32 <= std_logic_vector(sum_signed);
			elsif opcode(0) = '1' then
				sum_32 <= std_logic_vector(sum_unsigned(31 downto 0));
			else
				sum_32 <= (others => '0');
			end if;
			
		-- adder disabled, all outputs and signals 0
		else
			-- resetting internal signals
			a_signed <= (others => '0');
			b_signed <= (others => '0');
			sum_signed <= (others => '0');
			
			a_unsigned <= (others => '0');
			b_unsigned <= (others => '0');
			sum_unsigned <= (others => '0');
			
			-- resetting outputs
			carry <= '0';
			overflow <= '0';
			sum_32 <= (others => '0');
		end if;
		
	end process add;
	
end architecture adder_32_bit_arch;