------------------------------------------------------------------------
--	EnveloperCounter.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module is used by the ADSR enveloping process. If generates the
--	modulator values for attack, decay and release phases of the process.
--	During attack, it counts up, durin decay and release it counts down.
--	During these phases it uses different periods. When the counting is
--	disabled, the module keeps its current value. When counting starts again,
--	the counter uses that value to start from.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EnveloperCounter is
	port (
		clk			: in STD_LOGIC; -- Master clock (50 MHz)
		start			: in STD_LOGIC; -- Start counting
		direction	: in STD_LOGIC; -- Direction of counting (0 = down, 1 = up)
		period		: in STD_LOGIC_VECTOR(20 downto 0); -- Period
		modulator	: out STD_LOGIC_VECTOR(7 downto 0) -- Resulting value
	);
end EnveloperCounter;

architecture Behavioral of EnveloperCounter is

	signal periodCounter		: STD_LOGIC_VECTOR(20 downto 0);
	signal modulator_temp	: STD_LOGIC_VECTOR(7 downto 0);

begin

	count: process (clk)
	begin
		if rising_edge(clk) then
			if (start = '1') then
				if (periodCounter < period) then
					periodCounter <= periodCounter + 1;
				else
					periodCounter <= (others => '0');
					if (direction = '1') then
						modulator_temp <= modulator_temp + 1;
					else
						modulator_temp <= modulator_temp - 1;
					end if;
				end if;
			end if;
		end if;
	end process;

	modulator <= modulator_temp;

end Behavioral;