-- 32-bit testing circuit
-- this circuit performs comparisons between one or two operands (greater than, less than, equal, zero)
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tester_32_bit is
	port (
		-- inputs
		a_32			:	in		std_logic_vector(31 downto 0);
		b_32			:	in		std_logic_vector(31 downto 0);
		opcode		:	in		std_logic_vector(1 downto 0);
		enable		:	in		std_logic;
		
		-- outputs
		result		:	out	std_logic
	);
	
end entity tester_32_bit;

architecture tester_32_bit_arch of tester_32_bit is
	-- defining internal signals
	signal a_numeric	:	signed(31 downto 0);
	signal b_numeric	:	signed(31 downto 0);
	
begin
	test	:	process(enable, opcode, a_32, b_32, a_numeric, b_numeric)
	begin
		-- if test block has been enabled
		if enable = '1' then
			-- converting std_logic inputs to signed binary values for comparison
			a_numeric <= signed(a_32);
			b_numeric <= signed(b_32);
			
			-- opcode 00 is a=0
			if opcode = "00" then
				if a_numeric = 0 then
					result <= '1';
				else
					result <= '0';
				end if;
			-- opcode 01 is a<b
			elsif opcode = "01" then
				if a_numeric < b_numeric then
					result <= '1';
				else
					result <= '0';
				end if;
			-- opcode 10 is a>b
			elsif opcode = "10" then
				if a_numeric > b_numeric then
					result <= '1';
				else
					result <= '0';
				end if;
			-- opcode 11 is a=b
			elsif opcode = "11" then
				if a_numeric = b_numeric then
					result <= '1';
				else
					result <= '0';
				end if;
			end if;
		-- otherwise test block disabled, all outputs 0
		else
			a_numeric <= (others => '0');
			b_numeric <= (others => '0');
			result <= '0';
		end if;
	end process test;

end architecture tester_32_bit_arch;
			