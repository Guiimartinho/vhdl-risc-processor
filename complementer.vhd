-- complementer circuit
-- this circuit calculates the two's complement of a given number
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity complementer is
	port (
		-- inputs
		in_32		:	in		std_logic_vector(31 downto 0);
		enable	:	in		std_logic;
		
		-- outputs
		out_32	:	out	std_logic_vector(31 downto 0)
	);
	
end entity complementer;

architecture complementer_arch of complementer is
	-- defining signals
	signal inverted_in	:	unsigned(31 downto 0);
	signal increment		:	unsigned(31 downto 0);
	signal complement		:	unsigned(32 downto 0);
	
begin
	-- design implementation
	process(enable, in_32, inverted_in, increment, complement)
	begin
		if enable = '1' then
			-- invert the input
			inverted_in <= unsigned(not in_32);
		
			-- add 1
			increment <= (0 => '1', others => '0');
			complement <= ('0' & inverted_in) + ('0' & increment);

			-- ignore overflow
			out_32 <= std_logic_vector(complement(31 downto 0));
		elsif enable = '0' then
			inverted_in <= (others => '0');
			increment <= (others => '0');
			complement <= (others => '0');
			
			out_32 <= in_32;
		else
			inverted_in <= (others => '0');
			increment <= (others => '0');
			complement <= (others => '0');
			
			out_32 <= (others => '0');
		end if;
	end process;
	
end architecture complementer_arch;