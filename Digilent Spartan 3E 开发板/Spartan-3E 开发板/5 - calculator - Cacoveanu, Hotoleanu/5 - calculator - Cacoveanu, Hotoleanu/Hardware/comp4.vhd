-----------------------------------------------------------------------------
--FILENAME        : comp4.vhd
--DESCRIPTION     : compares two 4bit numbers and returns '1' on
--                  b if n1 > n0
--                  e if n1 = n0
--                  l if n1 < n0
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity comp4 is
   port (
      n1, n0: in std_logic_vector(3 downto 0);
      b, e, l: out std_logic
   );
end entity;

architecture comp4_arh of comp4 is
-----------------------------------------------------------------------------
-- Uses two 2bit comparators.
-----------------------------------------------------------------------------
   component comp2 is
      port (
         n1, n0: in std_logic_vector(1 downto 0);
         b, e, l: out std_logic);
   end component;
-----------------------------------------------------------------------------
   signal t1, t0: std_logic_vector(0 to 2);
begin		 
-----------------------------------------------------------------------------
-- We compare the numbers in pairs of bits and store the results in t1 and
-- t0.
-----------------------------------------------------------------------------
   c1: comp2 port map (
      n1 => n1(3 downto 2), n0 => n0(3 downto 2),
      b => t1(0), e => t1(1), l => t1(2)
   );
   c2: comp2 port map (
      n1 => n1(1 downto 0), n0 => n0(1 downto 0),
      b => t0(0), e => t0(1), l => t0(2)
   );
-----------------------------------------------------------------------------
-- The equations of the output functions using the results of the comparison
-- made on pairs of bits.
-----------------------------------------------------------------------------
   e <= t1(1) and t0(1);
   b <= t1(0) or (t1(1) and t0(0));
   l <= t1(2) or (t1(1) and t0(2));
end architecture;