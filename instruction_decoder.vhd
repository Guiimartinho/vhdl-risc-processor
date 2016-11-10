-- instruction decoder for VRISC architecture
-- converts 32-bit instruction code into control signals required for specified function
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

-- instructions not given here as there are too many to list concisely
-- instead they can be found in the README in the GitHub repository for this project

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity instruction_decoder is
	port (
		-- 32-bit instruction bus input
		instr				:	in		std_logic_vector(31 downto 0);
		
		-- register address outputs
		reg_addr_a		:	out	std_logic_vector(4 downto 0);
		reg_addr_b		:	out	std_logic_vector(4 downto 0);
		
		-- operand select signals
		op_select_a		:	out	std_logic; -- 0: prev_result, 1: reg_data_a
		op_select_b		: 	out	std_logic; -- 0: reg_data_b, 1: imm_16_bit
		
		-- immediate value from instruction
		imm_16_bit		:	out	std_logic_vector(15 downto 0);
		
		-- external memory opcode
		mem_opcode		:	out	std_logic_vector(2 downto 0);
		
		-- register writeback control signals
		wb_en				:	out	std_logic; -- 0: reg_file will write on next clk, 1: reg_file will not write on next clk
		wb_addr			:	out	std_logic_vector(4 downto 0);
		wb_select		:	out	std_logic; -- 0: select ALU result for wb, 1: select mem_read for wb
		
		-- pc value select signal
		pc_select		:	out 	std_logic; -- 0: reg_data_a, 1: imm_16_bit
		
		-- pc opcode
		pc_opcode		:	out	std_logic_vector(2 downto 0);
		
		-- conditional jump test opcode
		cond_opcode		:	out	std_logic_vector(1 downto 0)
	);
end entity instruction_decoder;
		
		
		