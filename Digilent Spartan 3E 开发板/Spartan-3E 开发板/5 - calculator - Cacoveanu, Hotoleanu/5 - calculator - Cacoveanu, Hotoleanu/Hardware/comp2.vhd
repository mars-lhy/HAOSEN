-----------------------------------------------------------------------------
--FILENAME        : comp2.vhd
--DESCRIPTION     : compares two 2bit numbers and returns '1' on
--                  b if n1 > n0
--                  e if n1 = n0
--                  l if n1 < n0
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity comp2 is
   port (
      n1, n0: in std_logic_vector(1 downto 0);
      b, e, l: out std_logic
   );
end entity;

architecture comp2_arh of comp2 is
begin
-----------------------------------------------------------------------------
-- The ecuations for the output functions:
-----------------------------------------------------------------------------
   b <= (n1(1)and(not(n0(1))))or(n1(1)and n1(0)and not(n0(0)))or(n1(0) and
      not(n0(0)) and not(n0(1)));
   e <= (not(n1(1)) and not(n1(0)) and not(n0(1)) and not(n0(0)))or
      (not(n1(1)) and n1(0) and not(n0(1)) and n0(0))or(n1(1) and not(n1(0))
      and n0(1) and not(n0(0)))or(n1(1) and n1(0) and n0(1) and n0(0));
   l <= (not(n1(1)) and n0(1))or (not(n1(1)) and not(n1(0)) and n0(0))or
      (not(n1(0)) and n0(1) and n0(0));
end architecture;