-- program counter circuit
-- combines a register and a call/return stack into a program counter with 6 modes
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

-- 000	- increment by constant value (4)
-- 001	- set to value
-- 010	- offset by value
-- 100	- push to stack and set to value
-- 101	- push to stack and offset by value
-- 110	- pop top value from stack

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity program_counter is
	port (
		-- value for set/offset
		val_32		:	in		std_logic_vector(31 downto 0);
		
		-- clock, rst, clr, en inputs
		clk			:	in		std_logic;
		rst			:	in		std_logic;
		clr			:	in		std_logic;
		en				:	in		std_logic;
		
		-- opcode
		opcode		:	in		std_logic_vector(2 downto 0);
		
		-- address out
		addr_32		:	out	std_logic_vector(31 downto 0)
	);
end entity program_counter

architecture program_counter_arch of program_counter is
	-- signal declarations
	
	-- pc output signal
	signal reg_out			:	std_logic_vector(31 downto 0);
	-- pc reg input
	signal reg_in			:	std_logic_vector(31 downto 0);
	
	-- control signals from controller
	signal val_select		:	std_logic_vector(1 downto 0);
	signal offset_select	:	std_logic;
	signal stack_push		:	std_logic;
	signal stack_clk_en	:	std_logic;
	
	-- stack top
	signal stack_top		:	std_logic_vector(31 downto 0);
	
	-- component declarations
	
	-- controller component
	component pc_controller is
		port (
			-- opcode
			opcode				:	in		std_logic_vector(2 downto 0);
			
			-- control signals
			stack_push			:	out	std_logic;
			pc_value_select	:	out	std_logic_vector(1 downto 0);
			inc_select			:	out	std_logic;
			stack_clk_enable	:	out	std_logic
		);
	end component;
	
	-- register component
	component reg_32_bit is
		port (
			-- input
			in_32			:	in		std_logic_vector(31 downto 0);
			
			-- clk, rst, clr
			clk			:	in		std_logic;
			rst			:	in		std_logic;
			clr			:	in		std_logic;
			
			-- write enable
			wr_en			:	in		std_logic;
			
			-- output
			out_32		:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- stack component
	component stack_32_bit is
		port (
			-- top of stack write
			stack_top_write	:	in		std_logic_vector(31 downto 0);
			
			-- push, clk, clk_en, rst
			push					:	in		std_logic;
			clk					:	in		std_logic;
			clk_en				:	in		std_logic;
			rst					:	in		std_logic;
			
			-- top of stack read
			stack_top_read		:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- incrementer component
	component incrementer_32_bit is
		port (
			-- inputs
			a_32		:	in		std_logic_vector(31 downto 0);
			b_32		:	in		std_logic_vector(31 downto 0);
			
			-- output
			out_32	:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- 4-input 32-bit mux component
	component mux_4_32_bit is
		port (
			-- inputs
			in_32_0			:	in		std_logic_vector(31 downto 0);
			in_32_1			:	in		std_logic_vector(31 downto 0);
			in_32_2			:	in		std_logic_vector(31 downto 0);
			in_32_3			:	in		std_logic_vector(31 downto 0);
			
			-- input select
			input_select	:	in		std_logic_vector(1 downto 0);
			
			-- output
			out_32			:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- 2-input 32-bit mux component
	component mux_2_32_bit is
		port (
			-- inputs
			in_32_0			:	in		std_logic_vector(31 downto 0);
			in_32_1			:	in		std_logic_vector(31 downto 0);
			
			-- input select
			input_select	:	in		std_logic;
			
			-- output
			out_32			:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
begin
	-- design implementation