-- 4-input 32-bit multiplexer
-- this circuit takes 4 32-bit inputs and selects one to output based on a 2-bit control signal
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_4_32_bit is
	port (
		-- inputs
		in_32_1			:	in		std_logic_vector(31 downto 0);
		in_32_2			:	in		std_logic_vector(31 downto 0);
		in_32_3			:	in		std_logic_vector(31 downto 0);
		in_32_4			:	in		std_logic_vector(31 downto 0);
		
		-- input select
		input_select	:	in		std_logic_vector(1 downto 0);
		
		-- output
		out_32			:	out	std_logic_vector(31 downto 0)
	);
	
end entity mux_4_32_bit;

architecture mux_4_32_bit_arch of mux_4_32_bit is
	-- this circuit requires no internal signals
	
begin
	-- design implementation
	mux	:	process(input_select, in_32_1, in_32_2, in_32_3, in_32_4)
	begin
		-- select 00 is input 1
		if input_select = "00" then
			out_32 <= in_32_1;
		-- select 01 is input 2
		elsif input_select = "01" then
			out_32 <= in_32_2;
		-- select 10 is input 3
		elsif input_select = "10" then
			out_32 <= in_32_3;
		-- select 11 is input 4
		elsif input_select = "11" then
			out_32 <= in_32_4;
		-- otherwise invalid select signal, output 0
		else
			out_32 <= (others => '0');
		end if;
	end process mux;
	
end architecture mux_4_32_bit_arch;