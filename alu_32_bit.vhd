-- 32-bit ALU circuit for a 32-bit RISC architecture
-- this circuit combines the four functional blocks (adder, shifter, logic, test) along with multiplexers and a controller
-- to form an ALU for use in a pipelined architecture
-- this ALU supports the following operations (with 4-bit opcodes given)

-- ADD 	0000 	Add without carry
-- ADDC 	0001	Add with carry
-- SUB	0010	Subtract without borrow
-- SUBB	0011	Subtract with borrow

-- SLL	0100	Shift left logical
-- SRL	0101	Shift right logical
-- SRA	0110	Shift right arithmetic

-- OR		1000	Logical OR
-- AND	1001	Logical AND
-- XOR	1010	Logical XOR
-- NOT	1011	Logical NOT (operand A)

-- ZERO	1100	Test if operand a equals 0
-- GRT	1101	Test if operand a > operand b
-- LESS	1110	Test if operand a < operand b
-- EQU	1111	Test if operand a = operand b

entity alu_32_bit is
	port (
		-- operand inputs
		a_32			:	in		std_logic_vector(31 downto 0);
		b_32			:	in		std_logic_vector(31 downto 0);
		
		-- carry input
		carry_in		:	in		std_logic;
		
		-- opcode input
		opcode		:	in		std_logic_vector(3 downto 0);
		
		-- result output
		result_32	:	out	std_logic_vector(31 downto 0);
		
		-- test and carry outputs
		test_out		:	out	std_logic;
		carry_out	:	out	std_logic
	);
	
end entity alu_32_bit;

architecture alu_32_bit_arch of alu_32_bit is;
	-- controller component
	component alu_controller is
		port (
			-- inputs
			opcode_in		:	in		std_logic_vector(3 downto 0);
			enable			:	in		std_logic;
			
			-- outputs
			-- functional block enable signals
			adder_enable	:	out	std_logic;
			shifter_enable	:	out	std_logic;
			logic_enable	:	out	std_logic;
			tester_enable	:	out	std_logic;
			
			-- opcode output
			opcode_out		:	out	std_logic_vector(1 downto 0);
			
			-- select signals
			result_select	:	out	std_logic_vector(1 downto 0;
			test_select		:	out	std_logic;
			carry_select	:	out	std_logic
		);
	end component;
	
	-- 2-input mux component
	component mux_2_32_bit is
		port (
			-- inputs
			in_32_1			:	in		std_logic_vector(31 downto 0);
			in_32_2			:	in		std_logic_vector(31 downto 0);
			
			-- select signal
			input_select	:	in		std_logic;
			
			-- output
			out_32			:	out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- 4-input mux component
	component mux_4_32_bit is
		port (
			-- inputs
			in_32_1			:	in		std_logic_vector(31 downto 0);
			in_32_2			:	in		std_logic_vector(31 downto 0);
			in_32_3			:	in		std_logic_vector(31 downto 0);
			in_32_4			:	in		std_logic_vector(31 downto 0);
			
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
			c_in				:	in		std_logic;
			
			opcode			:	in		std_logic_vector(1 downto 0);
			enable			:	in		std_logic;
			
			-- outputs
			sum_32			:	out	std_logic_vector(31 downto 0);
			c_out				:	out	std_logic
		);
	end component;