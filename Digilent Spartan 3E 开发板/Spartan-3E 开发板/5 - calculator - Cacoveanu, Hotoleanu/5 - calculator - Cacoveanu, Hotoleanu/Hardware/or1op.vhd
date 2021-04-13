-----------------------------------------------------------------------------
--FILENAME        : or1op.vhd
--DESCRIPTION     : performs an order one operation on two 11digit numbers
--                  (a and b) depending on the control bit optype
--                  ('0' = addition, '1' = substraction). Returns the result
--                  as a number c. Also has a carryin pin and a carryout pin
--                  used for linking more or1op components together
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity or1op is
   port (
      carryin: in std_logic;
      a10, a9, a8, a7, a6, a5, a4, a3, a2, a1,
         a0: in std_logic_vector(3 downto 0);
      b10, b9, b8, b7, b6, b5, b4, b3, b2, b1,
         b0: in std_logic_vector(3 downto 0);
      sgna, sgnb, optype: in std_logic;
      c10, c9, c8, c7, c6, c5, c4, c3, c2, c1,
         c0: out std_logic_vector(3 downto 0);
      carryout: out std_logic;
      sgnc: out std_logic
   );
end entity;

architecture or1op_arh of or1op is
-----------------------------------------------------------------------------
-- Uses 11 4bit comparators and a or1op_core component.
-----------------------------------------------------------------------------
   component comp4 is
      port (
         n1, n0: in std_logic_vector(3 downto 0);
         b, e, l: out std_logic
      );
   end component;
   component or1op_core is
      port (
         carryin: in std_logic;
         a10, a9, a8, a7, a6, a5, a4, a3, a2, a1,
            a0: in std_logic_vector(3 downto 0);
         b10, b9, b8, b7, b6, b5, b4, b3, b2, b1,
            b0: in std_logic_vector(3 downto 0);
         sgna, sgnb, optype: in std_logic;
         c10, c9, c8, c7, c6, c5, c4, c3, c2, c1,
            c0: out std_logic_vector(3 downto 0);
         carryout: out std_logic;
         sgnc: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal abtb: std_logic;
   signal compar1, compar2, compar3: std_logic_vector(10 downto 0);				 
   signal ta10, ta9, ta8, ta7, ta6, ta5, ta4, ta3, ta2, ta1, ta0:
      std_logic_vector(3 downto 0);
   signal tb10, tb9, tb8, tb7, tb6, tb5, tb4, tb3, tb2, tb1, tb0:
      std_logic_vector(3 downto 0);
   signal tsgna, tsgnb: std_logic;
begin										 
-----------------------------------------------------------------------------
-- We compare numbers a and b digit by digit and store the results in the
-- compar vectors.
-----------------------------------------------------------------------------
   p0 : comp4 port map (
      n1 => a0 , n0 => b0 ,
      b => compar1(0) , e => compar2(0) , l=> compar3(0)
   );
   p1 : comp4 port map (
      n1 => a1 , n0 => b1 ,
      b => compar1(1) , e => compar2(1) , l=> compar3(1)
   );
   p2 : comp4 port map (
      n1 => a2 , n0 => b2 ,
      b => compar1(2) , e => compar2(2) , l=> compar3(2)
   );
   p3 : comp4 port map (
      n1 => a3 , n0 => b3 ,
      b => compar1(3) , e => compar2(3) , l=> compar3(3)
   );
   p4 : comp4 port map (
      n1 => a4 , n0 => b4 ,
      b => compar1(4) , e => compar2(4) , l=> compar3(4)
   );
   p5 : comp4 port map (
      n1 => a5 , n0 => b5 ,
      b => compar1(5) , e => compar2(5) , l=> compar3(5)
   );
   p6 : comp4 port map (
      n1 => a6 , n0 => b6 ,
      b => compar1(6) , e => compar2(6) , l=> compar3(6)
   );
   p7 : comp4 port map (
      n1 => a7 , n0 => b7 ,
      b => compar1(7) , e => compar2(7) , l=> compar3(7)
   );
   p8 : comp4 port map (
      n1 => a8 , n0 => b8 ,
      b => compar1(8) , e => compar2(8) , l=> compar3(8)
   );
   p9 : comp4 port map (
      n1 => a9 , n0 => b9 ,
      b => compar1(9) , e => compar2(9) , l=> compar3(9)
   );
   p10: comp4 port map (
      n1 => a10, n0 => b10,
      b => compar1(10), e => compar2(10), l=> compar3(10)
   );
-----------------------------------------------------------------------------
-- Function abtb is '1' if a is bigger than b.
-----------------------------------------------------------------------------
   abtb <= compar1(10) or (compar2(10) and compar1(9)) or (compar2(10) and 
           compar2(9) and compar1(8)) or (compar2(10) and compar2(9) and
           compar2(8) and compar1(7)) or (compar2(10) and compar2(9) and
           compar2(8) and compar2(7) and compar1(6)) or (compar2(10) and
           compar2(9) and compar2(8) and compar2(7) and compar2(6) and
           compar1(5)) or (compar2(10) and compar2(9) and compar2(8) and
           compar2(7) and compar2(6) and compar2(5) and compar1(4)) or
           (compar2(10) and compar2(9) and compar2(8) and compar2(7) and
           compar2(6) and compar2(5) and compar2(4) and compar1(3)) or 
           (compar2(10) and compar2(9) and compar2(8) and compar2(7) and
           compar2(6) and compar2(5) and compar2(4) and compar2(3) and
           compar1(2)) or (compar2(10) and compar2(9) and compar2(8) and
           compar2(7) and compar2(6) and compar2(5) and compar2(4) and
           compar2(3) and compar2(2) and compar1(1)) or (compar2(10) and
           compar2(9) and compar2(8) and compar2(7) and compar2(6) and
           compar2(5) and compar2(4) and compar2(3) and compar2(2) and
           compar2(1) and compar1(0));

-----------------------------------------------------------------------------
-- ta will hold the bigger number, a or b, depending on abtb.
-----------------------------------------------------------------------------
   ta0(0) <=(a0(0) and abtb)or(b0(0) and not(abtb));
      ta0(1) <=(a0(1) and abtb)or(b0(1) and not(abtb));
      ta0(2) <=(a0(2) and abtb)or(b0(2) and not(abtb));
      ta0(3) <=(a0(3) and abtb)or(b0(3) and not(abtb));
   ta1(0) <=(a1(0) and abtb)or(b1(0) and not(abtb));
      ta1(1) <=(a1(1) and abtb)or(b1(1) and not(abtb));
      ta1(2) <=(a1(2) and abtb)or(b1(2) and not(abtb));
      ta1(3) <=(a1(3) and abtb)or(b1(3) and not(abtb));
   ta2(0) <=(a2(0) and abtb)or(b2(0) and not(abtb));
      ta2(1) <=(a2(1) and abtb)or(b2(1) and not(abtb));
      ta2(2) <=(a2(2) and abtb)or(b2(2) and not(abtb));
      ta2(3) <=(a2(3) and abtb)or(b2(3) and not(abtb));
   ta3(0) <=(a3(0) and abtb)or(b3(0) and not(abtb));
      ta3(1) <=(a3(1) and abtb)or(b3(1) and not(abtb));
      ta3(2) <=(a3(2) and abtb)or(b3(2) and not(abtb));
      ta3(3) <=(a3(3) and abtb)or(b3(3) and not(abtb));
   ta4(0) <=(a4(0) and abtb)or(b4(0) and not(abtb));
      ta4(1) <=(a4(1) and abtb)or(b4(1) and not(abtb));
      ta4(2) <=(a4(2) and abtb)or(b4(2) and not(abtb));
      ta4(3) <=(a4(3) and abtb)or(b4(3) and not(abtb));
   ta5(0) <=(a5(0) and abtb)or(b5(0) and not(abtb));
      ta5(1) <=(a5(1) and abtb)or(b5(1) and not(abtb));
      ta5(2) <=(a5(2) and abtb)or(b5(2) and not(abtb));
      ta5(3) <=(a5(3) and abtb)or(b5(3) and not(abtb));
   ta6(0) <=(a6(0) and abtb)or(b6(0) and not(abtb));
      ta6(1) <=(a6(1) and abtb)or(b6(1) and not(abtb));
      ta6(2) <=(a6(2) and abtb)or(b6(2) and not(abtb));
      ta6(3) <=(a6(3) and abtb)or(b6(3) and not(abtb));
   ta7(0) <=(a7(0) and abtb)or(b7(0) and not(abtb));
      ta7(1) <=(a7(1) and abtb)or(b7(1) and not(abtb));
      ta7(2) <=(a7(2) and abtb)or(b7(2) and not(abtb));
      ta7(3) <=(a7(3) and abtb)or(b7(3) and not(abtb));
   ta8(0) <=(a8(0) and abtb)or(b8(0) and not(abtb));
      ta8(1) <=(a8(1) and abtb)or(b8(1) and not(abtb));
      ta8(2) <=(a8(2) and abtb)or(b8(2) and not(abtb));
      ta8(3) <=(a8(3) and abtb)or(b8(3) and not(abtb));
   ta9(0) <=(a9(0) and abtb)or(b9(0) and not(abtb));
      ta9(1) <=(a9(1) and abtb)or(b9(1) and not(abtb));
      ta9(2) <=(a9(2) and abtb)or(b9(2) and not(abtb));
      ta9(3) <=(a9(3) and abtb)or(b9(3) and not(abtb));
   ta10(0)<=(a10(0)and abtb)or(b10(0)and not(abtb));
      ta10(1)<=(a10(1)and abtb)or(b10(1)and not(abtb));
      ta10(2)<=(a10(2)and abtb)or(b10(2)and not(abtb));
      ta10(3)<=(a10(3)and abtb)or(b10(3)and not(abtb));
   tsgna <= (sgna and abtb)or((sgnb xor optype) and not(abtb));
-----------------------------------------------------------------------------
-- tb will hold the smaller number, a or b, depending on abtb.
-----------------------------------------------------------------------------
   tb0(0) <=(b0(0) and abtb)or(a0(0) and not(abtb));
      tb0(1) <=(b0(1) and abtb)or(a0(1) and not(abtb));
      tb0(2) <=(b0(2) and abtb)or(a0(2) and not(abtb));
      tb0(3) <=(b0(3) and abtb)or(a0(3) and not(abtb));
   tb1(0) <=(b1(0) and abtb)or(a1(0) and not(abtb));
      tb1(1) <=(b1(1) and abtb)or(a1(1) and not(abtb));
      tb1(2) <=(b1(2) and abtb)or(a1(2) and not(abtb));
      tb1(3) <=(b1(3) and abtb)or(a1(3) and not(abtb));
   tb2(0) <=(b2(0) and abtb)or(a2(0) and not(abtb));
      tb2(1) <=(b2(1) and abtb)or(a2(1) and not(abtb));
      tb2(2) <=(b2(2) and abtb)or(a2(2) and not(abtb));
      tb2(3) <=(b2(3) and abtb)or(a2(3) and not(abtb));
   tb3(0) <=(b3(0) and abtb)or(a3(0) and not(abtb));
      tb3(1) <=(b3(1) and abtb)or(a3(1) and not(abtb));
      tb3(2) <=(b3(2) and abtb)or(a3(2) and not(abtb));
      tb3(3) <=(b3(3) and abtb)or(a3(3) and not(abtb));
   tb4(0) <=(b4(0) and abtb)or(a4(0) and not(abtb));
      tb4(1) <=(b4(1) and abtb)or(a4(1) and not(abtb));
      tb4(2) <=(b4(2) and abtb)or(a4(2) and not(abtb));
      tb4(3) <=(b4(3) and abtb)or(a4(3) and not(abtb));
   tb5(0) <=(b5(0) and abtb)or(a5(0) and not(abtb));
      tb5(1) <=(b5(1) and abtb)or(a5(1) and not(abtb));
      tb5(2) <=(b5(2) and abtb)or(a5(2) and not(abtb));
      tb5(3) <=(b5(3) and abtb)or(a5(3) and not(abtb));
   tb6(0) <=(b6(0) and abtb)or(a6(0) and not(abtb));
      tb6(1) <=(b6(1) and abtb)or(a6(1) and not(abtb));
      tb6(2) <=(b6(2) and abtb)or(a6(2) and not(abtb));
      tb6(3) <=(b6(3) and abtb)or(a6(3) and not(abtb));
   tb7(0) <=(b7(0) and abtb)or(a7(0) and not(abtb));
      tb7(1) <=(b7(1) and abtb)or(a7(1) and not(abtb));
      tb7(2) <=(b7(2) and abtb)or(a7(2) and not(abtb));
      tb7(3) <=(b7(3) and abtb)or(a7(3) and not(abtb));
   tb8(0) <=(b8(0) and abtb)or(a8(0) and not(abtb));
      tb8(1) <=(b8(1) and abtb)or(a8(1) and not(abtb));
      tb8(2) <=(b8(2) and abtb)or(a8(2) and not(abtb));
      tb8(3) <=(b8(3) and abtb)or(a8(3) and not(abtb));
   tb9(0) <=(b9(0) and abtb)or(a9(0) and not(abtb));
      tb9(1) <=(b9(1) and abtb)or(a9(1) and not(abtb));
      tb9(2) <=(b9(2) and abtb)or(a9(2) and not(abtb));
      tb9(3) <=(b9(3) and abtb)or(a9(3) and not(abtb));
   tb10(0)<=(b10(0)and abtb)or(a10(0)and not(abtb));
      tb10(1)<=(b10(1)and abtb)or(a10(1)and not(abtb));
      tb10(2)<=(b10(2)and abtb)or(a10(2)and not(abtb));
      tb10(3)<=(b10(3)and abtb)or(a10(3)and not(abtb));
   tsgnb <= ((sgnb xor optype) and abtb)or(sgna and not(abtb));
-----------------------------------------------------------------------------
-- We perform the operations on ta and tb and store the result in c.
-----------------------------------------------------------------------------
   p11: or1op_core port map (
      carryin => carryin,
      a10 => ta10, a9  => ta9 , a8  => ta8 , a7  => ta7 , a6  => ta6 ,
      a5  => ta5 , a4  => ta4 , a3  => ta3 , a2  => ta2 , a1  => ta1 ,
      a0  => ta0,
      b10 => tb10, b9  => tb9 , b8  => tb8 , b7  => tb7 , b6  => tb6 ,
      b5  => tb5 , b4  => tb4 , b3  => tb3 , b2  => tb2 , b1  => tb1 ,
      b0  => tb0 ,
      sgna => tsgna, sgnb => tsgnb, optype => '0',
      c10 =>  c10, c9  => c9  , c8  => c8  , c7  => c7  , c6  => c6  ,
      c5  =>  c5 , c4  => c4  , c3  => c3  , c2  => c2  , c1  => c1  ,
      c0  =>  c0 ,
      carryout => carryout,
      sgnc => sgnc
   );
end architecture;
