------------------------------------------------------------------------
--	KeyboardStatusGenerator.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module keeps track of the 17 keys by using a 17-bit register. If a bit
--	has the value '0', then that key is not pressed; otherwise, it is pressed.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KeyboardStatusGenerator is
	port (
		clk				: in STD_LOGIC; -- Master clock (50 MHz)
		rst				: in STD_LOGIC; -- Reset button (synchronous reset)
		pressedKey		: in STD_LOGIC_VECTOR(7 downto 0); -- The code of pressed keys
		releasedKey		: in STD_LOGIC_VECTOR(7 downto 0); -- The code of released keys
		keyStatus		: out STD_LOGIC_VECTOR(16 downto 0) -- The register that holds the status of the keys (pressed or not pressed)
	);
end KeyboardStatusGenerator;

architecture Behavioral of KeyboardStatusGenerator is

	signal keyStatus_temp: STD_LOGIC_VECTOR(16 downto 0); -- Temporary register that holds the status of the keys
	
begin

	-- This process sets or clears the bits of the status register, according to the values
	-- of 'pressedkey' and 'releasedkey' input signals. A pressed key determines setting
	-- the corresponding bit, and a released key determines resetting the corresponding bit.
	determine_status: process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				keyStatus_temp <= (others => '0'); -- On reset, the register is cleared (no keys are pressed).
			else
				case (releasedKey) is -- compare the code of the last released key with those of the 17 keys
					when x"15" => keyStatus_temp(0) <= '0';	-- C4
					when x"1E" => keyStatus_temp(1) <= '0';	-- C#4
					when x"1D" => keyStatus_temp(2) <= '0';	-- D4
					when x"26" => keyStatus_temp(3) <= '0';	-- D#4
					when x"24" => keyStatus_temp(4) <= '0';	-- E4
					when x"2D" => keyStatus_temp(5) <= '0';	-- F4
					when x"2E" => keyStatus_temp(6) <= '0';	-- F#4
					when x"2C" => keyStatus_temp(7) <= '0';	-- G4
					when x"36" => keyStatus_temp(8) <= '0';	-- G#4
					when x"35" => keyStatus_temp(9) <= '0';	-- A4
					when x"3D" => keyStatus_temp(10) <= '0';	-- A#4
					when x"3C" => keyStatus_temp(11) <= '0';	-- B4
					when x"43" => keyStatus_temp(12) <= '0';	-- C5
					when x"46" => keyStatus_temp(13) <= '0';	-- C#5
					when x"44" => keyStatus_temp(14) <= '0';	-- D5
					when x"45" => keyStatus_temp(15) <= '0';	-- D#5
					when x"4D" => keyStatus_temp(16) <= '0';	-- E5
					when others =>
				end case;

				case (pressedKey) is -- compare the code of the last pressed key with those of the 17 keys
					when x"15" => keyStatus_temp(0) <= '1';	-- C4
					when x"1E" => keyStatus_temp(1) <= '1';	-- C#4
					when x"1D" => keyStatus_temp(2) <= '1';	-- D4
					when x"26" => keyStatus_temp(3) <= '1';	-- D#4
					when x"24" => keyStatus_temp(4) <= '1';	-- E4
					when x"2D" => keyStatus_temp(5) <= '1';	-- F4
					when x"2E" => keyStatus_temp(6) <= '1';	-- F#4
					when x"2C" => keyStatus_temp(7) <= '1';	-- G4
					when x"36" => keyStatus_temp(8) <= '1';	-- G#4
					when x"35" => keyStatus_temp(9) <= '1';	-- A44
					when x"3D" => keyStatus_temp(10) <= '1';	-- A#4
					when x"3C" => keyStatus_temp(11) <= '1';	-- B4
					when x"43" => keyStatus_temp(12) <= '1';	-- C5
					when x"46" => keyStatus_temp(13) <= '1';	-- C#5
					when x"44" => keyStatus_temp(14) <= '1';	-- D5
					when x"45" => keyStatus_temp(15) <= '1';	-- D#5
					when x"4D" => keyStatus_temp(16) <= '1';	-- E5
					when others =>
				end case;
			end if;
		end if;
	end process;
	

	keyStatus <= keyStatus_temp; -- 'keyStatus' outputs the status of the keys

end Behavioral;