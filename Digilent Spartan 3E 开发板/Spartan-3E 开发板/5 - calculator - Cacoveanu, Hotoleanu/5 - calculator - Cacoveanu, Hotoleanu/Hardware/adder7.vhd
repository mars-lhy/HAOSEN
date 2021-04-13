-----------------------------------------------------------------------------
--FILENAME        : adder7.vhd
--DESCRIPTION     : adds two 7bit numbers
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity adder7 is
   port (
      carryin: in std_logic;
      nr1, nr2: in std_logic_vector (6 downto 0);
      result: out std_logic_vector (6 downto 0);
      carryout: out std_logic
   );
end entity;

architecture adder7_arh of adder7 is
-----------------------------------------------------------------------------
-- Uses 7 adders.
-----------------------------------------------------------------------------
   component adder is
      port (
         ci, a, b, e: in std_logic;
         r, co: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal co: std_logic_vector(5 downto 0);
begin
-----------------------------------------------------------------------------
-- Links all the 7 adder components to add a to b and store the result in
-- result; uses signal co to link c.in with c.out pins.
-----------------------------------------------------------------------------
   c0 : adder port map (
      ci => carryin, a => nr1(0), b => nr2(0), e => '1',
      r => result(0), co => co(0)
   );
   c1 : adder port map (
      ci => co(0)  , a => nr1(1), b => nr2(1), e => '1',
      r => result(1), co => co(1)
   );
   c2 : adder port map (
      ci => co(1)  , a => nr1(2), b => nr2(2), e => '1',
      r => result(2), co => co(2)
   );
   c3 : adder port map (
      ci => co(2)  , a => nr1(3), b => nr2(3), e => '1',
      r => result(3), co => co(3)
   );
   c4 : adder port map (
      ci => co(3)  , a => nr1(4), b => nr2(4), e => '1',
      r => result(4), co => co(4)
   );
   c5 : adder port map (
      ci => co(4)  , a => nr1(5), b => nr2(5), e => '1',
      r => result(5), co => co(5)
   );
   c6 : adder port map (
      ci => co(5)  , a => nr1(6), b => nr2(6), e => '1',
      r => result(6), co => carryout
   );
end architecture;