-- processor top level circuit
-- packages all components together
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- declaring array for i/o port
package io_port_type is
	type io_port is array(15 downto 0) of std_logic_vector(7 downto 0);
end package io_port_type;

use work.io_port_type.all;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity processor_top_level is
	port (
		-- clk input
		clk			:	in		std_logic;
		
		-- instruction address and data
		instr_addr	:	out	std_logic_vector(31 downto 0);
		instr_data	:	in		std_logic_vector(31 downto 0);
		
		-- data mem address, data, clk
		mem_addr		:	out	std_logic_vector(31 downto 0);
		mem_data		:	inout	std_logic_vector(7 downto 0);
		mem_clk		:	out	std_logic;
		
		-- I/O
		io_data		:	inout	io_port
	);
end entity processor_top_level;


		
		