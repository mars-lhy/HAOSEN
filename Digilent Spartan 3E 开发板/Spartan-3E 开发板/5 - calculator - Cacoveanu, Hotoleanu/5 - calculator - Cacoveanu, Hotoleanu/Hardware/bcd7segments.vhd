---------------------------------------------------------------------------------- 
-- Create Date:    22:25:50 09/26/2006 
-- Module Name:    bcd7segments - arhbcd7segments
-- Project Name:   display
-- Tool versions:  Xilinx 8.1 ISE
-- Author:         Hotoleanu Dan 
-- Description:    This is a 7 segments binary decoder.It has as input a bus of 4
--                 bits and as output a bus of 7 bits active when their value 
--                 is '1'.The output of this component is conected to the pins 
--                 a,b,c,d,e,f,g of the display of the board and selects which 
--                 segment is active and which is not.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--a - input bus
--b - output bus
---------------------------------------------------------------------------------
entity bcd7segments is
   port (a:in std_logic_vector(3 downto 0);
   b:out std_logic_vector(6 downto 0));
end bcd7segments;  

architecture arhbcd7segments of bcd7segments is
begin
   process(a)--process sensitive to the input
   begin
      if (a="0000") then b<="1000000";--displays 0 
      elsif (a="0001") then b<="1111001";--displays 1 
      elsif (a="0010") then b<="0100100";--displays 2
      elsif (a="0011") then b<="0110000";--displays 3
      elsif (a="0100") then b<="0011001";--displays 4
      elsif (a="0101") then b<="0010010";--displays 5 
      elsif (a="0110") then b<="0000010";--displays 6
      elsif (a="0111") then b<="1011000";--displays 7
      elsif (a="1000") then b<="0000000";--displays 8
      elsif (a="1001") then b<="0010000";--displays 9
      elsif (a="1011") then b<="0111111";--displays the sign '-'
      elsif (a="1100") then b<="0000110";--diplays E (error)
		else b<="1111111";
      end if;
   end process;
end arhbcd7segments;