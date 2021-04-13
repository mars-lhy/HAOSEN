-----------------------------------------------------------------------------
--FILENAME        : dffres.vhd
--DESCRIPTION     : a d flip-flop with asynchronous reset
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dffres is
   port (
      d, clk, r: in std_logic;
      q: out std_logic
   );
end entity;

architecture dffres_arh of dffres is
begin			 
   process(clk, r)
      variable t: std_logic;
   begin
      if (r = '1') then
         t:='0';
      else
         if (clk'event) and (clk = '1') then
            t := d;
         end if;
      end if;
      q <= t;
   end process;
end architecture;