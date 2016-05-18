-- 32-bit stack with a max depth of 8
-- allows for push and pop operations
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity stack_32_bit is
	port (
		-- top of stack input
		stack_top_write	:	in		std_logic_vector(31 downto 0);
		
		-- push enable, clock and reset
		push					:	in		std_logic;
		clk					:	in		std_logic;
		rst					:	in		std_logic;
		
		-- top of stack output
		stack_top_read		:	out	std_logic_vector(31 downto 0)
	);
end entity stack_32_bit;

architecture stack_32_bit_arch of stack_32_bit is
	-- 8 stack registers
	signal top 			:	std_logic_vector(31 downto 0);
	signal next_0		:	std_logic_vector(31 downto 0);
	signal next_1		:	std_logic_vector(31 downto 0);
	signal next_2		:	std_logic_vector(31 downto 0);
	signal next_3		:	std_logic_vector(31 downto 0);
	signal next_4		:	std_logic_vector(31 downto 0);
	signal next_5		:	std_logic_vector(31 downto 0);
	signal next_6		:	std_logic_vector(31 downto 0);
	
begin
	-- stack process
	stack		:	process(rst, clk)
	begin
		-- on async reset high, set all stack registers to 0
		if rst = '1' then
			stack_top_read <= (others => '0');
			top <= (others => '0');
			next_0 <= (others => '0');
			next_1 <= (others => '0');
			next_2 <= (others => '0');
			next_3 <= (others => '0');
			next_4 <= (others => '0');
			next_5 <= (others => '0');
			next_6 <= (others => '0');
		else
			if rising_edge(clk) then
				if push = '1' then
					-- copying registers down
					next_6 <= next_5;
					next_5 <= next_4;
					next_4 <= next_3;
					next_3 <= next_2;
					next_2 <= next_1;
					next_1 <= next_0;
					next_0 <= top;
					
					-- pushing new value to stack top
					top <= stack_top_write;
					
					
				else
					-- copying next_0 to stack top
					top <= next_0;
					
					-- copying registers up
					next_0 <= next_1;
					next_1 <= next_2;
					next_2 <= next_3;
					next_3 <= next_4;
					next_4 <= next_5;
					next_5 <= next_6;
					
					-- clearing next_6
					next_6 <= (others => '0');
					
					stack_top_read <= top;
				end if;
			end if;
		end if;
	end process stack;

end architecture stack_32_bit_arch;