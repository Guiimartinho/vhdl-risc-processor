-- program counter decoder circuit
-- takes a 3-bit pc opcode and produces the necessary signals for the required function
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

-- opcode 000 is increment pc by 4
-- opcode 001 is set pc
-- opcode 010 is offset pc
-- opcode 100 is push to stack and set pc
-- opcode 101 is push to stack and offset pc
-- opcode 110 is pop from stack

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity pc_controller is
	port (
		-- opcode input
		opcode				:	in		std_logic_vector(2 downto 0);
		
		-- clock input
		clk					:	in		std_logic;
		
		-- stack push/pop signal
		stack_push			:	out	std_logic;
		
		-- pc update value select
		pc_value_select	:	out	std_logic_vector(1 downto 0);
		
		-- increment select
		inc_select			:	out	std_logic;
		
		-- stack clock enable
		stack_clk_enable	:	out	std_logic
	);
end entity pc_controller;

architecture pc_controller_arch of pc_controller is
	-- this circuit requires no internal signals
	
begin
	pc_control		:	process(clk, opcode)
	begin
		-- opcode 000 is increment pc by 4
		if opcode = "000" then
			stack_push <= '0';
			pc_value_select <= "00";
			inc_select <= '0';
			stack_clk_enable <= '0';
		-- opcode 001 is set pc to value
		elsif opcode = "001" then
			stack_push <= '0';
			pc_value_select <= "01";
			inc_select <= '0';
			stack_clk_enable <= '0';
		-- opcode 010 is increment pc by value
		elsif opcode = "010" then
			stack_push <= '0';
			pc_value_select <= "00";
			inc_select <= '1';
			stack_clk_enable <= '0';
		-- opcode 100 is push to stack and set pc
		elsif opcode = "100" then
			stack_push <= '1';
			pc_value_select <= "01";
			inc_select <= '0';
			stack_clk_enable <= '1';
		-- opcode 101 is push to stack and increment pc by value
		elsif opcode = "101" then
			stack_push <= '1';
			pc_value_select <= "00";
			inc_select <= '1';
			stack_clk_enable <= '1';
		-- opcode 110 is pop from stack
		elsif opcode = "110" then
			stack_push <= '0';
			pc_value_select <= "10";
			inc_select <= '0';
			stack_clk_enable <= '1';
		-- otherwise invalid opcode, all outputs 0
		else
			stack_push <= '0';
			pc_value_select <= "00";
			inc_select <= '0';
			stack_clk_enable <= '0';
		end if;
	end process pc_control;
end architecture pc_controller_arch;