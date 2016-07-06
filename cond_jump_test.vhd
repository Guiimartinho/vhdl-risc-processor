-- conditional jump test circuit
-- filters program opcode based on three conditions and an opcode
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

-- opcode 00 is no jump
-- opcode 01 is jump on test
-- opcode 10 is jump on carry
-- opcode 11 is jump on overflow

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cond_jump_test is
	port (
		-- opcode
		opcode		:	in		std_logic_vector(1 downto 0);
		
		-- pc opcode to be filtered
		pc_op			:	in		std_logic_vector(2 downto 0);
		
		-- signals to be tested
		test			:	in		std_logic;
		carry			:	in		std_logic;
		overflow		:	in		std_logic;
		
		-- pc opcode after filtering
		pc_op_out	:	out	std_logic_vector(2 downto 0)
	);
end entity cond_jump_test;

architecture cond_jump_test_arch of cond_jump_test is
	-- no internal signals
begin
	-- design implementation
	cond_jump	:	process(opcode, pc_op, test, carry, overflow)
	begin
		if opcode = "00" then
			pc_op_out <= pc_op;
		elsif opcode = "01" then
			if test = '1' then
				pc_op_out <= pc_op;
			else
				pc_op_out <= "000";
			end if;
		elsif opcode = "10" then
			if carry = '1' then
				pc_op_out <= pc_op;
			else
				pc_op_out <= "000";
			end if;
		elsif opcode = "11" then
			if overflow = '1' then
				pc_op_out <= pc_op;
			else
				pc_op_out <= "000";
			end if;
		end if;
	end process cond_jump;
end architecture cond_jump_test_arch;