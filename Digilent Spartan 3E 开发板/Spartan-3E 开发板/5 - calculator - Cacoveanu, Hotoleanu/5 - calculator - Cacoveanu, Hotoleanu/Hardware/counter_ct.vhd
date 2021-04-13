----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    counter1 - arhcounter1
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a counter which counts descending, form 10 to 1
--                 The output of this module is used as the selection of the 
--                 multiplexer                
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--clk is the clock input, ce the clock enable input and reset, the reset input
--a is the output
--reached is the output which showes that the counter has reached the value 9
--this means that the process of multiplication has finished
----------------------------------------------------------------------------------
entity counter_ct is
	port (clk,ce,reset:in std_logic;
	a:out std_logic_vector(3 downto 0);
	reached:out std_logic);
end counter_ct;

architecture arhcounter_ct of counter_ct is
begin
	process(clk)				
	variable v:std_logic_vector(3 downto 0);
	begin
		if (clk'event) and (clk='1') and (ce='1') then 
			if (reset='1') then v:="0000";--syncronously resets the counter
								reached<='0';
			elsif (v=9) then reached<='1';--the counter reaches the value 9
			else v:=v+1;
				reached<='0';
			end if;
		end if;
	a<=v;
	end process;
end arhcounter_ct;