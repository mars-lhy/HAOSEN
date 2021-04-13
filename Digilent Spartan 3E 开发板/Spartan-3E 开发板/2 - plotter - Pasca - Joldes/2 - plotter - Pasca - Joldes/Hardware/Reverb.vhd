------------------------------------------------------------------------
--	Reverb.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module generates data with different delays.
--	Data with different delays are stored in different registers. Reading
--	is done when the memory is not being written (which happens with a
--	frequency of 48 kHz). The values of the registers are added together,
--	and they result is the effect unit output.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reverb is
	port (
		clk					: in STD_LOGIC; -- Master clock (50 MHz)
		decayType			: in STD_LOGIC; -- Decay type: none - 0, exponential - 1
		readAddressOffset	: out STD_LOGIC_VECTOR(13 downto 0); -- The address where to read data in the circular buffer
		dataIn				: in STD_LOGIC_VECTOR(7 downto 0); -- Input data
		dataOutWet			: out STD_LOGIC_VECTOR(7 downto 0) -- Output data
	);
end Reverb;

architecture Behavioral of Reverb is

	component Multiplier8 is
		port (
			a	: in STD_LOGIC_VECTOR(7 downto 0);
			b	: in STD_LOGIC_VECTOR(7 downto 0);
			p	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component ReverbAdder is
		port (
			a5, a10, a20, a30, a45, a60, a75, a100: in STD_LOGIC_VECTOR(7 downto 0);
			sum: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	type addressMemory is array(0 to 7) of STD_LOGIC_VECTOR(13 downto 0);
	constant delayAddress: addressMemory := (
		"00000011111010", -- 5
		"00000111110100", -- 10
		"00001111101000", -- 20
		"00010111011100", -- 30
		"00100011001010", -- 45
		"00101110111000", -- 60
		"00111010100110", -- 75
		"01001110001000"  -- 100
	);
	
	signal counter: NATURAL range 0 to 7;
	signal delay5, delay10, delay20, delay30, delay45, delay60, delay75, delay100: STD_LOGIC_VECTOR(7 downto 0);
	signal factor, product: STD_LOGIC_VECTOR(7 downto 0);
	
begin

	-- The 'reverb' effect is obtained by adding to the original data delayed data by certain amounts.
	-- The delays are: 5, 10, 20, 30, 45, 60, 75, 100 ms.
	-- The delayed data can be attenuated over time, so it can be multiplied with factors
	-- that correspond to a exponential decay .

	Multiplier_Map: Multiplier8 port map (
		a => dataIn,
		b => factor,
		p => product
	);
	
	-- THIS COMPONENT ADDS THE DELAYED DATA
	ReverbAdder_Map: ReverbAdder port map (
		delay5, delay10, delay20, delay30, delay45, delay60, delay75, delay100, dataOutWet
	);
	
	-- THIS PROCESS GENERATES THE INDEX OF THE ADDRESS THAT CORRESPONDS TO A SPECIFIC DELAY
	process (clk)
	begin
		if rising_edge(clk) then
			counter <= counter + 1;
		end if;
	end process;

	readAddressOffset <= delayAddress(counter); -- the address is retrieved from the address memory
	
	
	-- THIS PROCESS STORES THE READ VALUES IN THEIR RESPECTIVE REGISTERS
	process (clk)
	begin
		if rising_edge(clk) then
			if (counter = 0) then
				if (decayType = '0') then
					delay5 <= dataIn;
				else
					delay5 <= product;
				end if;
			end if;

			if (counter = 1) then
				if (decayType = '0') then
					delay10 <= dataIn;
				else
					delay10 <= product;
				end if;
			end if;

			if (counter = 2) then
				if (decayType = '0') then
					delay20 <= dataIn;
				else
					delay20 <= product;
				end if;
			end if;

			if (counter = 3) then
				if (decayType = '0') then
					delay30 <= dataIn;
				else
					delay30 <= product;
				end if;
			end if;

			if (counter = 4) then
				if (decayType = '0') then
					delay45 <= dataIn;
				else
					delay45 <= product;
				end if;
			end if;

			if (counter = 5) then
				if (decayType = '0') then
					delay60 <= dataIn;
				else
					delay60 <= product;
				end if;
			end if;

			if (counter = 6) then
				if (decayType = '0') then
					delay75 <= dataIn;
				else
					delay75 <= product;
				end if;
			end if;

			if (counter = 7) then
				if (decayType = '0') then
					delay100 <= dataIn;
				else
					delay100 <= product;
				end if;
			end if;
		end if;
	end process;
	
	-- No decay means original data or multiplying by 1.
	-- Exponential delay means multiplying by (1 - factor)
	-- These are the factors for exponential decay:
	factor <=
		x"E6" when counter = 0 else -- counter = 0 => delay = 5 ms => decay = 1 - E6h / FFh
		x"D2" when counter = 1 else
		x"AF" when counter = 2 else
		x"96" when counter = 3 else
		x"6E" when counter = 4 else
		x"5F" when counter = 5 else
		x"5A" when counter = 6 else
		x"55"; -- counter = 7 => delay = 100 ms => decay = 1 - 55h / FFh
	
end Behavioral;