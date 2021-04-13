------------------------------------------------------------------------
--	KeyboardUnit.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	The keyboard unit groups the modules that:
--		-	interface the PS/2 keyboard ("KeyboardScanner"),
--		-	keep track of the 17 keys ("KeyboardStatusGenerator"),
--		-	control the four polyphony slots ("PolyphonyArbitration").
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KeyboardUnit is
	port (
		clk		: in STD_LOGIC; -- Master clock (50 MHz)
		rst		: in STD_LOGIC; -- Reset button (synchronous reset)
		kc			: in STD_LOGIC; -- PS/2 keyboard clock signal
		kd			: in STD_LOGIC; -- PS/2 keyboard data signal
		kbNote0	: out STD_LOGIC_VECTOR(4 downto 0); -- The note of the first slot
		kbNote1	: out STD_LOGIC_VECTOR(4 downto 0); -- The note of the second slot
		kbNote2	: out STD_LOGIC_VECTOR(4 downto 0); -- The note of the third slot
		kbNote3	: out STD_LOGIC_VECTOR(4 downto 0); -- The note of the fourth slot
		kbStatus	: out STD_LOGIC_VECTOR(3 downto 0) -- The status of the four oscillators
	);
end KeyboardUnit;

architecture Behavioral of KeyboardUnit is

	-- This component reads the codes sent by the keyboard and
	-- outputs the code of the pressed key and the code of the released key.
	component KeyboardScanner is
		port (
			clk			: in STD_LOGIC;
			rst			: in STD_LOGIC;
			kc				: in STD_LOGIC;
			kd				: in STD_LOGIC;
			pressedKey	: out STD_LOGIC_VECTOR(7 downto 0);
			releasedKey	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	-- This component reads the codes of the pressed and released keys
	-- and configures a register that stores the status of those keys
	-- (pressed = '1', released = '0').
	component KeyboardStatusGenerator is
		port (
			clk			: in STD_LOGIC;
			rst			: in STD_LOGIC;
			pressedKey	: in STD_LOGIC_VECTOR(7 downto 0);
			releasedKey	: in STD_LOGIC_VECTOR(7 downto 0);
			keyStatus	: out STD_LOGIC_VECTOR(16 downto 0)
		);
	end component;

	-- This component handles the status of the 4 polyphony slots
	-- according to the status of the 17 keys.
	component PolyphonyArbitration is
		port (
			clk			: in STD_LOGIC;
			rst			: in STD_LOGIC;
			keyStatus	: in STD_LOGIC_VECTOR(16 downto 0);
			kbNote0		: out STD_LOGIC_VECTOR(4 downto 0);
			kbNote1		: out STD_LOGIC_VECTOR(4 downto 0);
			kbNote2		: out STD_LOGIC_VECTOR(4 downto 0);
			kbNote3		: out STD_LOGIC_VECTOR(4 downto 0);
			kbStatus		: out STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;

	signal pressedKey_temp	: STD_LOGIC_VECTOR(7 downto 0);
	signal releasedKey_temp	: STD_LOGIC_VECTOR(7 downto 0);
	signal keyStatus			: STD_LOGIC_VECTOR(16 downto 0);

begin

	KeyboardScanner_Map: KeyboardScanner port map (
		clk => clk,
		rst => rst,
		kc => kc,
		kd => kd,
		pressedKey => pressedKey_temp,
		releasedKey => releasedKey_temp
	);

	KeyboardStatusGenerator_Map: KeyboardStatusGenerator port map (
		clk => clk,
		rst => rst,
		pressedKey => pressedKey_temp,
		releasedKey => releasedKey_temp,
		keyStatus => keyStatus
	);

	PolyphonyArbitration_Map: PolyphonyArbitration port map (
		clk => clk,
		rst => rst,
		keyStatus => keyStatus,
		kbNote0 => kbNote0,
		kbNote1 => kbNote1,
		kbNote2 => kbNote2,
		kbNote3 => kbNote3,
		kbStatus => kbStatus
	);

end Behavioral;