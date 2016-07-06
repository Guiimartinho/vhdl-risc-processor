-- register file circuit
-- contains 31 32-bit general-purpose registers, plus 1 register that is always hardcoded to 0
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity register_file is
	port (
		-- read addresses
		a_addr		:	in		std_logic_vector(4 downto 0);
		b_addr		:	in		std_logic_vector(4 downto 0);
		
		-- read data
		a_data		:	out	std_logic_vector(31 downto 0);
		b_data		:	out	std_logic_vector(31 downto 0);
		
		-- write address, enable, clock and data
		wr_addr		:	in		std_logic_vector(4 downto 0);
		wr_data		:	in		std_logic_vector(31 downto 0);
		wr_enable	:	in		std_logic;
		wr_clk		:	in		std_logic;
		
		-- async reset
		rst			:	in		std_logic
	);
end entity register_file;

architecture register_file_arch of register_file is
	-- signal declarations
	
	-- registers
	signal r01	:	std_logic_vector(31 downto 0);
	signal r02	:	std_logic_vector(31 downto 0);
	signal r03	:	std_logic_vector(31 downto 0);
	signal r04	:	std_logic_vector(31 downto 0);
	signal r05	:	std_logic_vector(31 downto 0);
	signal r06	:	std_logic_vector(31 downto 0);
	signal r07	:	std_logic_vector(31 downto 0);
	signal r08	:	std_logic_vector(31 downto 0);
	signal r09	:	std_logic_vector(31 downto 0);
	signal r10	:	std_logic_vector(31 downto 0);
	signal r11	:	std_logic_vector(31 downto 0);
	signal r12	:	std_logic_vector(31 downto 0);
	signal r13	:	std_logic_vector(31 downto 0);
	signal r14	:	std_logic_vector(31 downto 0);
	signal r15	:	std_logic_vector(31 downto 0);
	signal r16	:	std_logic_vector(31 downto 0);
	signal r17	:	std_logic_vector(31 downto 0);
	signal r18	:	std_logic_vector(31 downto 0);
	signal r19	:	std_logic_vector(31 downto 0);
	signal r20	:	std_logic_vector(31 downto 0);
	signal r21	:	std_logic_vector(31 downto 0);
	signal r22	:	std_logic_vector(31 downto 0);
	signal r23	:	std_logic_vector(31 downto 0);
	signal r24	:	std_logic_vector(31 downto 0);
	signal r25	:	std_logic_vector(31 downto 0);
	signal r26	:	std_logic_vector(31 downto 0);
	signal r27	:	std_logic_vector(31 downto 0);
	signal r28	:	std_logic_vector(31 downto 0);
	signal r29	:	std_logic_vector(31 downto 0);
	signal r30	:	std_logic_vector(31 downto 0);
	signal r31	:	std_logic_vector(31 downto 0);
	
	-- constant r0 which is hardcoded 0
	constant r00	:	std_logic_vector(31 downto 0) := (others => '0');
	
