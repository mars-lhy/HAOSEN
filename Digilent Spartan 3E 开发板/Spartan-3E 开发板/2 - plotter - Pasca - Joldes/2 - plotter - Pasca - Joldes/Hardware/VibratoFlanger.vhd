------------------------------------------------------------------------
--	VibratoFlanger.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This component generates data with modulated delay. The
--	shape of the modulation can be sinusoidal or triangular.
--	The delay modulation consists of generating addresses with values
--	between 0 and 255 using either the sine values or the addresses
--	for the sine memory, and reading the data from the circular buffer.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VibratoFlanger is
	port (
		clk					: in STD_LOGIC; -- Master clock (50 MHz)
		modulationType		: in STD_LOGIC; -- Modulation type: sinusoidal or triangular
		maximumDelay		: in STD_LOGIC_VECTOR(1 downto 0); -- The maximum amplitude of the modulation
		modulationRate		: in STD_LOGIC_VECTOR(1 downto 0); -- The modulation rate
		readAddressOffset	: out STD_LOGIC_VECTOR(13 downto 0); -- The address where to read data in the circular buffer
		dataIn				: in STD_LOGIC_VECTOR(7 downto 0); -- Input data
		dataOutWet			: out STD_LOGIC_VECTOR(7 downto 0) -- Output data
	);
end VibratoFlanger;

architecture Behavioral of VibratoFlanger is

	-- This component generates the sine values used for the modulation.
	component SineMemory is
		port (
			clk		: in STD_LOGIC;
			en			: in STD_LOGIC;
			address	: in STD_LOGIC_VECTOR(7 downto 0);
			dataOut	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	signal periodValue, counter				: NATURAL;
	signal countDirection						: STD_LOGIC;
	signal sinusAngle, sinusResult			: STD_LOGIC_VECTOR(7 downto 0);
	signal address_temp							: STD_LOGIC_VECTOR(7 downto 0);
	signal sinusAddress, triangleAddress	: STD_LOGIC_VECTOR(7 downto 0);

begin

	-- The 'vibrato' effect and the 'flanger' effect are generated in the same manner,
	--	the difference is that the result of the vibrato is only the processed data
	-- and the result of the flanger is the sum of the processed and original data.
	-- The effects are obtaind by reading delayed data at an address that varies in time.
	-- The variation can have a sinusoidal or triangular shape, and a certain modulation rate (1, 4, 8 or 16 Hz).

	SineMemory_Map: SineMemory port map (
		clk => clk,
		en => '1',
		address => sinusAngle,
		dataOut => sinusResult
	);

	periodValue <=
		195312 when (modulationRate = "00") else -- 1 Hz
		48828 when (modulationRate = "01") else -- 4 Hz
		24414 when (modulationRate = "10") else -- 8 Hz
		12207; -- 16 Hz


	-- This process generates the address where to read data in the circular buffer.
	process (clk)
	begin
		if rising_edge(clk) then
			if (counter < periodValue) then
				counter <= counter + 1;
			else
				counter <= 0;
				if (countDirection = '1') then
					sinusAngle <= sinusAngle + 1;
				else
					sinusAngle <= sinusAngle - 1;
				end if;
			end if;
		end if;
	end process;


	-- This process allows the counter to count up or down, in order to obtain
	-- the triangular shape of the modulation and the periodic shape of the sine.
	process (clk)
	begin
		if rising_edge(clk) then
			if (sinusAngle = x"00") then
				countDirection <= '1';
			elsif (sinusAngle = x"FF") then
				countDirection <= '0';
			end if;
		end if;
	end process;


	sinusAddress <= sinusResult;
	triangleAddress <= sinusAngle;
	
	address_temp <= sinusAddress when modulationType = '0' else triangleAddress;

	-- Sinusoidal or triangular addresses have values between 0 and 255.
	-- The delay between two consecutive addresses is 20 us; this means
	-- that 255 corresponds to a delay of 5 ms.
	--	A sine or triangle shape multiplied by 2 (address_temp & "0")
	-- has values between 0 and 512 => 10 ms delay; for the 20 ms delay
	-- the multiplication factor is 4 (address_temp & "00").
	readAddressOffset <=
		"000000" & address_temp      when (maximumDelay = "00") else -- 5 ms
		"00000" & address_temp & "0" when (maximumDelay = "01") else -- 10 ms
		"0000" & address_temp & "00"; -- 20 ms

	dataOutWet <= dataIn;
		
end Behavioral;