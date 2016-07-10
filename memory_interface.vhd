-- memory interface circuit
-- handles memory read/write and memory mapping to internal and external memory/io
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

-- opcodes

-- 000 is no operation

-- 001 is read byte
-- 010 is read half-word
-- 011 is read word

-- 100 is write byte
-- 101 is write half-word
-- 110 is write word

-- 111 is set block address

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity memory_interface is
	port (
		-- address
		addr			:	in		std_logic_vector(31 downto 0);
		
		-- data in/out
		data_in		:	in		std_logic_vector(31 downto 0);
		data_out		:	out	std_logic_vector(31 downto 0) := (others => '0');
		
		-- memory opcode
		opcode		:	in		std_logic_vector(2 downto 0);
		
		-- rst, clk and bsy signal
		rst			:	in		std_logic;
		clk			:	in		std_logic;
		bsy			:	out	std_logic := '0';
		
		-- address output, data inout, clk
		ext_addr		:	out	std_logic_vector(31 downto 0);
		ext_data		:	inout	std_logic_vector(7 downto 0);
		ext_clk		:	out	std_logic;
		
		-- data access clock
		data_clk		:	in		std_logic
	);
end entity memory_interface;

architecture memory_interface_arch of memory_interface is
	-- block address
	signal block_addr		:	integer := 0;
	
	-- memory address
	signal mem_addr		:	integer;
	
	-- internal r/w
	signal wr				:	std_logic;
	
	-- bytes, counter
	signal bytes			:	integer;
	signal count			:	integer := 0;
	
	-- external memory access active
	signal ext_active		:	std_logic;
	
	-- internal data buffer
	signal data_buf		:	std_logic_vector(31 downto 0);
	
begin
	-- design implementation
	interface	:	process(clk)
	begin
		-- on reset high, reset internal counter, block address and signal bits
		if rst = '1' then
			block_addr <= 0;
			bytes <= 0;
			mem_addr <= 0;
			
			wr <= '0';
			ext_active <= '0';
			bsy <= '0';
			data_out <= (others => '0');
			ext_addr <= (others => '0');
		
		else	
			-- on rising clock edge, read/write
			if rising_edge(clk) then
				-- signal memory busy
				bsy <= '1';
				-- calculate address
				mem_addr <= block_addr + to_integer(unsigned(addr));
				
				-- opcode 001 is read byte
				if opcode = "001" then
					wr <= '0';
					bytes <= 2;
					ext_active <= '1';
				-- opcode 010 is read half-word
				elsif opcode = "010" then
					wr <= '0';
					bytes <= 2;
					ext_active <= '1';
				-- opcode 011 is read word
				elsif opcode = "011" then
					wr <= '0';
					bytes <= 4;
					ext_active <= '1';
				
				-- opcode 100 is write byte
				elsif opcode = "100" then
					wr <= '1';
					bytes <= 1;
					ext_active <= '1';
				-- opcode 101 is write half-word
				elsif opcode = "101" then
					wr <= '1';
					bytes <= 2;
					ext_active <= '1';
				-- opcode 110 is write word
				elsif opcode = "110" then
					wr <= '1';
					bytes <= 4;
					ext_active <= '1';
				
				-- opcode 111 is set block addr
				elsif opcode = "111" then
					wr <= '0';
					bytes <= 0;
					ext_active <= '0';
					
					block_addr <= to_integer(unsigned(addr));
				end if;
				
				-- read/write if external memory access flag set
				if ext_active = '1' then
					while count < bytes loop
						-- set external address
						ext_addr <= std_logic_vector(to_unsigned(mem_addr, 32));
						if wr = '1' then
							-- first byte
							if count = 0 then
								ext_data <= data_in(7 downto 0);
							-- second byte
							elsif count = 1 then
								ext_data <= data_in(15 downto 8);
							-- third byte
							elsif count = 2 then
								ext_data <= data_in(23 downto 16);
							-- fourth byte
							elsif count = 3 then
								ext_data <= data_in(31 downto 24);
							end if;
						else
							-- first byte
							if count = 0 then
								data_buf(7 downto 0) <= ext_data;
							-- second byte
							elsif count = 1 then
								data_buf(15 downto 8) <= ext_data;
							-- third byte
							elsif count = 2 then
								data_buf(23 downto 16) <= ext_data;
							-- fourth byte
							elsif count = 3 then
								data_buf(31 downto 24) <= ext_data;
							end if;
						end if;
							
						-- on rising data clk edge set external clock high if writing
						if rising_edge(data_clk) then
							if wr = '1' then
								ext_clk <= '1';
							end if;
						end if;	
							
						-- on falling edge set external clock low if writing and increment count and addr
						if falling_edge(data_clk) then
							if wr = '1' then
								ext_clk <= '0';
							end if;
							
							count <= count + 1;
							mem_addr <= mem_addr + 1;
						end if;
					end loop;
					
					-- update data_out line with internal buffer contents
					if wr = '0' then
						data_out <= data_buf;
					end if;
				end if;
				
				-- signal memory no longer busy
				bsy <= '0';
			end if;
		end if;
	end process interface;
end architecture memory_interface_arch;
				
							