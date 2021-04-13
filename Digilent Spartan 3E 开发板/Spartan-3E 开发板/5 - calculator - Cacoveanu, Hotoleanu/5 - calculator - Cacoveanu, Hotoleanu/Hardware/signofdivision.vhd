----------------------------------------------------------------------------------
-- Create Date:    13:04:55 10/03/2006 
-- Module Name:    signofdivision - arhsignofdivision 
-- Project Name:   calculatorgata
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module receives the signs of the numbers a and b and 
--                 returns the sign of the division of the numbers a and b
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--clk - clock
--sgna - sign of a
--sgnb - sign of b
--signc - sign of a/b
----------------------------------------------------------------------------------
entity signofdivision is
   port (clk,sgna,sgnb:in std_logic;
   signc:out std_logic);
end signofdivision;

architecture arhsignofdivision of signofdivision is
begin         
   process(clk)
   begin
      if (clk'event) and (clk='1') then 
         signc<=(sgna and not(sgnb)) or (not(sgna) and sgnb);
      end if;
   end process;
end arhsignofdivision;
         
         
   