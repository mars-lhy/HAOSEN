-----------------------------------------------------------------------------
--FILENAME        : substracter.vhd
--DESCRIPTION     : substracts b and ci form a and returns the values under
--                  the form of a result bit and a carry out bit
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity substracter is
   port (
      ci, a, b, e: in std_logic;
      r, co: out std_logic
   );
end entity;

architecture substracter_arh of substracter is
begin
-----------------------------------------------------------------------------
-- The equations of the output functions.
-----------------------------------------------------------------------------
   r  <= ((ci xor (a xor b)) and e) or (a and not(e));
   co <= (((ci and not(a)) or (b and not(a)) or (ci and b)) and e) or
         (a and not(e));
end architecture;