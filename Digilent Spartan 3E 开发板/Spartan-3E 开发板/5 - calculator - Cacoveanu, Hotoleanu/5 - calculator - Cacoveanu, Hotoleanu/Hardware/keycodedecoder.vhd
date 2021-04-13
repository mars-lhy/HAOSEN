-----------------------------------------------------------------------------
--FILENAME        : keycodedecoder.vhd
--DESCRIPTION     : this component receves a keyboard key code on 8 bits and
--                  returns the code of the number or operation pressed.
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 29.09.2006 - created
--                  30.09.2006 - keyboard codes added
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity keycodedecoder is
   port (
      keycode: in std_logic_vector(7 downto 0);
      inflag: in std_logic;
      binarycode: out std_logic_vector(3 downto 0);
      outflag: out std_logic
   );
end entity;

architecture keycodedecoder_arh of keycodedecoder is
begin                
   process (keycode)
   begin       
      case keycode is
         when "01110000" => binarycode <= "0000"; -- digit 0
         when "01101001" => binarycode <= "0001"; -- digit 1
         when "01110010" => binarycode <= "0010"; -- digit 2
         when "01111010" => binarycode <= "0011"; -- digit 3
         when "01101011" => binarycode <= "0100"; -- digit 4
         when "01110011" => binarycode <= "0101"; -- digit 5
         when "01110100" => binarycode <= "0110"; -- digit 6
         when "01101100" => binarycode <= "0111"; -- digit 7
         when "01110101" => binarycode <= "1000"; -- digit 8
         when "01111101" => binarycode <= "1001"; -- digit 9

         when "01111001" => binarycode <= "1010"; -- +
         when "01111011" => binarycode <= "1011"; -- -
         when "01111100" => binarycode <= "1100"; -- *
         when "01001010" => binarycode <= "1101"; -- /

         when others => binarycode <= "1111";
      end case;
   end process;
   outflag <= inflag;
end architecture;

