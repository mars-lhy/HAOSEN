------------------------------------------------------------------------
--	CircularBuffer.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module handles writing and reading in the circular buffer. Writing
--	takes place with a frequency of 48 kHz, equal to that of the sample rate.
--	Reading is allowed in the rest of the time. The reading address is obtained
--	by subtracting an offset (generated by the effect units) from the current
--	write address. Between the current write address and the previous
--	address there is a time difference of 20 microseconds (1 / 48 kHz).
--	The larger the offset, the larger the time difference.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CircularBuffer is
	port (
		clk					: in STD_LOGIC; -- Master clock (50 MHz)
		readAddressOffset	: in STD_LOGIC_VECTOR(13 downto 0); -- The read address
		dataIn				: in STD_LOGIC_VECTOR(7 downto 0); -- Input data
		dataOut				: out STD_LOGIC_VECTOR(7 downto 0) -- Output data
	);
end CircularBuffer;

architecture Behavioral of CircularBuffer is

	-- THIS COMPONENT REPRESENTS THE CIRCULAR BUFFER
	component CircularMemory is
		port (
			clk		: in STD_LOGIC;
			we			: in STD_LOGIC;
			address	: in STD_LOGIC_VECTOR(13 downto 0);
			dataIn	: in STD_LOGIC_VECTOR(7 downto 0);
			dataOut	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	signal counter			: NATURAL;
	signal we				: STD_LOGIC;
	signal address_temp	: STD_LOGIC_VECTOR(13 downto 0);
	signal writeAddress	: STD_LOGIC_VECTOR(13 downto 0);

begin

	CircularMemory_Map: CircularMemory port map (
		clk => clk,
		we => we,
		address => address_temp,
		dataIn => dataIn,
		dataOut => dataOut
	);
	
	
	-- This process controls writing and reading in the buffer.
	-- Writing is done at a frequency of 48 kHz, and reading is enabled in the rest of the time.
	-- Example: 0 .................... 1040 0 .....
	-- 			R R ................ R W    R R ...
	process (clk)
	begin
		if rising_edge(clk) then
			if (counter < 1040) then -- 48 kHz
				counter <= counter + 1;
				we <= '0'; -- writing is disabled, reading can be done
			else
				counter <= 0;
				we <= '1'; -- writing is enabled, no reading allowed
			end if;
		end if;
	end process;
	
	
	-- This process increments the writing address.
	process (we)
	begin
		if rising_edge(we) then -- the address is incremented at a frequency of 48 KHz
			writeAddress <= writeAddress + 1;
		end if;
	end process;
	
	
	-- The read address is obtaind by subtracting 'readAddressOffset' from the current write address.
	-- Smaller addresses represent older data.
	address_temp <= writeAddress when (we = '1') else -- write address
		writeAddress - readAddressOffset; -- read address
	
end Behavioral;