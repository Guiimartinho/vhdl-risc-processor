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
end entity program_counter;

architecture program_counter_arch of program_counter is
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
			clk_enable			:	in		std_logic;
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
	
	-- stack top in and out
	signal stack_top_in	:	std_logic_vector(31 downto 0);
	signal stack_top_out	:	std_logic_vector(31 downto 0);
	
	-- offset result signal
	signal offset_result	:	std_logic_vector(31 downto 0);
	-- offset input a signal
	signal offset_inc_a	:	std_logic_vector(31 downto 0);
	
	
begin
	-- design implementation
	
	-- controller instantiation
	controller	:	pc_controller
	port map (
		-- opcode mapped to opcode input
		opcode					=> opcode,
		
		-- stack push mapped to stack push signal
		stack_push				=>	stack_push,
		-- pc val select mapped to val select signal
		pc_value_select		=> val_select,
		-- inc select mapped to offset select signal
		inc_select				=> offset_select,
		-- stack clock enable mapped to stack clock enable signal
		stack_clk_enable		=> stack_clk_en
	);
	
	-- register insantiation
	reg			:	reg_32_bit
	port map (
		-- input mapped to reg in signal
		in_32			=>	reg_in,
		
		-- clk, rst and clr inputs mapped to clk, rst and clr inputs
		clk			=> clk,
		rst			=>	rst,
		clr			=> clr,
		
		-- wr en mapped to en input
		wr_en			=> en,
		
		-- output mapped to reg out signal
		out_32		=> reg_out
	);
	
	-- stack instantiation
	stack			:	stack_32_bit
	port map (
		-- stack top write mapped to stack top in signal
		stack_top_write		=>	stack_top_in,
		
		-- push mapped to stack_push signal
		push						=>	stack_push,
		-- clk mapped to clk input
		clk						=>	clk,
		-- clk_enable mapped to stack_clk_en signal
		clk_enable				=>	stack_clk_en,
		-- rst mapped to rst input
		rst						=>	rst,
		
		-- stack top read mapped to stack top out signal
		stack_top_read			=>	stack_top_out
	);
	
	-- 4-input set mux instantiation
	set_mux		:	mux_4_32_bit
	port map (
		-- input 0 is offset result
		in_32_0			=>	offset_result,
		-- input 1 is set value
		in_32_1			=>	val_32,
		-- input 2 is top of stack
		in_32_2			=>	stack_top_out,
		-- input 3 is 0
		in_32_3			=> (others => '0'),
		
		-- input select mapped to val select signal
		input_select	=>	val_select,
		
		-- output mapped to reg in signal 
		out_32			=> reg_in
	);
	
	-- 2-input offset mux instantiation
	offset_mux	:	mux_2_32_bit
	port map (
		-- input 0 is constant 4
		in_32_0			=> (2 => '1', others => '0'),
		-- input 1 is input value
		in_32_1			=>	val_32,
		
		-- input select mapped to offset select signal
		input_select	=> offset_select,
		
		-- output mapped to offset operand a
		out_32			=> offset_inc_a
	);
	
	-- offset incrementer instantiation
	offset_inc	:	incrementer_32_bit
	port map (
		-- operand a is offset operand a from mux
		a_32		=>	offset_inc_a,
		-- operand b is current value of register
		b_32		=> reg_out,
		
		-- result mapped to offset result signal
		out_32	=> offset_result
	);
	
	-- stack top write incrementer instantiation
	stack_top_inc	:	incrementer_32_bit
	port map (
		-- operand a is current value of register
		a_32		=> reg_out,
		-- operand b is constant 4
		b_32		=> (2 => '1', others => '0'),
		
		-- output mapped to stack top in
		out_32	=>	stack_top_in
	);
	
	-- set address output to current register value
	addr_32 <= reg_out;
	
end architecture program_counter_arch;
