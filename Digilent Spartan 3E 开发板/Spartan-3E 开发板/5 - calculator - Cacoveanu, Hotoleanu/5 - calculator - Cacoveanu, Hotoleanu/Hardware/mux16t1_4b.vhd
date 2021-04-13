-----------------------------------------------------------------------------
--FILENAME        : mux16t1.vhd
--DESCRIPTION     : a 16 to 1 multiplexer on 1 bit
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
--                  former router_1dig
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux16t1_4b is
   port(
      a15, a14, a13, a12, a11, a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
         in std_logic_vector(3 downto 0);
      route: in std_logic_vector(3 downto 0);
      b: out std_logic_vector(3 downto 0)
   );
end entity;

architecture mux16t1_4b_arh of mux16t1_4b is
begin
   process(a15, a14, a13, a12, a11, a10, a9, a8, a7, a6, a5, a4, a3, a2, a1,
           a0, route)
   begin
      case route is
         when "0000" => b <= a0;
         when "0001" => b <= a1;
         when "0010" => b <= a2;
         when "0011" => b <= a3;
         when "0100" => b <= a4;
         when "0101" => b <= a5;
         when "0110" => b <= a6;
         when "0111" => b <= a7;
         when "1000" => b <= a8;
         when "1001" => b <= a9;
         when "1010" => b <= a10;
         when "1011" => b <= a11;
         when "1100" => b <= a12;
         when "1101" => b <= a13;
         when "1110" => b <= a14;
         when "1111" => b <= a15;
         when others => null;
      end case;
   end process; 
end architecture;