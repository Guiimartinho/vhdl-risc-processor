-- data bus, connects internal memory interface to i/o ports and internal/external memory
-- all code (c) copyright 2016 Jay Valentine, released under the MIT license

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- declaring array for i/o port
package io_port_type is
	type io_port is array(15 downto 0) of std_logic_vector(7 downto 0);
end package io_port_type;

use work.io_port_type.all;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity data_bus is
	port (
		-- address in
		addr					:	in		std_logic_vector(31 downto 0);
		
		-- data from/to interface
		interface_data		:	inout	std_logic_vector(7 downto 0);
		
		-- clk and w/r
		clk					:	in		std_logic;
		wr						:	in		std_logic;
		
		-- data from/to i/o
		io_data				:	inout	io_port;
		
		-- internal memory addr, data, clk
		int_mem_addr		:	out	std_logic_vector(9 downto 0);
		int_mem_data		:	inout	std_logic_vector(7 downto 0);
		int_mem_clk			:	out	std_logic;
		
		-- external memory addr, data, clk
		ext_mem_addr		:	out	std_logic_vector(31 downto 0);
		ext_mem_data		:	inout	std_logic_vector(7 downto 0);
		ext_mem_clk			:	out	std_logic
	);
end entity data_bus;

architecture data_bus_arch of data_bus is
	-- internal bank selection
	signal bank		:	integer;
	
begin
	-- design implementation
	data_bus_process		:	process(clk, addr)
	begin
		if to_integer(unsigned(addr)) > 1040 then
			-- select external memory
			bank <= 2;
			
			-- set external memory address
			ext_mem_addr <= std_logic_vector(unsigned(addr) - to_unsigned(1041, 32));
		
			-- if writing, set data
			if wr = '1' then
				ext_mem_data <= interface_data;
			end if;
			
			-- reset internal mem signals
			int_mem_addr <= (others => '0');
			int_mem_data <= (others => '0');
			
		elsif to_integer(unsigned(addr)) > 15 then
			-- select internal memory
			bank <= 1;
			
			-- set internal memory address
			int_mem_addr <= std_logic_vector(unsigned(addr) - to_unsigned(15, 32))(9 downto 0);
			
			-- if writing, set data
			if wr = '1' then
				int_mem_data <= interface_data;
			end if;
			
			-- reset external mem signals
			ext_mem_addr <= (others => '0');
			ext_mem_data <= (others => '0');
			
		else
			-- select i/o ports
			bank <= 0;
		end if;
			
		-- on clock rising edge, read or write from selected bank
		if rising_edge(clk) then
			-- read or write i/o
			if bank <= 0 then
				if wr = '1' then
					io_data(to_integer(unsigned(addr))) <= interface_data;
				else
					interface_data <= io_data(to_integer(unsigned(addr)));
				end if;
				
			-- read or write internal memory
			elsif bank <= 1 then
				if wr = '1' then
					int_mem_clk <= '1';
				else
					interface_data <= int_mem_data;
				end if;
			
			-- read or write external memory
			elsif bank <= 2 then
				if wr = '1' then
					ext_mem_clk <= '1';
				else
					interface_data <= ext_mem_data;
				end if;
			end if;
		end if;
		
		-- on clock falling edge, reset secondary clocks
		if falling_edge(clk) then
			ext_mem_clk <= '0';
			int_mem_clk <= '0';
		end if;
	end process data_bus_process;
end architecture data_bus_arch;
					