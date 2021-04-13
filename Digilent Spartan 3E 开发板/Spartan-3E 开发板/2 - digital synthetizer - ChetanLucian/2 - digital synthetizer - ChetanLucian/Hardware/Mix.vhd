------------------------------------------------------------------------
--	Mix.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module mixes the original data multiplied by the dry coefficient
--	with the processed data multiplied by the wet coefficient.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mix is
	port (
		wetData		: in STD_LOGIC_VECTOR(7 downto 0); -- The processed data
		dryData		: in STD_LOGIC_VECTOR(7 downto 0); -- The original data
		wetAmount	: in STD_LOGIC_VECTOR(7 downto 0); -- The processed data coefficient
		dryAmount	: in STD_LOGIC_VECTOR(7 downto 0); -- The original data coefficient
		mixedData	: out STD_LOGIC_VECTOR(7 downto 0) -- The result
	);
end Mix;

architecture Behavioral of Mix is

	component Multiplier8 is
		port (
			a	: in STD_LOGIC_VECTOR(7 downto 0);
			b	: in STD_LOGIC_VECTOR(7 downto 0);
			p	: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	signal wet, dry: STD_LOGIC_VECTOR(7 downto 0);

begin

	-- mixed data = (wetData * wetCoeff) + (dryData * dryCoeff)
	-- Any of the coefficients can be 0.

	wetDataMultiplier_Map: Multiplier8 port map (wetData, wetAmount, wet);
	dryDataMultiplier_Map: Multiplier8 port map (dryData, dryAmount, dry);
	
	mixedData <= wet + dry;

end Behavioral;