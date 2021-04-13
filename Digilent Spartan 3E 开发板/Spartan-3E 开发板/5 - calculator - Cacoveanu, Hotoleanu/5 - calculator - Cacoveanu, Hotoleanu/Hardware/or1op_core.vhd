-----------------------------------------------------------------------------
--FILENAME        : or1op_core.vhd
--DESCRIPTION     : This component performs adds the number stored in a with
--                  with the one stored in b, or substracts the number
--                  stored in b from the number stored in a, on the condition
--                  that the number stored in a is bigger than the one stored
--                  in b
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------------------------------------
-- The number stored in a has 11 digits, each digit stored in a vector from
-- a0 to a10. sgna stores the sign of the number stored in a ('0' = plus,
-- '1' = minus). The same goes for b and c. optype decides the type of
-- operation that will be performed on the digits of numbers a and b.
-- carryout and carryin are used for linking more than one or1op components.
-----------------------------------------------------------------------------
entity or1op_core is
   port(
      carryin: in std_logic;
      a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
         in std_logic_vector(3 downto 0);
      b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0:
         in std_logic_vector(3 downto 0);
      sgna, sgnb, optype: in std_logic;
      c10, c9, c8, c7, c6, c5, c4, c3, c2, c1, c0:
         out std_logic_vector(3 downto 0);
      carryout: out std_logic;
      sgnc: out std_logic
   );
end entity;

architecture or1op_core_arh of or1op_core is
-----------------------------------------------------------------------------
-- We use 10 complex digit adders.
-----------------------------------------------------------------------------
   component complex_adder is
      port (
         optype, carryin: in std_logic;
         d1, d2: in std_logic_vector (3 downto 0);
         result: out std_logic_vector (3 downto 0);
         carryout: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal co: std_logic_vector(10 downto 0);
   signal toptype: std_logic;
begin					                
-----------------------------------------------------------------------------
-- The operation performed on the digits of the two numbers depend on the
-- signs of a and b.
-----------------------------------------------------------------------------
toptype <= sgna xor (sgnb xor optype);
-----------------------------------------------------------------------------
-- We add each digit of a with each digit of b, returning the rssult in c and
-- using co to link the c.out bits with the c.in bits.
-----------------------------------------------------------------------------
   comp0 : complex_adder port map (
      optype => toptype, carryin => carryin  , d1 => a0 , d2 => b0 ,
      result => c0 , carryout => co(0)
   );
   comp1 : complex_adder port map (
      optype => toptype, carryin => co(0), d1 => a1 , d2 => b1 ,
      result => c1 , carryout => co(1)
   );
   comp2 : complex_adder port map (
      optype => toptype, carryin => co(1), d1 => a2 , d2 => b2 ,
      result => c2 , carryout => co(2)
   );
   comp3 : complex_adder port map (
      optype => toptype, carryin => co(2), d1 => a3 , d2 => b3 ,
      result => c3 , carryout => co(3)
   );
   comp4 : complex_adder port map (
      optype => toptype, carryin => co(3), d1 => a4 , d2 => b4 ,
      result => c4 , carryout => co(4)
   );
   comp5 : complex_adder port map (
      optype => toptype, carryin => co(4), d1 => a5 , d2 => b5 ,
      result => c5 , carryout => co(5)
   );
   comp6 : complex_adder port map (
      optype => toptype, carryin => co(5), d1 => a6 , d2 => b6 ,
      result => c6 , carryout => co(6)
   );
   comp7 : complex_adder port map (
      optype => toptype, carryin => co(6), d1 => a7 , d2 => b7 ,
      result => c7 , carryout => co(7)
   );
   comp8 : complex_adder port map (
      optype => toptype, carryin => co(7), d1 => a8 , d2 => b8 ,
      result => c8 , carryout => co(8)
   );
   comp9 : complex_adder port map (
      optype => toptype, carryin => co(8), d1 => a9 , d2 => b9 ,
      result => c9 , carryout => co(9)
   );
   comp10: complex_adder port map (
      optype => toptype, carryin => co(9), d1 => a10, d2 => b10,
      result => c10, carryout => carryout
   );                                    
-----------------------------------------------------------------------------
-- The sign of c is always the sign of a (provided that a is always bigger
-- than b).                                    
-----------------------------------------------------------------------------
   sgnc <= sgna;
end architecture;