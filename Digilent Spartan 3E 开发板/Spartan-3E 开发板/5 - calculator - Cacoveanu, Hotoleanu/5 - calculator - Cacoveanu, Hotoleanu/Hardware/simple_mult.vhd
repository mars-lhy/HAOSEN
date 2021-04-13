-----------------------------------------------------------------------------
--FILENAME        : simple_mult.vhd
--DESCRIPTION     : multiplyes a 4bit number with a 1bit value and returns
--                  the result as a 4bit number
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity simple_mult is
   port(
      a: in std_logic_vector(3 downto 0);
      b: in std_logic;
      r: out std_logic_vector(3 downto 0)
   );
end entity;
architecture simple_mult_arh of simple_mult is
begin
   r(0) <= a(0) and b;
   r(1) <= a(1) and b;
   r(2) <= a(2) and b;
   r(3) <= a(3) and b;
end;