----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    counter - arhcounter
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a bidirectional counter which counts in the loop
--                 0 - 9. It is used to generate numbers for the multiplier
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--clk is the clock input, ce the clock enable input and reset, the reset input
--a is the output
--cd is the count direction
--reached is the output which showes that the counter has reached the value 9
----------------------------------------------------------------------------------
entity counter is
	port (clk,ce,cd,reset:in std_logic;
	a:out std_logic_vector(3 downto 0);
   reached:out std_logic);
end counter;

architecture arhcounter of counter is
begin
	process(clk)			 
	variable v:std_logic_vector(3 downto 0);
	begin
		if (clk'event) and (clk='1') and (ce='1') then 	
			if (reset='1') then v:="1111";--syncronously receives the value -1
                             reached<='0';
			elsif (cd='1') then--counting up
				if (v=9) then v:="0000";--the counter reaches the value 9 and after
                                    --a clock cycle, it resets				
				else v:=v+1;
               if (v=9) then reached<='1';--when the counter reaches the value 
					                           --9 the signal reached is active
               end if;
				end if;
			else --counting down
				if (v=0) then v:="1001";--this condition makes posible the jump 
                                    --from 0 to 9                         												
                         reached<='0';
				else v:=v-1;              
               reached<='0';
				end if;
			end if;
		end if;
	a<=v;
	end process;
end arhcounter;