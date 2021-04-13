-----------------------------------------------------------------------------
--FILENAME        : comp7.vhd
--DESCRIPTION     : compares two 7bit numbers and returns '1' on
--                  b if n1 > n0
--                  e if n1 = n0
--                  l if n1 < n0
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity comp7 is
   port (
      n1, n0: in std_logic_vector(6 downto 0);
      b, e, l: out std_logic
   );
end entity;

architecture comp7_arh of comp7 is
-----------------------------------------------------------------------------
-- Uses three 2bit comparators.
-----------------------------------------------------------------------------
   component comp2 is
	   port (
         n1, n0: in std_logic_vector(1 downto 0);
	      b, e, l: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal t2, t1, t0: std_logic_vector(0 to 2);
begin		 																						
-----------------------------------------------------------------------------
-- We compare the numbers in three pairs of two bits and store the results
-- in t2, t1 and t0.
-----------------------------------------------------------------------------
   c2: comp2 port map (
      n1 => n1(5 downto 4), n0 => n0(5 downto 4),
      b => t2(0), e => t2(1), l => t2(2)
   );
   c1: comp2 port map (
      n1 => n1(3 downto 2), n0 => n0(3 downto 2),
      b => t1(0), e => t1(1), l => t1(2)
   );
   c0: comp2 port map (
      n1 => n1(1 downto 0), n0 => n0(1 downto 0),
      b => t0(0), e => t0(1), l => t0(2)
   );
-----------------------------------------------------------------------------
-- The equations of the output functions using the results of the comparison
-- made on pairs of bits and the first bit of each number.
-----------------------------------------------------------------------------
   e <= (n1(6) xnor n0(6)) and t2(1) and t1(1) and t0(1);
   b <= (n1(6) and not(n0(6))) or ((n1(6) xnor n0(6)) and t2(0)) or
        (t2(1) and t1(0)) or (t2(1) and t1(1) and t0(0));
   l <= (n0(6) and not(n1(6))) or ((n1(6) xnor n0(6)) and t2(2)) or
        (t2(1) and t1(2)) or (t2(1) and t1(1) and t0(2));
end architecture;