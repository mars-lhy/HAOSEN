-----------------------------------------------------------------------------
--FILENAME        : digit_adder.vhd
--DESCRIPTION     : adds two decimal digits and a 1bit carry in value and
--                  returns a resulting digit and a carry out 1bit value.
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity digit_adder is
   port (
      carryin: in std_logic;
      nr1, nr2: in std_logic_vector (3 downto 0);
      result: out std_logic_vector (3 downto 0);
      carryout: out std_logic
   );
end entity;

architecture digit_adder_arh of digit_adder is
-----------------------------------------------------------------------------
-- We need 12 adders and a 6bit comparator.
-----------------------------------------------------------------------------
   component adder is
      port (
         ci, a, b, e: in std_logic;
         r, co: out std_logic
      );
   end component;
   component comp6 is
      port (
         n1, n0: in std_logic_vector(5 downto 0);
         b, e, l: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal t1, t2, tco1, tco2: std_logic_vector(5 downto 0);
   signal test, tt, ttt: std_logic;
begin
-----------------------------------------------------------------------------
-- We add the 4bit input numbers(digits) nr1 and nr2 and the carry n bit
-- and store the result in the 6bit signal t1 and link the carry outs and
-- the carry ins of the adder components using signal tco1.
-----------------------------------------------------------------------------
   c1 : adder port map (
      ci => carryin, a => nr1(0), b => nr2(0), e => '1',
      r => t1(0), co => tco1(0)
   );
   c2 : adder port map (
      ci => tco1(0), a => nr1(1), b => nr2(1), e => '1',
      r => t1(1), co => tco1(1)
   );
   c3 : adder port map (
      ci => tco1(1), a => nr1(2), b => nr2(2), e => '1',
      r => t1(2), co => tco1(2)
   );
   c4 : adder port map (
      ci => tco1(2), a => nr1(3), b => nr2(3), e => '1',
      r => t1(3), co => tco1(3)
   );
   c5 : adder port map (
      ci => tco1(3), a => '0'   , b => '0'   , e => '1',
      r => t1(4), co => tco1(4)
   );
   c6 : adder port map (
      ci => tco1(4), a => '0'   , b => '0'   , e => '1',
      r => t1(5), co => tco1(5)
   );
-----------------------------------------------------------------------------
-- We compare the partial result stored in t1 with number "001001" and store
-- the result of the test "t1 bigger than 001001" in signal test. Signals
-- tt and ttt are used only to prevent leaving the outputs of comp6 in air.
-----------------------------------------------------------------------------
   c13: comp6 port map (
      n1 => t1, n0 => "001001",
      b => test, e => tt, l => ttt
   );
-----------------------------------------------------------------------------
-- If test is '1' (meaning that t1 is not a digit, it is at least ten) we
-- substract "001010" from t1 and store the partial result in t2; we use
-- tco2 to link the c.ins to the c.outs.
-----------------------------------------------------------------------------
   c7 : adder port map (
      ci => '0'    , a => t1(0), b => '0', e => test,
      r => t2(0), co => tco2(0)
   );
   c8 : adder port map (
      ci => tco2(0), a => t1(1), b => '1', e => test,
      r => t2(1), co => tco2(1)
   );
   c9 : adder port map (
      ci => tco2(1), a => t1(2), b => '1', e => test,
      r => t2(2), co => tco2(2)
   );
   c10: adder port map (
      ci => tco2(2), a => t1(3), b => '0', e => test,
      r => t2(3), co => tco2(3)
   );
   c11: adder port map (
      ci => tco2(3), a => t1(4), b => '1', e => test,
      r => t2(4), co => tco2(4)
   );
   c12: adder port map (
      ci => tco2(4), a => t1(5), b => '0', e => test,
      r => t2(5), co => tco2(5)
   );
-----------------------------------------------------------------------------
-- The result will be the first 4 bits of t2 and the carry out will be the
-- 5th bit of t2.
-----------------------------------------------------------------------------
result <= t2(3 downto 0);
carryout <= t2(5);
end architecture;