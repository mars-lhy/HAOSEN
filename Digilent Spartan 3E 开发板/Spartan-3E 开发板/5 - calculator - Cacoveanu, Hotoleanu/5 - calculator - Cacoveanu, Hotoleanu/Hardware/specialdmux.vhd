----------------------------------------------------------------------------------
-- Create Date:    13:04:55 10/03/2006 
-- Module Name:    specialdmux - arhspecialdmux
-- Project Name:   calculatorgata
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a demultiplexer which selects between the digits 
--                 a set of digits that are going to be displayed
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--sign - sign of the number
--sw0,sw1 - switches that select the part of the number that is displayed
--a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0 - digits of the number
--c3,c2,c1,c0 - digits selected to be displayed
--point - if the part diplayed contains a point
---------------------------------------------------------------------------------
entity specialdmux is
   port (sign,sw0,sw1:in std_logic;
   a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0:in std_logic_vector(3 downto 0);
   c3,c2,c1,c0:out std_logic_vector(3 downto 0);
   point:out std_logic);
end specialdmux;

architecture arhspecialdmux of specialdmux is
begin
   process(sign,sw0,sw1,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0)
   begin
      if (sw0='0') and (sw1='0') then 
         if (sign='1') then c3<="1011";--selects the sign - 
			else c3<="1111";--selects the sign +
			end if;
         c2<=a10;
         c1<=a9;
         c0<=a8;
         point<='0';
      elsif (sw0='0') and (sw1='1') then 
         c3<=a7;
         c2<=a6;
         c1<=a5;
         c0<=a4;
         point<='0';
      elsif (sw0='1') and (sw1='0') then
         c3<=a3;
         c2<=a2;
         c1<=a1;
         c0<=a0;
         point<='1'; 
      end if;
   end process;
end arhspecialdmux;
         