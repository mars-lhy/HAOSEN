----------------------------------------------------------------------------------
-- Create Date:    21:49:12 09/26/2006 
-- Module Name:    counter - arhcounter 
-- Project Name:   display
-- Tool versions:  Xilinx 8.1 ISE
-- Author:         Hotoleanu Dan 
-- Description:    This module is a modulo 18 counter on 5 bits whith clock(clk),
--                 clock enable(ce) and reset(reset).
--                 It is a clock divider.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--clk - clock
--ce - clock enable
--reset - reset
--a - state of the counter
---------------------------------------------------------------------------------
entity counterdisplay is
   port (clk,ce,reset:in std_logic;
   a:out std_logic_vector(17 downto 0));
end counterdisplay;

architecture arhcounterdisplay of counterdisplay is
begin
   process(clk)                                        
   variable v:std_logic_vector(17 downto 0);
   begin
      if (clk'event) and (clk='1') and (ce='1') then 
         if (reset='1') then v:=(others => '0'); --syncronously resets the counter    
         else v:=v+1;          
         end if;
      end if;    
      a<=v;
   end process;
end arhcounterdisplay;