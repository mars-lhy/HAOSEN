------------------------------------------------------------------------
--	EffectsUnit.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module groups the effect units (Reverb, Delay + Echo, Vibrato + Flanger)
--	and the "Feedback" and "Mix" components.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EffectsUnit is
	port (
		clk				: in STD_LOGIC; -- Master clock (50 MHz)
		effectSelect	: in STD_LOGIC_VECTOR(1 downto 0); -- Selects the effect (reverb, flanger + vibrato, delay + echo)
		parameter		: in STD_LOGIC_VECTOR(7 downto 0); -- bits 7:6 = delayTime (DelayEcho); bit 5:1 effectType, maximumDelay, modulationRate (VibratoFlange); bit 0 = decayType (Reverb)
		feedbackAmount	: in STD_LOGIC_VECTOR(7 downto 0); -- The amount of feedback to be reinserted in the system
		wetAmount		: in STD_LOGIC_VECTOR(7 downto 0); -- The amount of processed data to be output
		dryAmount		: in STD_LOGIC_VECTOR(7 downto 0); -- The amount of original data to be output
		originalData	: in STD_LOGIC_VECTOR(7 downto 0); -- The original data
		processedData	: out STD_LOGIC_VECTOR(7 downto 0) -- The processed data
	);
end EffectsUnit;

architecture Behavioral of EffectsUnit is

	-- This component is the "Delay + Echo" effect unit.
	component DelayEcho is
		port (
			delayTime			: in STD_LOGIC_VECTOR(1 downto 0);
			readAddressOffset	: out STD_LOGIC_VECTOR(13 downto 0);
			dataIn				: in STD_LOGIC_VECTOR(7 downto 0);
			dataOutWet			: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	-- This component is the "Vibrato + Flanger" effect unit.
	component VibratoFlanger is
		port (
			clk					: in STD_LOGIC;
			modulationType		: in STD_LOGIC;
			maximumDelay		: in STD_LOGIC_VECTOR(1 downto 0);
			modulationRate		: in STD_LOGIC_VECTOR(1 downto 0);
			readAddressOffset	: out STD_LOGIC_VECTOR(13 downto 0);
			dataIn				: in STD_LOGIC_VECTOR(7 downto 0);
			dataOutWet			: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	-- This component is the "Reverb" effect uniu.
	component Reverb is
		port (
			clk					: in STD_LOGIC;
			decayType			: in STD_LOGIC;
			readAddressOffset	: out STD_LOGIC_VECTOR(13 downto 0);
			dataIn				: in STD_LOGIC_VECTOR(7 downto 0);
			dataOutWet			: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	-- This component represents the circular buffer used by all effects.
	component CircularBuffer is
		port (
			clk					: in STD_LOGIC;
			readAddressOffset	: in STD_LOGIC_VECTOR(13 downto 0);
			dataIn				: in STD_LOGIC_VECTOR(7 downto 0);
			dataOut				: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	-- This component mixed processed data with original data, before being reinserted into the circular buffer.
	component Feedback is
		port (
			feedbackAmount	: in STD_LOGIC_VECTOR(7 downto 0);
			input				: in STD_LOGIC_VECTOR(7 downto 0);
			output			: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	-- This component mixes the original data with the processed data. The result is sent to the DA converter.
	component Mix is
		port (
			wetData		: in STD_LOGIC_VECTOR(7 downto 0);
			dryData		: in STD_LOGIC_VECTOR(7 downto 0);
			wetAmount	: in STD_LOGIC_VECTOR(7 downto 0);
			dryAmount	: in STD_LOGIC_VECTOR(7 downto 0);
			mixedData	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	signal readAddressOffset	: STD_LOGIC_VECTOR(13 downto 0);
	signal readAddressOffsetDE	: STD_LOGIC_VECTOR(13 downto 0);
	signal readAddressOffsetVF	: STD_LOGIC_VECTOR(13 downto 0);
	signal readAddressOffsetR	: STD_LOGIC_VECTOR(13 downto 0);
	signal bufferInput			: STD_LOGIC_VECTOR(7 downto 0);
	signal bufferOutput			: STD_LOGIC_VECTOR(7 downto 0);
	signal feedbackOutput		: STD_LOGIC_VECTOR(7 downto 0);
	signal dataInDE				: STD_LOGIC_VECTOR(7 downto 0);
	signal dataInVF				: STD_LOGIC_VECTOR(7 downto 0);
	signal dataInR					: STD_LOGIC_VECTOR(7 downto 0);
	signal dataWet					: STD_LOGIC_VECTOR(7 downto 0);
	signal dataWetDE				: STD_LOGIC_VECTOR(7 downto 0);
	signal dataWetVF				: STD_LOGIC_VECTOR(7 downto 0);
	signal dataWetR				: STD_LOGIC_VECTOR(7 downto 0);

begin

	DelayEcho_Map: DelayEcho port map (
		delayTime => parameter(7 downto 6),
		readAddressOffset => readAddressOffsetDE,
		dataIn => dataInDE,
		dataOutWet => dataWetDE
	);

	VibratoFlanger_Map: VibratoFlanger port map (
		clk => clk,
		modulationType => parameter(5),
		maximumDelay => parameter(4 downto 3),
		modulationRate => parameter(2 downto 1),
		readAddressOffset => readAddressOffsetVF,
		dataIn => dataInVF,
		dataOutWet => dataWetVF
	);
	
	Reverb_map: Reverb port map (
		clk => clk,
		decayType => parameter(0),
		readAddressOffset => readAddressOffsetR,
		dataIn => dataInR,
		dataOutWet => dataWetR
	);
	
	CircularBuffer_Map: CircularBuffer port map (
		clk => clk,
		readAddressOffset => readAddressOffset,
		dataIn => bufferInput,
		dataOut => bufferOutput
	);
	
	Feedback_Map: Feedback port map (
		feedbackAmount => feedbackAmount,
		input => dataWet,
		output => feedbackOutput
	);
	
	Mix_Map: Mix port map (
		wetData => dataWet,
		dryData => originalData,
		wetAmount => wetAmount,
		dryAmount => dryAmount,
		mixedData => processedData
	);
	
	bufferInput <= originalData + feedbackOutput;
	
	-- Data is selected using the "effectSelect" input signal.
	
	readAddressOffset <=
		readAddressOffsetDE when (effectSelect = "01") else
		readAddressOffsetVF when (effectSelect = "10") else
		readAddressOffsetR when (effectSelect = "11") else
		"00000000000000"; -- "effectSelect" = "00"
		
	dataWet <=
		dataWetDE when (effectSelect = "01") else
		dataWetVF when (effectSelect = "10") else
		dataWetR when (effectSelect = "11") else
		"00000000";
		
	dataInDE <= bufferOutput when (effectSelect = "01") else x"00";
	dataInVF <= bufferOutput when (effectSelect = "10") else x"00";
	dataInR <= bufferOutput when (effectSelect = "11") else x"00";

end Behavioral;