------------------------------------------------------------------------
--	SpiUnit.vhd
------------------------------------------------------------------------
--	Author: Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module receives the data and the control byte to be sent and creates
--	a 16-bit word, which is output bit by bit to the DAC. After sending the
--	entire word, a synchronization impulse is sent on the "sync" line. This
--	commands the DAC to process the data is has already received.
--	The DAC works at frequencies lower than 30 MHz. The design provides a
--	25 MHz clock.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SpiUnit is
	port (
		clk		: in STD_LOGIC; -- Master clock (50 MHz)
		data		: in STD_LOGIC_VECTOR(7 downto 0); -- Data byte
		control	: in STD_LOGIC_VECTOR(7 downto 0); -- Control byte
		sclk		: out STD_LOGIC; -- Serial clock
		sync		: out STD_LOGIC; -- Synchronize signal
		sdata		: out STD_LOGIC -- Serial data
	);
end SpiUnit;

architecture Behavioral of SpiUnit is

	signal bitCounter	: NATURAL range 0 to 16 := 16; -- counter of the 16 bits and the synchronization impulse (17 impulses)
	signal data_temp	: STD_LOGIC_VECTOR(15 downto 0); -- data to be sent = control & data
	signal clkdiv		: STD_LOGIC; -- the DA converter works at frequencies lower than 30 MHz (the design uses a 25 MHz clock)

begin

	-- This process generates the 25 MHz clock needed for DAC operation.
	clock_divider: process (clk)
	begin
		if rising_edge(clk) then
			clkdiv <= not clkdiv;
		end if;
	end process;


	-- This process composes the new data to be sent (data doesn't change during the sending cycle)
	data_reader: process (clkdiv)
	begin
		if rising_edge(clkdiv) then
			if (bitCounter = 16) then			-- Before the beginning of a cycle
				data_temp <= control & data;	-- the word to be sent is configured.
			end if;
		end if;
	end process;


	-- This process generates the counter values according to which the 16 bits of data and the sync impulse are sent.
	counter: process (clkdiv)
	begin
		if rising_edge(clkdiv) then
			if (bitCounter > 0) then
				bitCounter <= bitCounter - 1;
			else
				bitCounter <= 16;
			end if;
		end if;
	end process;


	sclk <= clkdiv; -- The DAC serial clock = 25 MHz (< 30 MHz)
	sync <= '1' when (bitCounter = 16) else '0'; -- The synchronization impulse sent when bitCounter = 16 (16 bits of data have already been sent)
	sdata <= data_temp(bitCounter) when (bitCounter < 16) else '0'; -- The serial data sent when bitCounter < 16

end Behavioral;