-----------------------------------------------------------------------------
--FILENAME        : complex_adder.vhd
--DESCRIPTION     : based on the optype value (0 = adition; 1 = difference)
--                  it computes either the additon or the substraction of the
--                  digits given in d1 and d2 and the carryin. It returns the
--                  result as a digit a carryout
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity complex_adder is
   port (
      optype, carryin: in std_logic;
      d1, d2: in std_logic_vector (3 downto 0);
      result: out std_logic_vector (3 downto 0);
      carryout: out std_logic
   );
end entity;

architecture complex_adder_arh of complex_adder is
-----------------------------------------------------------------------------
-- We use a digit adder and a digit substracter.
-----------------------------------------------------------------------------
   component digit_adder is
      port (
         carryin: in std_logic;
         nr1, nr2: in std_logic_vector (3 downto 0);
         result: out std_logic_vector (3 downto 0);
         carryout: out std_logic
      );
   end component;
   component digit_substracter is
      port (
         carryin: in std_logic;
         nr1, nr2: in std_logic_vector (3 downto 0);
         result: out std_logic_vector (3 downto 0);
         carryout: out std_logic
      );
   end component;																  
-----------------------------------------------------------------------------
   signal t1, t2: std_logic_vector(3 downto 0);
   signal t3, t4: std_logic;
begin                                           
-----------------------------------------------------------------------------
-- We add the two digits and store the result in t1 and the carry out in t3.
-----------------------------------------------------------------------------
   c1: digit_adder       port map (
      carryin => carryin, nr1 => d1, nr2 => d2,
      result => t1, carryout => t3
   );
-----------------------------------------------------------------------------
-- We substract the two digits and store the result in t2 and the carry out
-- in t4.
-----------------------------------------------------------------------------
   c2: digit_substracter port map (
      carryin => carryin, nr1 => d1, nr2 => d2,
      result => t2, carryout => t4
   );
-----------------------------------------------------------------------------
-- The result finctions depend on the value of optype.
-----------------------------------------------------------------------------
   result(0) <= (t1(0) and not(optype)) or (t2(0) and optype);
   result(1) <= (t1(1) and not(optype)) or (t2(1) and optype);
   result(2) <= (t1(2) and not(optype)) or (t2(2) and optype);
   result(3) <= (t1(3) and not(optype)) or (t2(3) and optype);
   carryout <= (t3 and not(optype)) or (t4 and optype);
end;