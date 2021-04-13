------------------------------------------------------------------------
--	Enveloper.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module uses the ADSR (attack, decay, sustain, release) envelope
--	model to modulate the amplitude of the basic wave. It uses a bidirectional
--	counter that counts from 0 to 32 during the attack phase, from 32 to 16
--	during the decay phase, constant 16 during the sustain phase, and from 16
--	to 0 during release. The value of the counter represents the coefficient by
--	which the values of the basic wave are multiplied.
--	The attack and decay phases can be interrupted by the release phase, which,
--	in turn, can be interrupted by the attack phase of a newly pressed key.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Enveloper is
	port (
		clk					: in STD_LOGIC; -- Master clock (50 MHz)
		rst					: in STD_LOGIC; -- Reset button (synchronous reset)
		oscillatorStatus	: in STD_LOGIC; -- The status of the oscillator
		basicWave			: in STD_LOGIC_VECTOR(7 downto 0); -- The waveform to be modulated in amplitude
		envelopeIdle		: out STD_LOGIC; -- The status of the enveloper 
		modulatedWave		: out STD_LOGIC_VECTOR(15 downto 0) -- The wave modulated in amplitude
	);
end Enveloper;

architecture Behavioral of Enveloper is

	-- This component multiplies the basic wave by the ADSR coefficient (the modulator) and outputs the 16-bit result.
	component Multiplier16 is
		port (
			a	: in STD_LOGIC_VECTOR(7 downto 0);
			b	: in STD_LOGIC_VECTOR(7 downto 0);
			p	: out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;

	-- This component generates the value of the ADSR modulator.
	component EnveloperCounter is
		port (
			clk			: in STD_LOGIC;
			start			: in STD_LOGIC;
			direction	: in STD_LOGIC;
			period		: in STD_LOGIC_VECTOR(20 downto 0);
			modulator	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	type phases is (idle, attack, decay, sustain, release); -- The states of the state machine used for ADSR enveloping.
	signal currentPhase, nextPhase: phases;

	-- The attack phase requires 32 increments, which done with a certain period will last for 0.2 seconds.
	constant attackPeriod	: STD_LOGIC_VECTOR(20 downto 0) := "001001100010010110100"; -- x 32 = 0.2 seconds
	-- The decay phase requires 16 decrements, which done with a certain period will last for 0.4 seconds.
	constant	decayPeriod		: STD_LOGIC_VECTOR(20 downto 0) := "100110001001011010000"; -- x 16 = 0.4 seconds
	-- The release phase requires 16 decrements, which done with a certain period will last for aproximately 0.6 seconds.
	constant	releasePeriod	: STD_LOGIC_VECTOR(20 downto 0) := "111111111111111111111"; -- 0.671 seconds

	signal modulator			: STD_LOGIC_VECTOR(7 downto 0); -- The modulator by which the basic wave is multipled.
	signal start_temp			: STD_LOGIC; -- Signal that allows the ADSR counter to start counting.
	signal direction_temp	: STD_LOGIC; -- Signal that allows the ADSR counter to count up or down.
	signal period_temp		: STD_LOGIC_VECTOR(20 downto 0); -- The period that the ADSR counter uses (it is different for each ADSR phase).
	signal modulator_temp	: STD_LOGIC_VECTOR(7 downto 0);

begin

	Multiplier16_Map: Multiplier16 port map (
		a => basicWave,
		b => modulator,
		p => modulatedWave
	);

	EnveloperCounter_Map: EnveloperCounter port map (
		clk => clk,
		start => start_temp,
		direction => direction_temp,
		period => period_temp,
		modulator => modulator_temp
	);


	-- the ADSR counter doesn't count while the envelope process is idle or during the sustain phase (the modulator stay constant during this phase)
	start_temp <= '1' when (currentPhase = attack or currentPhase = decay or currentPhase = release) else '0';
	-- the ADSR counter counts up during attack, and douwn during decay and release.
	direction_temp <= '1' when (currentPhase = attack) else '0';
	period_temp <=
		attackPeriod when (currentPhase = attack) else
		decayPeriod when (currentPhase = decay) else
		releasePeriod;
	-- while idle, the modulator is 0, during sustain it remains constant (16), and during attack, decay and release the value is provided by the counter.
	modulator <=
		x"00" when (currentPhase = idle) else
		x"10" when (currentPhase = sustain) else
		modulator_temp;


	-- This process represents the state machine of the ADSR modulation.
	-- 'ADSR' = attack - decay - sustain - release
	-- During attack phase, the amplitude is increased from 0 to the highest reachable value (in this case, 32).
	-- During decay phase, the amplitude is gradually decreased from the highest value (32) to 16.
	-- During sustain phase, the amplitude remains the same.
	-- During relase phase, the amplitude is decreased from the sustain level to 0.
	--
	-- The attack phase starts when a key is pressed. The decay phase follows.
	--	The sustain phase lasts as long as the key is pressed.
	-- The release phase starts when the key is released. It can interrupt any of the phases (attack, decay, sustain).
	--          |32
	--         /|\
	--        / | \
	--       /  |  \
	--      /   |   \|16_ _ _ _ _16|
	--     /    |    |             |\
	--    /     |    |             | \
	--   /      |    |             |  \
	-- 0/A......D....S.............R...\0
	adsr_modulation: process (currentPhase, oscillatorStatus, modulator_temp)
	begin
		case (currentPhase) is
			when idle =>
				if (oscillatorStatus = '0') then
					nextPhase <= idle;
				else
					nextPhase <= attack; -- On key press, start the attack phase.
				end if;

			when attack =>
				if (oscillatorStatus = '0') then
					nextPhase <= release; -- On key release, start the release phase.
				elsif (modulator_temp < x"20") then
					nextPhase <= attack;
				else
					nextPhase <= decay; -- When at peak value (32), start the decay phase.
				end if;

			when decay =>
				if (oscillatorStatus = '0') then
					nextPhase <= release; -- On key release, start the release phase.
				elsif (modulator_temp > x"10") then
					nextPhase <= decay;
				else
					nextPhase <= sustain; -- When value = 16, start the sustain value.
				end if;

			when sustain =>
				if (oscillatorStatus = '0') then
					nextPhase <= release; -- Sustain until key released.
				else
					nextPhase <= sustain;
				end if;

			when release =>
				if (oscillatorStatus = '1') then
					nextPhase <= idle; -- On new key press, go to idle to start a new ADSR process.
				elsif (modulator_temp > x"00") then
					nextPhase <= release;
				else
					nextPhase <= idle; -- When value is 0, go idle.
				end if;
		end case;
	end process;


	envelopeIdle <= '1' when (currentPhase = idle) else '0'; -- This flag prevents the oscillator from changing period during an ADSR modulation.


	-- This process handles state transition.
	state_transition: process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				currentPhase <= idle; -- the default state
			else
				currentPhase <= nextPhase;
			end if;
		end if;
	end process;

end Behavioral;