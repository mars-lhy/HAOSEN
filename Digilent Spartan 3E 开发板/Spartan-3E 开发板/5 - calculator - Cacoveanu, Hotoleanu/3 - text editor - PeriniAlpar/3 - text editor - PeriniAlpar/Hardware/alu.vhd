
------------------------------------------------------------------------
-- ALU.vhd - Implements the Line*80+Col arithmetic operation efficienlty
------------------------------------------------------------------------
-- Author:  Perini Alpar
--          Technical University of Cluj-Napoca, Computer Science
------------------------------------------------------------------------
--		Inputs:
--			Line		: Line address
--			Col		: Column address
--		Outputs:
--			Res		: Memory address
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
	port (Line : in std_logic_vector(5 downto 0);
			Col : in std_logic_vector(6 downto 0);
			Res : out std_logic_vector(11 downto 0)
		  );
end alu;

architecture Behavioral of alu is

begin
	-- multiplication by 80 means *64 + *16 
	-- which means shift left by 6 and by 4
	Res <= (Line & "000000") + ("00" & Line & "0000") + Col when Line>0 
			 else ("00000" & Col);

end Behavioral;
