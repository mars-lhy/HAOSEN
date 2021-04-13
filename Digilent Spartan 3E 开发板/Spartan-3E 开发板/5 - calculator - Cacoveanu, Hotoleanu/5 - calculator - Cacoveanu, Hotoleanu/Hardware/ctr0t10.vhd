-----------------------------------------------------------------------------
--FILENAME        : ctr0t10.vhd
--DESCRIPTION     : a counter going from 0 to 10
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ctr0t10 is
   port (
      res, clk: in std_logic;
      o: out std_logic_vector(3 downto 0)
   );
end entity;

architecture ctr0t10_arh of ctr0t10 is
begin
   process(clk, res)
      variable t: std_logic_vector(3 downto 0);
   begin									 
      if (res = '1') then
         t := "0000";
      else
         if (clk'event) and (clk = '1') then
            case t is
               when "0000" => t := "0001";
               when "0001" => t := "0010";
               when "0010" => t := "0011";
               when "0011" => t := "0100";
               when "0100" => t := "0101";
               when "0101" => t := "0110";
               when "0110" => t := "0111";
               when "0111" => t := "1000";
               when "1000" => t := "1001";
               when "1001" => t := "1010";
               when "1010" => t := "0000";
               when "1011" => t := "0000";
               when "1100" => t := "0000";
               when "1101" => t := "0000";
               when "1110" => t := "0000";
               when "1111" => t := "0000";
               when others => null;
            end case;
         end if;
      end if;
      o <= t;
   end process;
end;