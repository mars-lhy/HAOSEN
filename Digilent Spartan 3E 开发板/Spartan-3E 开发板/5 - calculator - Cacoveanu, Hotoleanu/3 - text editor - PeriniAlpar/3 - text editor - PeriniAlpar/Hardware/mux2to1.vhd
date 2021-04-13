
------------------------------------------------------------------------

------------------------------------------------------------------------
--     Mux2to1.vhd -- Implements a generic N bit 2 to 1 multiplexer
------------------------------------------------------------------------
-- Author:  Perini Alpar
--          Technical University of Cluj-Napoca, Computer Science
------------------------------------------------------------------------
--		Inputs:
--			N		: Width of the input data
--			A		: First N bit input
--			B		: Second N bit input
--			Sel	: 1 bit selection signal
--		Outputs:
--			O		: Multiplexed output data
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2to1 is
   generic ( N : integer := 12);
	port (a,b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		  );
end mux2to1;

architecture Behavioral of mux2to1 is

begin

	o <= a when sel='0' else b;

end Behavioral;