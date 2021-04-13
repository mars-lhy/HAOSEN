----------------------------------------------------------------------------------
-- Create Date:    13:04:55 10/03/2006 
-- Module Name:    clockdivider - Behavioral 
-- Project Name:   calculatorgata
-- AUTHOR:         Cacoveanu Silviu 
-- Description:    This module generates a clock signal opsed to the one on the 
--                 board       
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clockdivider is
    Port ( clk : in  STD_LOGIC;
           res : in  STD_LOGIC;
           outclk : out  STD_LOGIC);
end clockdivider;

architecture Behavioral of clockdivider is

begin
	process (clk,res)
		variable t: std_logic;
	begin
		if res = '1' then
			t:= '0';
---------------------------------------------------------------------------------
--generates the oposed signal
---------------------------------------------------------------------------------
		elsif clk'event and clk = '1' then
			if t = '0' then t:='1';
			elsif t = '1' then t:= '0';
			end if;
		end if;
		outclk <= t;
	end process;

end Behavioral;

