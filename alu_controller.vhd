-- ALU control unit
-- this circuit takes a 4-bit opcode and translates it into the control signals which control the ALU function
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity alu_controller is
	port (
		-- inputs
		opcode_in		:	in		std_logic_vector(3 downto 0);
		enable			:	in		std_logic;
		
		-- outputs
		-- enable lines for the 4 functional blocks
		adder_enable	:	out	std_logic;
		shifter_enable	:	out	std_logic;
		logic_enable	:	out	std_logic;
		tester_enable	:	out	std_logic;
		
		-- opcode which is passed to all 4 blocks
		opcode_out		:	out	std_logic_vector(1 downto 0);
		
		-- signals which control output select multiplexers
		result_select	:	out	std_logic_vector(1 downto 0);
		test_select		:	out	std_logic;
		carry_select	:	out	std_logic
	);
	
end entity alu_controller;

architecture alu_controller_arch of alu_controller is
	-- this circuit requires no internal signals
	
begin
	-- design implementation
	alu_control		:	process(enable, opcode_in)
	begin
		-- opcode 00xx is adder functions
		if opcode_in(3 downto 2) = "00" then
			-- adder enable line is 1, all other lines 0
			adder_enable <= '1';
			shifter_enable <= '0';
			logic_enable <= '0';
			tester_enable <= '0';
			
			-- select adder result, select carry result, select 0 for test
			result_select <= "00";
			carry_select <= '1';
			test_select <= '0';
			
		-- opcode 01xx is shifter functions
		elsif opcode_in(3 downto 2) = "01" then
			-- shifter enable line is 1, all other lines 0
			adder_enable <= '0';
			shifter_enable <= '1';
			logic_enable <= '0';
			tester_enable <= '0';
			
			-- select shifter result, select 0 for carry and test
			result_select <= "01";
			carry_select <= '0';
			test_select <= '0';
			
		-- opcode 10xx is logic functions
		elsif opcode_in(3 downto 2) = "10" then
			-- logic enable line is 1, all other lines 0
			adder_enable <= '0';
			shifter_enable <= '0';
			logic_enable <= '1';
			tester_enable <= '0';
			
			-- select logic result, select 0 for carry and test
			result_select <= "10";
			carry_select <= '0';
			test_select <= '0';
			
		-- opcode 11xx is test functions
		elsif opcode_in(3 downto 2) = "11" then
			-- tester enable line is 1, all other lines 0
			adder_enable <= '0';
			shifter_enable <= '0';
			logic_enable <= '0';
			tester_enable <= '1';
			
			-- select 0 result because tester does not produce a 32-bit result
			-- select 0 for carry, select test result
			result_select <= "11";
			carry_select <= '0';
			test_select <= '1';
		end if;
		
		-- set opcode out to last two bits of opcode in, to select functions within functional blocks
		opcode_out <= opcode_in(1 downto 0);
	end process alu_control;
	
end architecture alu_controller_arch;
			