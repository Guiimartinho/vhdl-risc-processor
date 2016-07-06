-- register file circuit
-- contains 31 32-bit general-purpose registers, plus 1 register that is always hardcoded to 0
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity register_file is
	port (
		-- read addresses
		a_addr		:	in		std_logic_vector(4 downto 0);
		b_addr		:	in		std_logic_vector(4 downto 0);
		
		-- read data
		a_data		:	out	std_logic_vector(31 downto 0);
		b_data		:	out	std_logic_vector(31 downto 0);
		
		-- write address, enable, clock and data
		wr_addr		:	in		std_logic_vector(4 downto 0);
		wr_data		:	in		std_logic_vector(31 downto 0);
		wr_enable	:	in		std_logic;
		wr_clk		:	in		std_logic;
		
		-- async reset and sync clear
		rst			:	in		std_logic;
		clr			:	in		std_logic
	);
end entity register_file;
