------------------------------------------------------------------------
--	KeyboardScanner.vhd
------------------------------------------------------------------------
--	Author:	Unknown (PS/2 clock filtering, keyboard scanning)
--				Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module reads the serial data that the keyboard sends. When a scan code
--	is completely received, based on its type, it is stored in one of the two
--	registers that help keeping track of the 17 keys.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KeyboardScanner is
	port (
		clk			: in STD_LOGIC; -- Master clock (50 MHz)
		rst			: in STD_LOGIC; -- Reset button (synchronous reset)
		kc				: in STD_LOGIC; -- PS/2 keyboard clock signal
		kd				: in STD_LOGIC; -- PS/2 keyboard data signal
		pressedKey	: out STD_LOGIC_VECTOR(7 downto 0); -- The scan code of the last pressed key
		releasedKey	: out STD_LOGIC_VECTOR(7 downto 0) -- The scan code of the last released key
	);
end KeyboardScanner;

architecture Behavioral of KeyboardScanner is

	signal clk25mhz			: STD_LOGIC; -- Divided clock (25 MHz)
	signal scanComplete		: STD_LOGIC; -- Flag that signals the fact that 8 bits have been read
	signal kc_filtered		: STD_LOGIC; -- Filtered clock of the keyboard
	signal readFlag			: STD_LOGIC; -- Flag for allowing reading
	signal bitCounter			: STD_LOGIC_VECTOR(3 downto 0); -- Counter used for counting the incoming bits
	signal filter				: STD_LOGIC_VECTOR(7 downto 0); -- Register used for filtering the keyboard clock
	signal scancode			: STD_LOGIC_VECTOR(7 downto 0); -- Register used for storing the scan code read from the keyboard
	signal pressedKey_temp	: STD_LOGIC_VECTOR(7 downto 0); -- Temporary register used for storing make codes
	signal releasedKey_temp	: STD_LOGIC_VECTOR(7 downto 0); -- Temporary register used for storing break codes
	signal shiftRegister		: STD_LOGIC_VECTOR(8 downto 0); -- Register used during serial reading

	type states is (readPressed, readReleased); -- States used for the state machine that handles the scan codes
	signal currentState, nextState: states;

begin

	-- This process generates the 25 MHz clock used for keyboard operation.
	clock_divider:	process (clk)
	begin
		if rising_edge(clk) then
			clk25mhz <= not clk25mhz;
		end if;
	end process;


	-- This process filters the keyboard clock. It eliminates "bouncing" of the raw signal,
	-- which may be caused by a bad physical connection between the keyboard and the FPGA board.
	clock_filter: process (clk25mhz)
	begin
		if rising_edge(clk25mhz) then
			filter(6 downto 0) <= filter(7 downto 1);
			filter(7) <= kc;
			if (filter = "11111111") then					-- 'kc_filtered' goes high when the 'filter' register contains only ones
				kc_filtered <= '1';							-- 'kc_filtered' goes low when the 'filter' register contains only zeros (a stable signal)
			elsif (filter = "00000000") then				-- 'kc_filtered' keeps its previous value when the 'filter' register contains a combination of ones and zeros
				kc_filtered <= '0';
			end if;
		end if;
	end process;


	-- This process reads the serial information coming from the keyboard (on the data line)
	-- and it assembles the scan code corresponding to the pressed or released key
	keyboard_scanner: process (kc_filtered)
	begin
		if rising_edge(kc_filtered) then
			if (rst = '1') then
				bitCounter <= "0000";						-- On reset the 'bitCounter' used for receiving the serial data from the keyboard
				readFlag <= '0';								-- and the 'readFlag' signal useed for signaling the receiving of a scan code - are cleaed
			elsif (kd = '0' and readFlag = '0') then
				readFlag <= '1';								-- The 'readFlag' is set to '1' - the incoming scan scancode can now be read
				scanComplete <= '0';							-- The 'scanComplete' flag is set to '0' (this flag is used to signal the fact that the whole scan code is received)
			else
				if (readFlag = '1') then
					if (bitCounter < "1001") then			-- If the scan code hasn't all been read
						bitCounter <= bitCounter + 1;		-- increment the 'bitCounter',
						shiftRegister(7 downto 0) <= shiftRegister(8 downto 1); -- make room for the next bit,
						shiftRegister(8) <= kd;				-- store that bit,
						scanComplete <= '0';					-- signal the fact that reading isn't finished.
					else											-- If 8 bits have been received
						scancode <= shiftRegister(7 downto 0); -- store the byte in the 'scancode' register,
						readFlag <= '0';						-- disable reading,
						scanComplete <= '1';					-- signal the fact that reading is finished,
						bitCounter <= "0000";				-- reset the counter.
					end if;
				end if;
			end if;
		end if;
	end process;


	-- This process sends the scan codes to their respective registers.
	-- Make codes go to the "pressedKey" register and break codes go to the "releasedKey" register.
	-- Note. The typematic keyboard issues repeat codes while a key is pressed and held, which
	-- are identical to the make codes, so storing them in the "pressedKey" register doesn't affect the process.
	scancode_state_machine: process (currentState, scancode, pressedKey_temp, releasedKey_temp)
	begin
		case (currentState) is
			when readPressed =>
				if (scancode /= x"F0") then	-- If the keyboard has issued a scan code different than 'F0'
					nextState <= readPressed;	-- the next state is 'readPressed', because the repeat code or a new make code is expected.
				else
					nextState <= readReleased;	-- If the code issued by the keyboard was 'F0', then a key was released, so the corresponding code needs to be read.
				end if;

			when readReleased =>					-- An 'F0' code has been issued.
				if (scancode = x"F0") then
					nextState <= readReleased; -- The code of the released key hasn't appeared yet, so the machine waits for it.
				else
					nextState <= readPressed;
				end if;

			when others =>
				nextState <= readPressed;
		end case;
	end process;


	-- This process works together with the state machine above and it assigns values
	-- to "pressedKey_temp" and "releasedKey_temp" temporary registers, according to the current state.
	scancode_assignment: process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then												-- On reset, clear the contents of the two registers.
				pressedKey_temp <= x"00";
				releasedKey_temp <= x"00";
			else
				if (currentState = readPressed) then
					if (scancode /= x"F0") then							-- If the keyboard has issued a scan code different than 'F0'
						pressedKey_temp <= scancode;						-- then the make code of a newly pressed key or the repeat code of a currently pressed key is stored.
						if (pressedKey_temp = releasedKey_temp) then	-- When the same key is pressed twice (a key that has been previously released is now pressed again)
							releasedKey_temp <= x"00";						-- the 'releasedKey_temp' temporary register must be cleared. (A key can't be pressed and released at the same time.)
						end if;
					end if;
				else
					if (scancode /= x"F0") then
						releasedKey_temp <= scancode;						-- The expected rest of the break code has appeared, so it will be stored in the corresponding temporary register.
						if (releasedKey_temp = pressedKey_temp) then
							pressedKey_temp <= x"00";						-- When a key is released, the 'pressedKey_temp' temporary register that stored its value must be cleared.
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;


	pressedKey <= pressedKey_temp; -- 'pressedKey' outputs the code of a pressed key
	releasedKey <= releasedKey_temp; -- 'releasedKey' outputs the code of a released key


	-- This process handles the transition between states only when a complete scan code has been received.
	state_transition: process (scanComplete)
	begin
		if rising_edge(scanComplete) then	-- The "scanComplete" signal triggers state transition.
			if (rst = '1') then
				currentState <= readPressed;	-- "readPressed" is the default state.
			else
				currentState <= nextState;
			end if;
		end if;
	end process;

end Behavioral;