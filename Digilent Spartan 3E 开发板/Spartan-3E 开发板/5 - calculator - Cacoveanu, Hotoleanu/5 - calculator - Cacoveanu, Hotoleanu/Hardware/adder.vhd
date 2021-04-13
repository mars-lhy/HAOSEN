-----------------------------------------------------------------------------
--FILENAME        : adder.vhd
--DESCRIPTION     : adds two bits and a carry in and returns the values
--                  under the form of a result bit and a carry out
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity adder is
   port (
      ci, a, b, e: in std_logic;
      r, co: out std_logic
   );
end entity;

architecture adder_arh of adder is
begin
-----------------------------------------------------------------------------
-- The functions for the outputs.
-----------------------------------------------------------------------------
   r <= ((ci xor (a xor b)) and e) or (a and not(e));
   co <= (((ci and b) or (ci and a) or (a and b)) and e) or (a and not(e));
end architecture;