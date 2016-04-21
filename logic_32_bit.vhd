-- 32-bit logical operation circuit
-- this circuit performs various different logical operations on one or two operands
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity logic_32_bit is
	port (
		-- inputs
		a_32			:	in		std_logic_vector(31 downto 0);
		b_32			:	in		std_logic_vector(31 downto 0);
		opcode		:	in		std_logic_vector(1 downto 0);
		enable		:	in		std_logic;
		
		--outputs
		result_32	:	out	std_logic_vector(31 downto 0)
	);
	
end entity logic_32_bit;

architecture logic_32_bit_arch of logic_32_bit is
	-- this circuit doesn't require any internal signals
	
begin
	logic	:	process(enable, opcode, a_32, b_32)
	begin
		-- if logic block has been enabled
		if enable = '1' then
			-- opcode 00 is logical OR
			if opcode = "00" then
				result_32 <= a_32 or b_32;
			-- opcode 01 is logical AND
			elsif opcode = "01" then
				result_32 <= a_32 and b_32;
			-- opcode 10 is logical XOR
			elsif opcode = "10" then
				result_32 <= a_32 xor b_32;
			-- opcode 11 is logical NOT of A (B is ignored)
			elsif opcode = "11" then
				result_32 <= not a_32;
			-- otherwise invalid opcode, output is 0
			else
				result_32 <= (others => '0');
			end if;
		-- otherwise logic block disabled, output is 0
		else
			result_32 <= (others => '0');
		end if;
	end process logic;

end architecture logic_32_bit_arch;
				