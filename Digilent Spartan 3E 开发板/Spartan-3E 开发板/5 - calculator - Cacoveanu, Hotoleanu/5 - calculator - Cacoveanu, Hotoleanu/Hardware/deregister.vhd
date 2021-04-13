-----------------------------------------------------------------------------
--FILENAME        : deregister.vhd
--DESCRIPTION     : the register storing incoming numbers and the opperation
--                  to be performed on them
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 29.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity deregister is
   port (
      datain: in std_logic_vector(3 downto 0);
      clk, reset: in std_logic;
      nra10, nra9, nra8, nra7, nra6, nra5, nra4, nra3, nra2, nra1, nra0:
         out std_logic_vector(3 downto 0);
      nrb10, nrb9, nrb8, nrb7, nrb6, nrb5, nrb4, nrb3, nrb2, nrb1, nrb0:
         out std_logic_vector(3 downto 0);
      sgna, sgnb: out std_logic;
      optype: out std_logic_vector(1 downto 0);
      ready_flag: out std_logic
   );
end entity;
-----------------------------------------------------------------------------
-- Digits form 0 to 9 are stored by their corresponding binary
-- representations.
-- signs plus or minus are stored into the number, given as the most
-- significant digit:
-- 1010     +
-- 1011     -
-- the operation cames between the two numbers (as the 13th group of four
-- bits received by the register) and are codifyed as:
-- 1010     +
-- 1011     -
-- 1100     *
-- 1101     /
-- inside the register, these operations are codifyed on two bits, as:
-- 00       +
-- 01       -
-- 10       *
-- 11       /
-----------------------------------------------------------------------------
architecture deregister_arh of deregister is
begin           
   process (clk, reset)
      variable tnra10, tnra9, tnra8, tnra7, tnra6, tnra5, tnra4, tnra3, tnra2,
               tnra1, tnra0: std_logic_vector(3 downto 0);
      variable tnrb10, tnrb9, tnrb8, tnrb7, tnrb6, tnrb5, tnrb4, tnrb3, tnrb2,
               tnrb1, tnrb0: std_logic_vector(3 downto 0);
      variable tsgna, tsgnb: std_logic;
      variable toptype: std_logic_vector(1 downto 0);
      variable tready_flag: std_logic;
      variable state: std_logic_vector(4 downto 0);
   begin       
      if (reset = '1') then
         tnra10 := "0000"; tnra9 := "0000"; tnra8 := "0000"; tnra7 := "0000"; 
         tnra6  := "0000"; tnra5 := "0000"; tnra4 := "0000"; tnra3 := "0000";
         tnra2  := "0000"; tnra1 := "0000"; tnra0 := "0000";
         tnrb10 := "0000"; tnrb9 := "0000"; tnrb8 := "0000"; tnrb7 := "0000"; 
         tnrb6  := "0000"; tnrb5 := "0000"; tnrb4 := "0000"; tnrb3 := "0000";
         tnrb2  := "0000"; tnrb1 := "0000"; tnrb0 := "0000";
         tsgna := '0'; tsgnb := '0';
         toptype := "00";
         tready_flag := '0';
         state := "00000";
      elsif (clk'event) and (clk = '0') then
         case state is
-----------------------------------------------------------------------------
-- In the first 12 states we store the first number and its sign.
-----------------------------------------------------------------------------
            when "00000" => tnra0  := datain; state := "00001";
            when "00001" => tnra1  := datain; state := "00010";
            when "00010" => tnra2  := datain; state := "00011";
            when "00011" => tnra3  := datain; state := "00100";
            when "00100" => tnra4  := datain; state := "00101";
            when "00101" => tnra5  := datain; state := "00110";
            when "00110" => tnra6  := datain; state := "00111";
            when "00111" => tnra7  := datain; state := "01000";
            when "01000" => tnra8  := datain; state := "01001";
            when "01001" => tnra9  := datain; state := "01010";
            when "01010" => tnra10 := datain; state := "01011";
            when "01011" =>
               if datain = "1010" then
                  tsgna := '0';
               elsif datain = "1011" then
                  tsgna := '1';
               else
                  tsgna := '0';
               end if;
               state := "01100";
-----------------------------------------------------------------------------
-- In the 12th state we store the operation to be performed on the numbers.
-----------------------------------------------------------------------------
            when "01100" =>
               case datain is
                  when "1010" => toptype := "00";
                  when "1011" => toptype := "01";
                  when "1100" => toptype := "10";
                  when "1101" => toptype := "11";
                  when others => null;
               end case;                       
               state := "01101";
-----------------------------------------------------------------------------
-- In states 13 to 25 we store the second number and its sign.
-----------------------------------------------------------------------------
            when "01101" => tnrb0  := datain; state := "01110";
            when "01110" => tnrb1  := datain; state := "01111";
            when "01111" => tnrb2  := datain; state := "10000";
            when "10000" => tnrb3  := datain; state := "10001";
            when "10001" => tnrb4  := datain; state := "10010";
            when "10010" => tnrb5  := datain; state := "10011";
            when "10011" => tnrb6  := datain; state := "10100";
            when "10100" => tnrb7  := datain; state := "10101";
            when "10101" => tnrb8  := datain; state := "10110";
            when "10110" => tnrb9  := datain; state := "10111";
            when "10111" => tnrb10 := datain; state := "11000";
            when "11000" =>    
               if datain = "1010" then
                  tsgnb := '0';
               elsif datain = "1011" then
                  tsgnb := '1';
               else
                  tsgnb := '0';
               end if;
               state := "11001";
               tready_flag := '1';
            when "11001" => state := "11001";
            when others => null;
         end case;
      end if;
      nra10 <= tnra10; nra9 <= tnra9; nra8 <= tnra8; nra7 <= tnra7;
      nra6  <= tnra6 ; nra5 <= tnra5; nra4 <= tnra4; nra3 <= tnra3;
      nra2  <= tnra2 ; nra1 <= tnra1; nra0 <= tnra0;
      nrb10 <= tnrb10; nrb9 <= tnrb9; nrb8 <= tnrb8; nrb7 <= tnrb7;
      nrb6  <= tnrb6 ; nrb5 <= tnrb5; nrb4 <= tnrb4; nrb3 <= tnrb3;
      nrb2  <= tnrb2 ; nrb1 <= tnrb1; nrb0 <= tnrb0;
      sgna <= tsgna; sgnb <= tsgnb; optype <= toptype;
      ready_flag <= tready_flag;
   end process;
end architecture;