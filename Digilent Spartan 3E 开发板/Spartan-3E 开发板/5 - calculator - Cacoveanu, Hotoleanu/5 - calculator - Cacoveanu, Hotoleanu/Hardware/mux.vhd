----------------------------------------------------------------------------------
-- Create Date:    22:16:34 09/26/2006 
-- Module Name:    mux - arhmux
-- Project Name:   display
-- Tool versions:  Xilinx 8.1 ISE
-- Author:         Hotoleanu Dan 
-- Description:    This module is a multiplexer 4:1.It has an entrance that
--                 consists of a bus of 2 bits of selection and 4 buses of 4 bits.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--a3,a2,a1,a0 - buses of 4 bits
--s - bus of 2 bits of selection
--b - output bus of 4 bits
---------------------------------------------------------------------------------
entity mux is
   port (a3,a2,a1,a0:in std_logic_vector(3 downto 0);
   s:in std_logic_vector(1 downto 0);
   b:out std_logic_vector(3 downto 0));
end mux;

architecture arhmux of mux is
begin
   process(a3,a2,a1,a0,s)
   begin
      if (s="00") then b<=a0;
      elsif (s="01") then b<=a1;
      elsif (s="10") then b<=a2;
      elsif (s="11") then b<=a3;
      end if;
   end process;
end arhmux;