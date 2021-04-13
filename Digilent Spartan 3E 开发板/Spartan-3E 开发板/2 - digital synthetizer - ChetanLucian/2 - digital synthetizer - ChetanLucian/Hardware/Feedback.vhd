------------------------------------------------------------------------
--	Feedback.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module generates the data that will be reinserted in the effect process.
--	It multiplies the incoming data with the feedback coefficient
--	(an 8-bit value) and the result is divided by 256. The result is equivalent
--	to a multiplication with a value between 0 and 1.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Feedback is
	port (
		feedbackAmount	: in STD_LOGIC_VECTOR(7 downto 0); -- The coefficient of feedback
		input				: in STD_LOGIC_VECTOR(7 downto 0); -- The feedback data
		output			: out STD_LOGIC_VECTOR(7 downto 0) -- The resulted feedback data
	);
end Feedback;

architecture Behavioral of Feedback is

	component Multiplier8 is
		port (
			a	: in STD_LOGIC_VECTOR(7 downto 0);
			b	: in STD_LOGIC_VECTOR(7 downto 0);
			p	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

begin

	-- Feedback is reinserted in the system loop after being multiplied by a user selected coefficient.
	FeedbackMultiplier_Map: Multiplier8 port map (input, feedbackAmount, output);
	
end Behavioral;