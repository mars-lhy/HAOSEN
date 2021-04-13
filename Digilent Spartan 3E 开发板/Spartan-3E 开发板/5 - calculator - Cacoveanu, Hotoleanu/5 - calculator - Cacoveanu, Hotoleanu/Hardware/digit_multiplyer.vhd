-----------------------------------------------------------------------------
--FILENAME        : digit_multiplyer.vhd
--DESCRIPTION     : multiplyes 2 digits (decimal, encoded on 4 bits) and
--                  returns the result as a number of 2 digits
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity digit_multiplyer is
   port (
      a, b: in std_logic_vector(3 downto 0);
      res, co: out std_logic_vector(3 downto 0)
   );
end entity;

architecture digit_multiplyer_arh of digit_multiplyer is
-----------------------------------------------------------------------------
-- We use 4 simple multiplyers, 11 adders on 7 bits, 8 substracters on 7 bits
-- and 8 comparators on 7 bits.
-----------------------------------------------------------------------------
   component simple_mult is
      port (
         a: in std_logic_vector(3 downto 0);
         b: in std_logic;	  
         r: out std_logic_vector(3 downto 0)
      );
   end component;
   component adder7 is
      port (
         carryin: in std_logic;
         nr1, nr2: in std_logic_vector (6 downto 0);
         result: out std_logic_vector (6 downto 0);
         carryout: out std_logic
      );
   end component;
   component substracter7 is
      port (
         carryin, e: in std_logic;
         nr1, nr2: in std_logic_vector (6 downto 0);
         result: out std_logic_vector (6 downto 0);
         carryout: out std_logic
      );
   end component;
   component comp7 is
	   port (
         n1, n0: in std_logic_vector(6 downto 0);
	      b, e, l: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal t0, t1, t2, t3, f0, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10,
          l0, l1, l2, l3, l4, l5, l6, l7: std_logic_vector(6 downto 0);
   signal b3, b4, b5, b6, b7, b8, b9, b10: std_logic;
   signal u: std_logic_vector(34 downto 0); --unused signals
begin												
-----------------------------------------------------------------------------
-- We multiply digit a with each bit of digit b and store the results
-- in 7bit numbers t0, t1, t2, and t3, taking into consideration the zeroes
-- we have to add at the end of each number, depending on the magnitude of
-- the digits in b we multiplyed a with.
-----------------------------------------------------------------------------
   c0 : simple_mult port map (a => a, b => b(0), r => t0(3 downto 0));
   t0(4) <= '0'; t0(5) <= '0'; t0(6) <= '0';
   c1 : simple_mult port map (a => a, b => b(1), r => t1(4 downto 1));
   t1(0) <= '0'; t1(5) <= '0'; t1(6) <= '0';
   c2 : simple_mult port map (a => a, b => b(2), r => t2(5 downto 2));
   t2(0) <= '0'; t2(1) <= '0'; t2(6) <= '0';
   c3 : simple_mult port map (a => a, b => b(3), r => t3(6 downto 3));
   t3(0) <= '0'; t3(1) <= '0'; t3(2) <= '0';
-----------------------------------------------------------------------------
-- We add t0, t1, t2, and t3 and store the final result in f2. For partial
-- results we use f0 and f1 and for connecting the c.out pins we used u(0),
-- u(1) and u(2) (they are not really needed).
-----------------------------------------------------------------------------
   c4 : adder7 port map (
      carryin => '0', nr1 => t0, nr2 => t1,
      result => f0, carryout => u(0)
   );
   c5 : adder7 port map (
      carryin => '0', nr1 => t2, nr2 => t3,
      result => f1, carryout => u(1)
   );
   c6 : adder7 port map (
      carryin => '0', nr1 => f0, nr2 => f1,
      result => f2, carryout => u(2)
   );
-----------------------------------------------------------------------------
-- We now successively compare the result obtained above (in f2) with
-- number "0001010" and if we find the partial result bigger than it, we
-- substract "0001010" from the partial result. The partial result will be
-- successively stored into vectors f2 to f9. The bigger-than function
-- result will be stored into b3 to b9 and used as an enable for the
-- substracter component, while the other functions are stored into
-- u(3) to u(26) and are not used.
-----------------------------------------------------------------------------
   c7 : comp7 port map (
      n1  => f2, n0  => "0001010",
      b => b3, e => u(3), l => u(4)
   );
   c8 : substracter7 port map (
      carryin => '0', e => b3 , nr1 => f2, nr2 => "0001010",
      result => f3 , carryout => u(5)
   );
   c9 : comp7 port map (
      n1  => f3, n0  => "0001010",
      b => b4, e => u(6), l => u(7)
   );
   c10: substracter7 port map (
      carryin => '0', e => b4 , nr1 => f3, nr2 => "0001010",
      result => f4 , carryout => u(8)
   );
   c11: comp7 port map (
      n1  => f4, n0  => "0001010",
      b => b5 , e => u(9), l => u(10)
   );
   c12: substracter7 port map (
      carryin => '0', e => b5 , nr1 => f4, nr2 => "0001010",
      result => f5 , carryout => u(11)
   );
   c13: comp7 port map (
      n1  => f5, n0  => "0001010", b => b6 ,
      e => u(12), l => u(13)
   );
   c14: substracter7 port map (
      carryin => '0', e => b6 , nr1 => f5, nr2 => "0001010",
      result => f6 , carryout => u(14)
   );
   c15: comp7 port map (
      n1  => f6, n0  => "0001010",
      b => b7 , e => u(15), l => u(16)
   );
   c16: substracter7 port map (
      carryin => '0', e => b7 , nr1 => f6, nr2 => "0001010",
      result => f7 , carryout => u(17)
   );
   c17: comp7 port map (
      n1  => f7, n0  => "0001010",
      b => b8 , e => u(18), l => u(19)
   );
   c18: substracter7 port map (
      carryin => '0', e => b8 , nr1 => f7, nr2 => "0001010",
      result => f8 , carryout => u(20)
   );
   c19: comp7 port map (
      n1  => f8, n0  => "0001010",
      b => b9 , e => u(21), l => u(22)
   );
   c20: substracter7 port map (
      carryin => '0', e => b9 , nr1 => f8, nr2 => "0001010",
      result => f9 , carryout => u(23)
   );
   c21: comp7 port map (
      n1  => f9, n0  => "0001010",
      b => b10, e => u(24), l => u(25)
   );
   c22: substracter7 port map (
      carryin => '0', e => b10, nr1 => f9, nr2 => "0001010",
      result => f10, carryout => u(26)
   );
-----------------------------------------------------------------------------
-- We add all the results of the bigger-than function to l7, using l0 to l6
-- in the process, as well as u(27) t0 u(34) for the c.out pins.
-----------------------------------------------------------------------------
   c23: adder7 port map (
      carryin => b3 , nr1 => "0000000", nr2 => "0000000",
      result => l0, carryout => u(27)
   );
   c24: adder7 port map (
      carryin => b4 , nr1 => l0       , nr2 => "0000000",
      result => l1, carryout => u(28)
   );
   c25: adder7 port map (
      carryin => b5 , nr1 => l1       , nr2 => "0000000",
      result => l2, carryout => u(29)
   );
   c26: adder7 port map (
      carryin => b6 , nr1 => l2       , nr2 => "0000000",
      result => l3, carryout => u(30)
   );
   c27: adder7 port map (
      carryin => b7 , nr1 => l3       , nr2 => "0000000",
      result => l4, carryout => u(31)
   );
   c28: adder7 port map (
      carryin => b8 , nr1 => l4       , nr2 => "0000000",
      result => l5, carryout => u(32)
   );
   c29: adder7 port map (
      carryin => b9 , nr1 => l5       , nr2 => "0000000",
      result => l6, carryout => u(33)
   );
   c30: adder7 port map (
      carryin => b10, nr1 => l6       , nr2 => "0000000",
      result => l7, carryout => u(34)
   );
-----------------------------------------------------------------------------
-- The result digit will be the 3 downto 0 bits of f10 and the carry out
-- digit will be the 3 downto 0 bits of l7.
-----------------------------------------------------------------------------
   res <= f10(3 downto 0);
   co <= l7(3 downto 0);
end;