----------------------------------------------------------------------------------
-- Create Date:    21:53:18 09/26/2006 
-- Module Name:    counter_selection - arhcounter_selection 
-- Project Name:   display
-- Tool versions:  Xilinx 8.1 ISE
-- Author:         Hotoleanu Dan 
-- Description:    This module is a counter on 2 bits with clock(clk), clock 
--                 enable(ce) and reset(reset).It is used for selecting the
--                 anodes.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--clk - clock
--ce - clock reset
--reset - reset
--a - state of the counter
----------------------------------------------------------------------------------
entity counter_selection is
   port (clk,ce,reset:in std_logic;
   a:out std_logic_vector(1 downto 0));
end counter_selection; 

architecture arhcounter_selection of counter_selection is
begin
   process(clk)                                        
   variable v:std_logic_vector(1 downto 0);
   begin
      if (clk'event) and (clk='1') and (ce='1') then 
         if (reset='1') then v:="00";  --syncronously resets the counter   
         else v:=v+1;          
         end if;
      end if;    
      a<=v;
   end process;
end arhcounter_selection;