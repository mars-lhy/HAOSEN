------------------------------------------------------------------------
--	ReverbAdder.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This component adds eight 8-bit values and outputs the result divided by 4.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ReverbAdder is
	port (
		a5, a10, a20, a30, a45, a60, a75, a100: in std_logic_vector(7 downto 0);
		sum: out std_logic_vector(7 downto 0)
	);
end ReverbAdder;

architecture Behavioral of ReverbAdder is

	signal b5, b10, b20, b30, b45, b60, b75, b100, sum_temp: std_logic_vector(10 downto 0);

begin

	b5 <= "000" & a5;
	b10 <= "000" & a10;
	b20 <= "000" & a20;
	b30 <= "000" & a30;
	b45 <= "000" & a45;
	b60 <= "000" & a60;
	b75 <= "000" & a75;
	b100 <= "000" & a100;
	
	sum_temp <= b5 + b10 + b20 + b30 + b45 + b60 + b75 + b100;
	
	-- Adding 8 values could result in a value 8 times bigger, that could need 3 bits more.
	-- By ignoring the last 2 bits and considering only bits 9:2, we have a division by 4.
	-- Although a division by 8 would have been appropriate,
	-- the result of a division by 4 is better sounding for the reverb effect.
	sum <= sum_temp(9 downto 2);

end Behavioral;