begin
	-- design implementation
	registers	:	process(a_addr, b_addr, wr_clk, rst)
	begin
		-- if reset high, clear all registers
		if rst = '1' then
			r01 <= r00;
			r02 <= r00;
			r03 <= r00;
			r04 <= r00;
			r05 <= r00;
			r06 <= r00;
			r07 <= r00;
			r08 <= r00;
			r09 <= r00;
			r10 <= r00;
			r11 <= r00;
			r12 <= r00;
			r13 <= r00;
			r14 <= r00;
			r15 <= r00;
			r16 <= r00;
			r17 <= r00;
			r18 <= r00;
			r19 <= r00;
			r20 <= r00;
			r21 <= r00;
			r22 <= r00;
			r23 <= r00;
			r24 <= r00;
			r25 <= r00;
			r26 <= r00;
			r27 <= r00;
			r28 <= r00;
			r29 <= r00;
			r30 <= r00;
			r31 <= r00;
		else
			-- reading from registers, outputting to ports a and b
			-- case statements for a
			case a_addr is
				-- 32 register cases, including r00
				when "00000"	=> a_data <= r00;
				when "00001"	=> a_data <= r01;
				when "00010"	=> a_data <= r02;
				when "00011"	=> a_data <= r03;
				when "00100"	=> a_data <= r04;
				when "00101"	=> a_data <= r05;
				when "00110"	=> a_data <= r06;
				when "00111"	=> a_data <= r07;
				when "01000"	=> a_data <= r08;
				when "01001"	=> a_data <= r09;
				when "01010"	=> a_data <= r10;
				when "01011"	=> a_data <= r11;
				when "01100"	=> a_data <= r12;
				when "01101"	=> a_data <= r13;
				when "01110"	=> a_data <= r14;
				when "01111"	=> a_data <= r15;
				when "10000"	=> a_data <= r16;
				when "10001"	=> a_data <= r17;
				when "10010"	=> a_data <= r18;
				when "10011"	=> a_data <= r19;
				when "10100"	=> a_data <= r20;
				when "10101"	=> a_data <= r21;
				when "10110"	=> a_data <= r22;
				when "10111"	=> a_data <= r23;
				when "11000"	=> a_data <= r24;
				when "11001"	=> a_data <= r25;
				when "11010"	=> a_data <= r26;
				when "11011"	=> a_data <= r27;
				when "11100"	=> a_data <= r28;
				when "11101"	=> a_data <= r29;
				when "11110"	=> a_data <= r30;
				when "11111"	=> a_data <= r31;
				-- exception case
				when others		=> a_data <= r00;
			end case;
			
			-- case statements for b
			case b_addr is
				-- 32 register cases, including r00
				when "00000"	=> b_data <= r00;
				when "00001"	=> b_data <= r01;
				when "00010"	=> b_data <= r02;
				when "00011"	=> b_data <= r03;
				when "00100"	=> b_data <= r04;
				when "00101"	=> b_data <= r05;
				when "00110"	=> b_data <= r06;
				when "00111"	=> b_data <= r07;
				when "01000"	=> b_data <= r08;
				when "01001"	=> b_data <= r09;
				when "01010"	=> b_data <= r10;
				when "01011"	=> b_data <= r11;
				when "01100"	=> b_data <= r12;
				when "01101"	=> b_data <= r13;
				when "01110"	=> b_data <= r14;
				when "01111"	=> b_data <= r15;
				when "10000"	=> b_data <= r16;
				when "10001"	=> b_data <= r17;
				when "10010"	=> b_data <= r18;
				when "10011"	=> b_data <= r19;
				when "10100"	=> b_data <= r20;
				when "10101"	=> b_data <= r21;
				when "10110"	=> b_data <= r22;
				when "10111"	=> b_data <= r23;
				when "11000"	=> b_data <= r24;
				when "11001"	=> b_data <= r25;
				when "11010"	=> b_data <= r26;
				when "11011"	=> b_data <= r27;
				when "11100"	=> b_data <= r28;
				when "11101"	=> b_data <= r29;
				when "11110"	=> b_data <= r30;
				when "11111"	=> b_data <= r31;
				-- exception case
				when others		=> b_data <= r00;
			end case;
			
			-- writing to registers
			if rising_edge(wr_clk) then 
				if wr_enable = '1' then
					-- case statement for writing to register
					case wr_addr is
						-- note exclusion of address 00000, r00 cannot be written to
						when "00001"	=> r01 <= wr_data;
						when "00010"	=> r02 <= wr_data;
						when "00011"	=> r03 <= wr_data;
						when "00100"	=> r04 <= wr_data;
						when "00101"	=> r05 <= wr_data;
						when "00110"	=> r06 <= wr_data;
						when "00111"	=> r07 <= wr_data;
						when "01000"	=> r08 <= wr_data;
						when "01001"	=> r09 <= wr_data;
						when "01010"	=> r10 <= wr_data;
						when "01011"	=> r11 <= wr_data;
						when "01100"	=> r12 <= wr_data;
						when "01101"	=> r13 <= wr_data;
						when "01110"	=> r14 <= wr_data;
						when "01111"	=> r15 <= wr_data;
						when "10000"	=> r16 <= wr_data;
						when "10001"	=> r17 <= wr_data;
						when "10010"	=> r18 <= wr_data;
						when "10011"	=> r19 <= wr_data;
						when "10100"	=> r20 <= wr_data;
						when "10101"	=> r21 <= wr_data;
						when "10110"	=> r22 <= wr_data;
						when "10111"	=> r23 <= wr_data;
						when "11000"	=> r24 <= wr_data;
						when "11001"	=> r25 <= wr_data;
						when "11010"	=> r26 <= wr_data;
						when "11011"	=> r27 <= wr_data;
						when "11100"	=> r28 <= wr_data;
						when "11101"	=> r29 <= wr_data;
						when "11110"	=> r30 <= wr_data;
						when "11111"	=> r31 <= wr_data;
					end case;
				end if;
			end if;
		end if;
	
	end process registers;
end architecture register_file_arch;