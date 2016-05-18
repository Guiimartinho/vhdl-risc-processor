-- 4-input single-bit multiplexer
-- this circuit takes four single-bit inputs and selects one to output based on a select signal
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux_4_single_bit is
	port (
		-- inputs
		in_signal_0			:	in		std_logic;
		in_signal_1			:	in		std_logic;
		in_signal_2			:	in		std_logic;
		in_signal_3			:	in		std_logic;
		
		-- select signal
		input_select		:	in		std_logic_vector(1 downto 0);
		
		-- output
		out_signal			:	out	std_logic
	);
	
end entity mux_4_single_bit;

architecture mux_4_single_bit_arch of mux_4_single_bit is
	-- this circuit requires no internal signals
	
begin
	-- design implementation
	mux	:	process(in_signal_0, in_signal_1, in_signal_2, in_signal_3, input_select)
	begin
		-- select 00 is input 0
		if input_select = "00" then
			out_signal <= in_signal_0;
		-- select 01 is input 1
		elsif input_select = "01" then
			out_signal <= in_signal_1;
		-- select 10 is input 2
		elsif input_select = "10" then
			out_signal <= in_signal_2;
		-- select 11 is input 3
		elsif input_select = "11" then
			out_signal <= in_signal_3;
		-- otherwise invalid select signal, output 0
		else
			out_signal <= '0';
		end if;
	end process mux;

end architecture mux_4_single_bit_arch;