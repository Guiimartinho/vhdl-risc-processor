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

architecture processor_top_level_arch of processor_top_level is
	-- component declarations
	
	-- arithemtic & logic unit
	component alu_32_bit is
		port (
			-- operand inputs
			a_32				:	in		std_logic_vector(31 downto 0);
			b_32				:	in		std_logic_vector(31 downto 0);
			
			-- opcode and enable inputs
			opcode			:	in		std_logic_vector(3 downto 0);
			enable			:	in		std_logic;
			
			-- result output
			result_32		:	out	std_logic_vector(31 downto 0);
			
			-- test and carry outputs
			test_out			:	out	std_logic;
			carry_out		:	out	std_logic;
			overflow_out	:	out	std_logic
		);
	end component;



		
		