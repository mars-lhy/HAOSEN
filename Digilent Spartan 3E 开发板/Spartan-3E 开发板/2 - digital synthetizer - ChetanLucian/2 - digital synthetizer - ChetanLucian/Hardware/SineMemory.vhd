------------------------------------------------------------------------
--	SinusMemory.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module contains a 256 x 8-bit memory that contains sine values for
--	angles between -90 and 90 degrees.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SineMemory is
	port (
		clk		: in STD_LOGIC; -- Master clock (50 MHz)
		en			: in STD_LOGIC; -- Enable signal
		address	: in STD_LOGIC_VECTOR(7 downto 0); -- Address
		dataOut	: out STD_LOGIC_VECTOR(7 downto 0) -- Data
	);
end SineMemory;

architecture Behavioral of SineMemory is

	type sinArray is array(0 to 255) of NATURAL range 0 to 255;
	constant sinus: sinArray := (
		0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3,
		3, 3, 4, 4, 4, 5, 5, 6, 6, 6, 7, 7, 8, 9, 9, 10,
		10, 11, 11, 12, 13, 13, 14, 15, 16, 16, 17, 18, 19, 20, 20, 21,
		22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
		38, 39, 40, 41, 43, 44, 45, 46, 47, 49, 50, 51, 52, 54, 55, 56,
		57, 59, 60, 61, 63, 64, 65, 67, 68, 70, 71, 72, 74, 75, 77, 78,
		80, 81, 82, 84, 85, 87, 88, 90, 91, 93, 94, 96, 97, 99, 100, 102,
		104, 105, 107, 108, 110, 111, 113, 114, 116, 118, 119, 121, 122, 124, 125, 127,
		128, 129, 131, 132, 134, 135, 137, 138, 140, 142, 143, 145, 146, 148, 149, 151,
		152, 154, 156, 157, 159, 160, 162, 163, 165, 166, 168, 169, 171, 172, 174, 175,
		176, 178, 179, 181, 182, 184, 185, 186, 188, 189, 191, 192, 193, 195, 196, 197,
		199, 200, 201, 202, 204, 205, 206, 207, 209, 210, 211, 212, 213, 215, 216, 217,
		218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233,
		234, 235, 236, 236, 237, 238, 239, 240, 240, 241, 242, 243, 243, 244, 245, 245,
		246, 246, 247, 247, 248, 249, 249, 250, 250, 250, 251, 251, 252, 252, 252, 253,
		253, 253, 254, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
	);

begin

	process (clk)
	begin
		if rising_edge(clk) then
			if (en = '1') then
				dataOut <= conv_std_logic_vector(sinus(conv_integer(address)), 8);
			end if;
		end if;
	end process;
	
end Behavioral;