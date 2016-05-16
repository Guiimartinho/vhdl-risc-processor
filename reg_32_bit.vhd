-- 32-bit register, can be used for many purposes
-- has write enable, synchronous clear, asynchronous reset inputs
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reg_32_bit is
	port (
		-- 32-bit input
		in_32		:	in		std_logic_vector(31 downto 0);
		
		-- clock, async reset, sync clear
		clk		:	in		std_logic;
		rst		:	in		std_logic;
		clr		:	in		std_logic;
		
		-- write enable
		wr_en		:	in		std_logic;
		
		-- 32-bit output
		out_32	:	out	std_logic_vector(31 downto 0)
	);
end entity reg_32_bit;

architecture reg_32_bit_arch of reg_32_bit is
	-- this circuit does not require any internal signals
	
begin
	wrt	:	process(rst, clk)
	begin
		-- on async reset high, register contents set to 0
		if rst = '1' then
			out_32 <= (others => '0');
		-- otherwise on rising clock edge and write enable high, transfer input to output
		-- or if clr high, zero output
		else
			if rising_edge(clk) then
				if clr = '1' then
					out_32 <= (others => '0');
				else
					if wr_en = '1' then
						out_32 <= in_32;
					end if;
				end if;
			end if;
		end if;
		
	end process wrt;

end architecture reg_32_bit_arch;