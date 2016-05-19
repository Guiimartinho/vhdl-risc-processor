-- 32-bit ALU circuit for a 32-bit RISC architecture
-- this circuit combines the four functional blocks (adder, shifter, logic, test) along with multiplexers and a controller
-- to form an ALU for use in a pipelined architecture
-- this ALU supports the following operations (with 4-bit opcodes given)

-- ADD 	0000 	Add signed
-- ADDC 	0001	Add unsigned
-- SUB	0010	Subtract signed
-- SUBB	0011	Subtract unsigned

-- SLL	0100	Shift left logical
-- SRL	0101	Shift right logical
-- SLA	0110	Shift left arithmetic (copy lsb)
-- SRA	0111	Shift right arithmetic (copy msb)

-- OR		1000	Logical OR
-- AND	1001	Logical AND
-- XOR	1010	Logical XOR
-- NOT	1011	Logical NOT (operand A)

-- ZERO	1100	Test if operand a equals 0
-- LESS	1101	Test if operand a < operand b
-- GRT	1110	Test if operand a > operand b
-- EQU	1111	Test if operand a = operand b

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity alu_32_bit is
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
	
end entity alu_32_bit;

architecture alu_32_bit_arch of alu_32_bit is
	-- controller component
	component alu_controller is
		port (
			-- inputs
			opcode_in			:	in		std_logic_vector(3 downto 0);
			enable				:	in		std_logic;
			
			-- outputs
			-- functional block enable signals
			adder_enable		:	out	std_logic;
			shifter_enable		:	out	std_logic;
			logic_enable		:	out	std_logic;
			tester_enable		:	out	std_logic;
			
			-- opcode output
			opcode_out			:	out	std_logic_vector(1 downto 0);
			
			-- select signals
			result_select		:	out	std_logic_vector(1 downto 0);
			test_select			:	out	std_logic;
			carry_select		:	out	std_logic_vector(1 downto 0);
			overflow_select	:	out	std_logic
		);
	end component;
	
	-- 2-input mux component
	component mux_2_single_bit is
		port (
			-- inputs
			in_signal_0			:	in		std_logic;
			in_signal_1			:	in		std_logic;
			
			-- select signal
			input_select		:	in		std_logic;
			
			-- output
			out_signal			:	out	std_logic
		);
	end component;
	
	-- 4-input mux component
	component mux_4_single_bit is
		port (
			-- inputs
			in_signal_0			:	in		std_logic;
			in_signal_1			:	in		std_logic;
			in_signal_2			:	in		std_logic;
			in_signal_3			:	in		std_logic;
			
			-- select signal
			input_select		:	in		std_logic_vector(1 downto 0);
			
			-- output
			out_signal			:	out	std_logic
		);
	end component;
	
	-- 4-input mux component
	component mux_4_32_bit is
		port (
			-- inputs
			in_32_0			:	in		std_logic_vector(31 downto 0);
			in_32_1			:	in		std_logic_vector(31 downto 0);
			in_32_2			:	in		std_logic_vector(31 downto 0);
			in_32_3			:	in		std_logic_vector(31 downto 0);
			
			-- select signal
			input_select	:	in		std_logic_vector(1 downto 0);
			
			-- output
			out_32			:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- adder component
	component adder_32_bit is
		port (
			-- inputs
			a_32				:	in		std_logic_vector(31 downto 0);
			b_32				:	in		std_logic_vector(31 downto 0);
			
			opcode			:	in		std_logic_vector(1 downto 0);
			enable			:	in		std_logic;
			
			-- outputs
			sum_32			:	out	std_logic_vector(31 downto 0);
			carry				:	out	std_logic;
			overflow			:	out	std_logic
		);
	end component;
	
	-- shifter component
	component shifter_32_bit is
		port (
			-- inputs
			a_32				:	in		std_logic_vector(31 downto 0);
			
			opcode			:	in		std_logic_vector(1 downto 0);
			enable 			:	in		std_logic;
			
			-- outputs
			result_32		:	out	std_logic_vector(31 downto 0);
			carry_out		:	out	std_logic
		);
	end component;
	
	-- logic component
	component logic_32_bit is
		port (
			-- inputs
			a_32				:	in		std_logic_vector(31 downto 0);
			b_32				:	in		std_logic_vector(31 downto 0);
			
			opcode			:	in		std_logic_vector(1 downto 0);
			enable			:	in		std_logic;
			
			-- outputs
			result_32		:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- tester component
	component tester_32_bit is
		port (
			-- inputs
			a_32				:	in		std_logic_vector(31 downto 0);
			b_32				:	in		std_logic_vector(31 downto 0);
			
			opcode			:	in		std_logic_vector(1 downto 0);
			enable			:	in		std_logic;
			
			-- outputs
			result			:	out	std_logic
		);
	end component;
	
	-- internal signal declarations
	-- enable lines for functional blocks
	signal adder_enable			:	std_logic;
	signal shifter_enable		:	std_logic;
	signal logic_enable			:	std_logic;
	signal tester_enable			:	std_logic;
	
	-- opcode and operand signals
	signal opcode_line			:	std_logic_vector(1 downto 0);
	
	-- multiplexer control signals
	signal result_select			:	std_logic_vector(1 downto 0);
	signal test_select			:	std_logic;
	signal carry_select			:	std_logic_vector(1 downto 0);
	signal overflow_select		:	std_logic;
	
	-- functional block output signals
	-- adder
	signal adder_result_32		:	std_logic_vector(31 downto 0);
	signal adder_carry_out		:	std_logic;
	signal adder_overflow		:	std_logic;
	
	-- shifter
	signal shifter_result_32	:	std_logic_vector(31 downto 0);
	signal shifter_carry_out	:	std_logic;
	
	-- logic
	signal logic_result_32		:	std_logic_vector(31 downto 0);
	
	-- tester
	signal tester_result			:	std_logic;
	
begin
	-- design implementation
	-- ALU controller instantiation
	controller	:	alu_controller
	port map (
		-- opcode and enable port mapping
		opcode_in		=> opcode,
		enable			=> enable,
	
		-- functional block enable line mapping
		adder_enable	=> adder_enable,
		shifter_enable	=>	shifter_enable,
		logic_enable	=>	logic_enable,
		tester_enable	=>	tester_enable,
		
		-- functional block opcode line mapping
		opcode_out		=> opcode_line,
		
		-- mux select signal mapping
		result_select 	=> result_select,
		test_select 	=>	test_select,
		carry_select	=>	carry_select,
		overflow_select	=>	overflow_select
	);
	
	-- test result select mux instantiation
	test_mux		:	mux_2_single_bit
	port map (
		-- input signals
		in_signal_0		=> tester_result,
		in_signal_1		=> '0',
		
		-- input select
		input_select 	=> test_select,
		
		-- output
		out_signal		=> test_out
	);
	
	-- overflow select mux instantiation
	overflow_mux	:	mux_2_single_bit
	port map (
		-- input signals
		in_signal_0		=> '0',
		in_signal_1		=> adder_overflow,
		
		-- input select
		input_select	=> overflow_select,
		
		-- output
		out_signal		=> overflow_out
	);
	
	-- carry result select mux instantiation
	carry_mux	:	mux_4_single_bit
	port map (
		-- input signals
		in_signal_0		=> adder_carry_out,
		in_signal_1		=> shifter_carry_out,
		in_signal_2		=>	'0',
		in_signal_3		=>	'0',
		
		-- input select
		input_select	=>	carry_select,
		
		-- output
		out_signal		=> carry_out
	);
	
	-- 32-bit result mux instantiation
	result_mux	:	mux_4_32_bit
	port map (
		-- input signals
		in_32_0			=> adder_result_32,
		in_32_1			=>	shifter_result_32,
		in_32_2			=>	logic_result_32,
		in_32_3			=>	(others => '0'),
		
		-- input select
		input_select	=> result_select,
		
		-- output
		out_32			=> result_32
	);
	
	-- adder instantiation
	adder			:	adder_32_bit
	port map (
		-- inputs
		a_32 				=> a_32,
		b_32				=>	b_32,
		
		-- opcode and enable
		opcode 			=> opcode_line,
		enable			=> adder_enable,
		
		-- outputs
		sum_32			=> adder_result_32,
		carry				=> adder_carry_out,
		overflow			=> adder_overflow
	);
	
	-- shifter instantiation
	shifter		:	shifter_32_bit
	port map (
		-- inputs
		a_32				=> a_32,
		
		-- opcode and enable
		opcode			=> opcode_line,
		enable			=> shifter_enable,
		
		-- outputs
		result_32		=> shifter_result_32,
		carry_out		=> shifter_carry_out
	);
	
	-- logic instantiation
	logic			:	logic_32_bit
	port map (
		-- inputs
		a_32				=>	a_32,
		b_32				=>	b_32,
		
		-- opcode and enable
		opcode			=> opcode_line,
		enable			=> logic_enable,
		
		-- outputs
		result_32		=> logic_result_32
	);
	
	-- tester instantiation
	tester		:	tester_32_bit
	port map (
		-- inputs
		a_32				=> a_32,
		b_32				=> b_32,
		
		-- opcode and enable
		opcode			=>	opcode_line,
		enable			=>	tester_enable,
		
		-- outputs
		result			=> tester_result
	);

end architecture alu_32_bit_arch;	