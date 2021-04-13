-----------------------------------------------------------------------------
--FILENAME        : dmux1t16.vhd
--DESCRIPTION     : a 1 to 16 demultiplexer
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dmux1t16 is
   port (
      a, e: in std_logic;
      c: std_logic_vector(3 downto 0);
      b0, b1, b2, b3, b4, b5, b6, b7, b8, b9 ,b10, b11, b12, b13, b14, b15:
         out std_logic
   );
end entity;

architecture dmux1t16_arh of dmux1t16 is
begin			                                                                 
-----------------------------------------------------------------------------
-- The function for each of the outputs.
-----------------------------------------------------------------------------
   b0  <= a and not(c(3)) and not(c(2)) and not(c(1)) and not(c(0)) and e;
   b1  <= a and not(c(3)) and not(c(2)) and not(c(1)) and     c(0)  and e;
   b2  <= a and not(c(3)) and not(c(2)) and     c(1)  and not(c(0)) and e;
   b3  <= a and not(c(3)) and not(c(2)) and     c(1)  and     c(0)  and e;

   b4  <= a and not(c(3)) and     c(2)  and not(c(1)) and not(c(0)) and e;
   b5  <= a and not(c(3)) and     c(2)  and not(c(1)) and     c(0)  and e;
   b6  <= a and not(c(3)) and     c(2)  and     c(1)  and not(c(0)) and e;
   b7  <= a and not(c(3)) and     c(2)  and     c(1)  and     c(0)  and e;
   
   b8  <= a and     c(3)  and not(c(2)) and not(c(1)) and not(c(0)) and e;
   b9  <= a and     c(3)  and not(c(2)) and not(c(1)) and     c(0)  and e;
   b10 <= a and     c(3)  and not(c(2)) and     c(1)  and not(c(0)) and e;
   b11 <= a and     c(3)  and not(c(2)) and     c(1)  and     c(0)  and e;

   b12 <= a and     c(3)  and     c(2)  and not(c(1)) and not(c(0)) and e;
   b13 <= a and     c(3)  and     c(2)  and not(c(1)) and     c(0)  and e;
   b14 <= a and     c(3)  and     c(2)  and     c(1)  and not(c(0)) and e;
   b15 <= a and     c(3)  and     c(2)  and     c(1)  and     c(0)  and e;
end architecture;