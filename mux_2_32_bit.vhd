-- 2-input 32-bit multiplexer
-- this circuit takes 2 32-bit inputs and selects one to output based on a select signal
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_2_32_bit is
	port (
		-- inputs
		in_32_0			:	in		std_logic_vector(31 downto 0);
		in_32_1			:	in		std_logic_vector(31 downto 0);
		
		-- select signal
		input_select	:	in		std_logic;
		
		-- output
		out_32			:	out	std_logic_vector(31 downto 0)
	);
	
end entity mux_2_32_bit;

architecture mux_2_32_bit_arch of mux_2_32_bit is
	-- this circuit requires no internal signals
	
begin
	-- design implementation
	mux	:	process(input_select, in_32_0, in_32_1)
	begin
		-- select 0 is input 0
		if input_select = '0' then
			out_32 <= in_32_0;
		-- select 1 is input 1
		elsif input_select = '1' then
			out_32 <= in_32_1;
		-- otherwise invalid input signal, output 0
		else
			out_32 <= (others => '0');
		end if;
	end process mux;
	
end architecture mux_2_32_bit_arch;
