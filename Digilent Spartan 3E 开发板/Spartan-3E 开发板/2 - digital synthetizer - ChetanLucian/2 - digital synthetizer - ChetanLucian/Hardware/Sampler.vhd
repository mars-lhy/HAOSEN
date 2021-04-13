------------------------------------------------------------------------
--	Sampler.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module resamples the data comong from the oscillators. That data
--	has various sampling frequencies ranging from 44.8 kHz (note F3) and
--	253 kHz (note B5). The design allows data to pass at the frequency of
--	48 kHz.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Sampler is
	port (
		clk		: in STD_LOGIC; -- Master clock (50 MHz)
		dataIn	: in STD_LOGIC_VECTOR(7 downto 0); -- The input data
		dataOut	: out STD_LOGIC_VECTOR(7 downto 0) -- The sampled output data
	);
end Sampler;

architecture Behavioral of Sampler is

	signal counter: NATURAL;

begin

	-- This process samples the data. Tt allows incoming data to be output at a rate of 48 kHz.
	-- Example: The note E5 has the frequency 659 Hz. The basic oscillator generates 256 values at that frequency.
	-- During a second, 659 * 256 = 168,704 samples will be generated (~168 KHz). Resampling to 48 KHz slightly
	-- changes the sound, but allows applying the effects more easily.
	sampler: process (clk)
	begin
		if rising_edge(clk) then
			if (counter < 1040) then -- 50 MHz / 48 kHz ~= 1040
				counter <= counter + 1;
			else
				counter <= 0;
				dataOut <= dataIn;
			end if;
		end if;
	end process;

end Behavioral;