-----------------------------------------------------------------------------
--FILENAME        : reg44b.vhd
--DESCRIPTION     : a register that holds a 44bit number; has an asynchronous
--                  reset
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg44b is
   port (
      a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
         in std_logic_vector(3 downto 0);
      res, clk: in std_logic; 
      b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0:
         out std_logic_vector(3 downto 0)
   );
end entity;

architecture reg44b_arh of reg44b is
begin			 
   process(res, clk)
      variable t10, t9, t8, t7, t6, t5, t4, t3, t2, t1, t0:
         std_logic_vector(3 downto 0);
   begin																			   
      if (res = '1') then
         t10 := "0000";
         t9  := "0000";
         t8  := "0000";
         t7  := "0000";
         t6  := "0000";
         t5  := "0000";
         t4  := "0000";
         t3  := "0000";
         t2  := "0000";
         t1  := "0000";
         t0  := "0000";
      else
         if (clk'event) and (clk = '1') then
            t10 := a10;
            t9  := a9;
            t8  := a8;
            t7  := a7;
            t6  := a6;
            t5  := a5;
            t4  := a4;
            t3  := a3;
            t2  := a2;
            t1  := a1;
            t0  := a0;
         end if;
      end if;
      b10 <= t10;
      b9  <= t9;
      b8  <= t8;
      b7  <= t7;
      b6  <= t6;
      b5  <= t5;
      b4  <= t4;
      b3  <= t3;
      b2  <= t2;
      b1  <= t1;
      b0  <= t0;
   end process;
end architecture;