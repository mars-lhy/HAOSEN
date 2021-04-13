-----------------------------------------------------------------------------
--FILENAME        : dmux1t32.vhd
--DESCRIPTION     : a 1 to 32 demultiplexer
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dmux1t32 is
   port (
      a, e: in std_logic;
      c: in std_logic_vector(4 downto 0);
      b31, b30, b29, b28, b27, b26, b25, b24, b23, b22, b21, b20, b19, b18,
      b17, b16, b15, b14, b13, b12, b11, b10, b9 , b8 , b7 , b6 , b5 , b4 ,
      b3 , b2 , b1 , b0 : out std_logic
   );
end entity;

architecture dmux1t32_arh of dmux1t32 is
-----------------------------------------------------------------------------
-- We use two 1 to 16 demultiplexers.
-----------------------------------------------------------------------------
   component dmux1t16 is
      port (
         a, e: in std_logic;
         c: std_logic_vector(3 downto 0);
         b0, b1, b2, b3, b4, b5, b6, b7, b8, b9 ,b10, b11, b12, b13, b14, b15:
            out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal enable1, enable2: std_logic;
begin                       
-----------------------------------------------------------------------------
-- We compute the enable signals for the two demultiplexers.
-----------------------------------------------------------------------------
   enable1 <= e and not(c(4));
   enable2 <= e and     c(4) ;
-----------------------------------------------------------------------------
-- We link the two multiplexers to the entrance and exit pins.
-----------------------------------------------------------------------------
   c1: dmux1t16 port map (
      a => a, e => enable1,
      c => c(3 downto 0),
      b0  => b0 , b1  => b1 , b2  => b2 , b3  => b3 , b4  => b4 , b5  => b5 ,
      b6  => b6 , b7  => b7 , b8  => b8 , b9  => b9 , b10 => b10, b11 => b11,
      b12 => b12, b13 => b13, b14 => b14, b15 => b15
   );
   c2: dmux1t16 port map (
      a => a, e => enable2,
      c => c(3 downto 0),
      b0  => b16, b1  => b17, b2  => b18, b3  => b19, b4  => b20, b5  => b21,
      b6  => b22, b7  => b23, b8  => b24, b9  => b25, b10 => b26, b11 => b27,
      b12 => b28, b13 => b29, b14 => b30, b15 => b31
   );
end architecture;