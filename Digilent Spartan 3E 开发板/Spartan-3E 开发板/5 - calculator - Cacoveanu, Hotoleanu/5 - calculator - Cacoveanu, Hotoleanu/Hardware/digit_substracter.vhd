-----------------------------------------------------------------------------
--FILENAME        : digit_substracter.vhd
--DESCRIPTION     : substracts digit nr2 and the carry in bit from digit nr1
--                  and returns the result as a digit and a carry out bit
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity digit_substracter is
   port (
      carryin: in std_logic;
      nr1, nr2: in std_logic_vector (3 downto 0);
      result: out std_logic_vector (3 downto 0);
      carryout: out std_logic
   );
end entity;

architecture digit_substracter_arh of digit_substracter is
-----------------------------------------------------------------------------
-- We use 4 substracters and 5 adders.
-----------------------------------------------------------------------------
   component substracter is
      port (
         ci, a, b, e: in std_logic;
         r, co: out std_logic
      );
   end component;																	  
   component adder is
      port (
         ci, a, b, e: in std_logic;
         r, co: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal t1, t2, t3, t4, t5, t6, t7: std_logic_vector(4 downto 0);
begin	   
-----------------------------------------------------------------------------
-- We substract nr2 from nr1 and store the result in t1. We use t2 to link
-- the c.out bits with the c.in bits of the substracter components.
-----------------------------------------------------------------------------
   c1: substracter port map (
      ci => carryin, a => nr1(0), b => nr2(0), e => '1',
      r => t1(0), co => t2(0)
   );
   c2: substracter port map (
      ci => t2(0)  , a => nr1(1), b => nr2(1), e => '1',
      r => t1(1), co => t2(1)
   );
   c3: substracter port map (
      ci => t2(1)  , a => nr1(2), b => nr2(2), e => '1',
      r => t1(2), co => t2(2)
   );
   c4: substracter port map (
      ci => t2(2)  , a => nr1(3), b => nr2(3), e => '1',
      r => t1(3), co => t2(3)
   );
-----------------------------------------------------------------------------
-- We store '1' in t1(4) (to avoid having an unknown value).
-----------------------------------------------------------------------------
   t1(4) <= '1';
-----------------------------------------------------------------------------
-- We add 01010 to t1 and store the result in t3; we use t4 to link c.in bits
-- with c.out bits.
-----------------------------------------------------------------------------
   c5: adder       port map (
      ci => '0'  , a => t1(0), b => '0', e => '1',
      r => t3(0), co => t4(0)
   );
   c6: adder       port map (
      ci => t4(0), a => t1(1), b => '1', e => '1',
      r => t3(1), co => t4(1)
   );
   c7: adder       port map (
      ci => t4(1), a => t1(2), b => '0', e => '1',
      r => t3(2), co => t4(2)
   );
   c8: adder       port map (
      ci => t4(2), a => t1(3), b => '1', e => '1',
      r => t3(3), co => t4(3)
   );
   c9: adder       port map (
      ci => t4(3), a => t1(4), b => '0', e => '1',
      r => t3(4), co => t4(4)
   );
-----------------------------------------------------------------------------
-- The result functions depend on the value of t2(3).
-----------------------------------------------------------------------------
   result(0) <= (t1(0) and not(t2(3))) or (t3(0) and t2(3));
   result(1) <= (t1(1) and not(t2(3))) or (t3(1) and t2(3));
   result(2) <= (t1(2) and not(t2(3))) or (t3(2) and t2(3));
   result(3) <= (t1(3) and not(t2(3))) or (t3(3) and t2(3));
   carryout  <= t2(3);
end architecture;