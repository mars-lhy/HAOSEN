------------------------------------------------------------------------
--	DelayEcho.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module generates data with constant delay. The delayed data is read
--	from the circular buffer.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DelayEcho is
	port (
		delayTime			: in STD_LOGIC_VECTOR(1 downto 0); -- Selects the delay time
		readAddressOffset	: out STD_LOGIC_VECTOR(13 downto 0); -- The address where to read data in the circular buffer
		dataIn				: in STD_LOGIC_VECTOR(7 downto 0); -- Input data
		dataOutWet			: out STD_LOGIC_VECTOR(7 downto 0) -- Output data
	);
end DelayEcho;

architecture Behavioral of DelayEcho is

begin

	-- The 'delay' effect is obtained by reading data in the buffer at a specific address,
	--	If at address 'k' the current generated data can be found, at address 'k - d'
	-- data generated 'd' * 20 us ago can be found.
	-- Two values at consecutive addresses in the circular buffer have a time difference of 20 microseconds.
	-- Two values situated 2000 positions appart have a time difference of 2000 * 20 us = 40 milliseconds.
	readAddressOffset <=
		"00011111010000" when (delayTime = "00") else -- 40 ms = 2000 * 20 us
		"00111110100000" when (delayTime = "01") else -- 80 ms = 4000 * 20 us
		"01111101000000" when (delayTime = "10") else -- 160 ms = 8000 * 20 us
		"11111010000000"; -- 320 ms * 16000 * 20 us
		
	dataOutWet <= dataIn;

end Behavioral;