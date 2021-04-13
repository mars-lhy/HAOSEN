------------------------------------------------------------------------
--	Multiplier16.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module uses the multiplier embedded in the Spartan 3 FPGA chip.
--	It takes two 8-bit values as inputs, and the result is a 16-bit value.
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplier16 is
	port (
		a	: in STD_LOGIC_VECTOR(7 downto 0); -- First operand
		b	: in STD_LOGIC_VECTOR(7 downto 0); -- Second operand
		p	: out STD_LOGIC_VECTOR(15 downto 0) -- Product p = a * b
	);
end Multiplier16;

architecture Behavioral of Multiplier16 is
	
	component MULT18x18 is
		port (
			a	: in std_logic_vector(17 downto 0);
			b	: in std_logic_vector(17 downto 0);
			p	: out std_logic_vector(35 downto 0)
		);
	end component;
	
	signal a_temp, b_temp: STD_LOGIC_VECTOR(17 downto 0);

begin

	OnBoardMultiplier_Map: MULT18x18 port map (
		a => a_temp,
		b => b_temp,
		p(35 downto 16) => open,
		p(15 downto 0) => p
	);


	a_temp <= "0000000000" & a; -- pad with zeros the 8-bit value
	b_temp <= "0000000000" & b;

end Behavioral;