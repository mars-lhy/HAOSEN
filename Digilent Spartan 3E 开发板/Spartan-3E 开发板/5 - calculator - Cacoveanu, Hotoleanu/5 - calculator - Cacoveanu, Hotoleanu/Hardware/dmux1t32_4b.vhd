-----------------------------------------------------------------------------
--FILENAME        : dmux1t32_4b.vhd
--DESCRIPTION     : a 4bit 1 to 32 demultiplexer with enable
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
--                  formerly dmux_router
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dmux1t32_4b is
   port(                                 
      e: in std_logic;
      a: in std_logic_vector(3 downto 0);
      sel: in std_logic_vector(4 downto 0);                
      b31, b30, b29, b28, b27, b26, b25, b24, b23, b22, b21, b20, b19, b18,
      b17, b16, b15, b14, b13, b12, b11, b10, b9 , b8 , b7 , b6 , b5 , b4 ,
      b3 , b2 , b1 , b0 : out std_logic_vector(3 downto 0)
   );
end entity;

architecture dmux1t32_4b_arh of dmux1t32_4b is
-----------------------------------------------------------------------------
-- We use 4 1 to 32 demultiplexers.
-----------------------------------------------------------------------------
   component dmux1t32 is
      port (
         a, e: in std_logic;
         c: in std_logic_vector(4 downto 0);
         b31, b30, b29, b28, b27, b26, b25, b24, b23, b22, b21, b20, b19, b18,
         b17, b16, b15, b14, b13, b12, b11, b10, b9 , b8 , b7 , b6 , b5 , b4 ,
         b3 , b2 , b1 , b0 : out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal u: std_logic_vector(39 downto 0);
   signal note: std_logic;
begin							   
   c1: dmux1t32 port map (
         a => a(0), e => e,
         c => sel,
         b31 => b31(0), b30 => b30(0), b29 => b29(0), b28 => b28(0),
         b27 => b27(0), b26 => b26(0), b25 => b25(0), b24 => b24(0),
         b23 => b23(0), b22 => b22(0), b21 => b21(0), b20 => b20(0),
         b19 => b19(0), b18 => b18(0), b17 => b17(0), b16 => b16(0),
         b15 => b15(0), b14 => b14(0), b13 => b13(0), b12 => b12(0),
         b11 => b11(0), b10 => b10(0), b9  =>  b9(0), b8  =>  b8(0),
         b7  =>  b7(0), b6  =>  b6(0), b5  =>  b5(0), b4  =>  b4(0),
         b3  =>  b3(0), b2  =>  b2(0), b1  =>  b1(0), b0  =>  b0(0)
   );
   c2: dmux1t32 port map (
         a => a(1), e => e,
         c => sel,
         b31 => b31(1), b30 => b30(1), b29 => b29(1), b28 => b28(1),
         b27 => b27(1), b26 => b26(1), b25 => b25(1), b24 => b24(1),
         b23 => b23(1), b22 => b22(1), b21 => b21(1), b20 => b20(1),
         b19 => b19(1), b18 => b18(1), b17 => b17(1), b16 => b16(1),
         b15 => b15(1), b14 => b14(1), b13 => b13(1), b12 => b12(1),
         b11 => b11(1), b10 => b10(1), b9  =>  b9(1), b8  =>  b8(1),
         b7  =>  b7(1), b6  =>  b6(1), b5  =>  b5(1), b4  =>  b4(1),
         b3  =>  b3(1), b2  =>  b2(1), b1  =>  b1(1), b0  =>  b0(1)
   );
   c3: dmux1t32 port map (
         a => a(2), e => e,
         c => sel,
         b31 => b31(2), b30 => b30(2), b29 => b29(2), b28 => b28(2),
         b27 => b27(2), b26 => b26(2), b25 => b25(2), b24 => b24(2),
         b23 => b23(2), b22 => b22(2), b21 => b21(2), b20 => b20(2),
         b19 => b19(2), b18 => b18(2), b17 => b17(2), b16 => b16(2),
         b15 => b15(2), b14 => b14(2), b13 => b13(2), b12 => b12(2),
         b11 => b11(2), b10 => b10(2), b9  =>  b9(2), b8  =>  b8(2),
         b7  =>  b7(2), b6  =>  b6(2), b5  =>  b5(2), b4  =>  b4(2),
         b3  =>  b3(2), b2  =>  b2(2), b1  =>  b1(2), b0  =>  b0(2)
   );
   c4: dmux1t32 port map (
         a => a(3), e => e,
         c => sel,
         b31 => b31(3), b30 => b30(3), b29 => b29(3), b28 => b28(3),
         b27 => b27(3), b26 => b26(3), b25 => b25(3), b24 => b24(3),
         b23 => b23(3), b22 => b22(3), b21 => b21(3), b20 => b20(3),
         b19 => b19(3), b18 => b18(3), b17 => b17(3), b16 => b16(3),
         b15 => b15(3), b14 => b14(3), b13 => b13(3), b12 => b12(3),
         b11 => b11(3), b10 => b10(3), b9  =>  b9(3), b8  =>  b8(3),
         b7  =>  b7(3), b6  =>  b6(3), b5  =>  b5(3), b4  =>  b4(3),
         b3  =>  b3(3), b2  =>  b2(3), b1  =>  b1(3), b0  =>  b0(3)
   );

end architecture;
