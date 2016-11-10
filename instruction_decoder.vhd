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
		
		-- offset value for program counter
		offset			:	out	std_logic_vector(25 downto 0);
		
		-- external memory opcode
		mem_opcode		:	out	std_logic_vector(2 downto 0);
		
		-- ALU control signals
		alu_en			:	out	std_logic;
		alu_opcode		:	out	std_logic_vector(3 downto 0);
		
		-- register writeback control signals
		wb_en				:	out	std_logic; -- 0: reg_file will write on next clk, 1: reg_file will not write on next clk
		wb_addr			:	out	std_logic_vector(4 downto 0);
		wb_select		:	out	std_logic; -- 0: select ALU result for wb, 1: select mem_read for wb
		
		-- pc value select signal
		pc_select		:	out 	std_logic_vector(1 downto 0); -- 00: reg_data_a, 01: imm_16_bit, 11: offset
		
		-- pc opcode
		pc_opcode		:	out	std_logic_vector(2 downto 0);
		
		-- conditional jump test opcode
		cond_opcode		:	out	std_logic_vector(1 downto 0)
	);
end entity instruction_decoder;

architecture instruction_decoder_arch of instruction_decoder is
	-- internal signal declarations
	
	-- register address stack signals
	-- this is a stack of depth 2 which stores the register addresses of operand a
	-- if the bottom value of this stack is the current reg_addr_a, then prev_result needs to be selected
	-- and not reg_data_a as this will be the wrong value (reg[a] will soon change on writeback)
	signal reg_stack_top		:		std_logic_vector(4 downto 0);
	signal reg_stack_bottom	:		std_logic_vector(4 downto 0);
	
begin
	-- design implementation
	-- process to define decoding of instruction
	decode	:	process(clk)
	begin
		-- decode on rising edge of clk
		if rising_edge(clk) then
			-- first check bottom of stack
			-- if current reg_addr_a value is equal to reg_stack_bottom
			-- op_select_a <= 0 because previous result must be used (current value of reg[a] is out of date)
			if reg_addr_a = reg_stack_bottom then
				op_select_a <= '0';
			else
				op_select_a <= '1';
			end if;
			
			-- update register addresses from instr
			reg_addr_a <= instr(20 downto 16);
			reg_addr_b <= instr(15 downto 11);
			
			-- update immediate value
			imm_16_bit <= instr(15 downto 0);
			
			-- update offset value
			offset <= instr(25 downto 0);
			
			-- update wr_addr value
			wr_addr <= instr(25 downto 21);
			
			-- *** INCOMPLETE DEFINITION ***
			-- add definitions for outputs based on opcode
			-- after opcodes have been defined
			
			-- case statement for assigning values to outputs
			-- based on opcode
			case instr(31 downto 26) is
				-- 0x00 NO OPERATION
				-- ALU addition with no wb
				when "000000" =>
					op_select_b <= '0';
					
					alu_en <= '0';
					alu_opcode <= "0000";
					
					mem_opcode <= "000";
					
					wb_en <= '0';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x01 ADD REGISTER SIGNED
				when "000001" =>
					op_select_b <= '0';
					
					alu_en <= '1';
					alu_opcode <= "0000";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x02 ADD IMMEDIATE SIGNED
				when "000010" =>
					op_select_b <= '1';
					
					alu_en <= '1';
					alu_opcode <= "0000";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x03 ADD REGISTER UNSIGNED
				when "000011" =>
					op_select_b <= '0';
					
					alu_en <= '1';
					alu_opcode <= "0001";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x04 ADD IMMEDIATE UNSIGNED
				when "000100" =>
					op_select_b <= '1';
					
					alu_en <= '1';
					alu_opcode <= "0001";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x05 SUB REGISTER SIGNED
				when "000101" =>
					op_select_b <= '0';
					
					alu_en <= '1';
					alu_opcode <= "0010";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x06 SUB IMMEDIATE SIGNED
				when "000110" =>
					op_select_b <= '1';
					
					alu_en <= '1';
					alu_opcode <= "0010";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x07 SUB REGISTER UNSIGNED
				when "000111" =>
					op_select_b <= '0';
					
					alu_en <= '1';
					alu_opcode <= "0011";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
				-- 0x08 SUB IMMEDIATE UNSIGNED
				when "001000" =>
					op_select_b <= '1';
					
					alu_en <= '1';
					alu_opcode <= "0011";
					
					mem_opcode <= "000";
					
					wb_en <= '1';
					wb_select <= '0';
					
					pc_select <= "00";
					pc_opcode <= "000";
					cond_opcode <= "00";
					
			end case;
			
			-- push stack down
			reg_stack_bottom <= reg_stack_top;
			reg_stack_top <= reg_addr_a;
		end if;
	end process decode;
end architecture instruction_decoder_arch;
			
			
		
		
		
		