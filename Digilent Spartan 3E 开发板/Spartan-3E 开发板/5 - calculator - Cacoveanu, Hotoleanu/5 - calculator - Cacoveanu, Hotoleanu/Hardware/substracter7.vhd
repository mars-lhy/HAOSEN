-----------------------------------------------------------------------------
--FILENAME        : subtracter7.vhd
--DESCRIPTION     : substracts 7bit number nr2 from 7bit number nr1
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity substracter7 is
   port (
      carryin, e: in std_logic;
      nr1, nr2: in std_logic_vector (6 downto 0);
      result: out std_logic_vector (6 downto 0);
      carryout: out std_logic
   );
end entity;

architecture substracter7_arh of substracter7 is
-----------------------------------------------------------------------------
-- Uses 7 substracter components.
-----------------------------------------------------------------------------
   component substracter is
      port (
         ci, a, b, e: in std_logic;
         r, co: out std_logic
      );
   end component;																	  
-----------------------------------------------------------------------------
   signal co: std_logic_vector(5 downto 0);
begin
-----------------------------------------------------------------------------
-- Links all the 7 subtracter components to substract b from a and store the
-- result in result; uses signal co to link c.in with c.out pins.
-----------------------------------------------------------------------------
   c0 : substracter port map (
      ci => carryin, a => nr1(0), b => nr2(0), e => e,
      r => result(0), co => co(0)
   );
   c1 : substracter port map (
      ci => co(0)  , a => nr1(1), b => nr2(1), e => e,
      r => result(1), co => co(1)
   );
   c2 : substracter port map (
      ci => co(1)  , a => nr1(2), b => nr2(2), e => e,
      r => result(2), co => co(2)
   );
   c3 : substracter port map (
      ci => co(2)  , a => nr1(3), b => nr2(3), e => e,
      r => result(3), co => co(3)
   );
   c4 : substracter port map (
      ci => co(3)  , a => nr1(4), b => nr2(4), e => e,
      r => result(4), co => co(4)
   );
   c5 : substracter port map (
      ci => co(4)  , a => nr1(5), b => nr2(5), e => e,
      r => result(5), co => co(5)
   );
   c6 : substracter port map (
      ci => co(5)  , a => nr1(6), b => nr2(6), e => e,
      r => result(6), co => carryout
   );
end architecture;