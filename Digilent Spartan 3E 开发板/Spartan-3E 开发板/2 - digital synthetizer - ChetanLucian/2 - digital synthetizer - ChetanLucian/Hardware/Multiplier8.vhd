------------------------------------------------------------------------
--	Multiplier8.vhd
------------------------------------------------------------------------
--	Author:	Digilent
--				Lucian Chetan (modified state machine)
------------------------------------------------------------------------
--	Software version:	Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module uses the multiplier embedded in the Spartan 3 FPGA chip.
--	It takes two 8-bit values as inputs, and the 16-bit result is divided
--	by 256 (by ignoring the last eight bits).
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplier8 is
	port (
		a	: in STD_LOGIC_VECTOR(7 downto 0); -- First operand
		b	: in STD_LOGIC_VECTOR(7 downto 0); -- Second operand 
		p	: out STD_LOGIC_VECTOR(7 downto 0) -- Product p = a * b / 256
	);
end Multiplier8;

architecture Behavioral of Multiplier8 is
	
	component MULT18x18 is
		port (
			a	: in std_logic_vector(17 downto 0);
			b	: in std_logic_vector(17 downto 0);
			p	: out std_logic_vector(35 downto 0)
		);
	end component;
	
	signal a_temp, b_temp: STD_LOGIC_VECTOR(17 downto 0);

begin

	-- The multiplier has the 8-bit values as inputs. The result is a 16-bit value.
	-- By ignoring the last 8 bits, we have a multiplication of those values by coefficients = [0, 1).
	OnBoardMultiplier_Map: MULT18x18 port map (
		a => a_temp,
		b => b_temp,
		p(35 downto 16) => open,
		p(15 downto 8) => p,
		p(7 downto 0) => open
	);

	a_temp <= "0000000000" & a;
	b_temp <= "0000000000" & b;

end Behavioral;