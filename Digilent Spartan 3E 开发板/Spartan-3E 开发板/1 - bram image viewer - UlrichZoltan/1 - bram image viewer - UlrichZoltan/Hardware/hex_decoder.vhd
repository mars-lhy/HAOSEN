------------------------------------------------------------------------
-- hex_decoder.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the design for a 7 segment LED Display Controller.
-- It displays the received data on input pins, in hexadecimal format.
-- It generates the needed segment signals (negative logic - for common 
-- anode 7 segment LED Display), as well as anode select signals
-- (negative logic - for inverting buffer circuit) for 4 digits.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- The counter "s" divides the system clock (100MHz) by 2^21 = 2097152.
-- The display refresh rate is 100MHz/2^21 = 47.68Hz(avoids flickering)
-- The display refresh period is 1/47.68Hz = 20.97ms.
-- Each digit is active for a period of 20.97ms/4 = 5.24ms.
-- The two MSBs of "s" are decoded to generate the anode signals.
-- Decimal point is disabled by making most significant bit of output
-- "display" high.
--
-- The segment encoding - the numbers represent the bit position in
-- "display" for the coresponding segment
-- A segment is active when its coresponding bit is set low.
--      0
--     ---  
--  5 |   | 1
--     -6- 
--  4 |   | 2
--     --- 
--      3
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk         - global clock input with frequency of 100MHz
-- datain1     - input pin, 8 bits, data to be displayed of the right
--             - most 2 7-segment displays. bits 0-3 will be displayed
--             - on the right most segments and bits 4-7 on the second
--             - display from right.
-- datain2     - input pin, 8 bits, data to be displayed of the left
--             - most 2 7-segment displays. bits 0-3 will be displayed
--             - on the second display from left and bits 4-7 on the
--             - left most display.
--
-- datain2(7:0) datain2(3:0) datain1(7:4) datain1(3:0)
--     ---          ---          ---          ---
--    |   |        |   |        |   |        |   |
--     ---          ---          ---          ---
--    |   |        |   |        |   |        |   |
--     ---.         ---.         ---.         ---.
--
-- display_sseg- output pin, 8 bits, data to be sent to the currently
--             - active display. Most significant bit is decimal point.
--             - dp,g,f,e,d,c,b,a (7 downto 0)
-- anodes      - output pin, 4 bits, select the currently active display
--             - display is enabled when coresponding bit is low
--             - ex: 1011 enables second display from left.
------------------------------------------------------------------------
-- Revision History:
-- 09/18/2006(UlrichZ): created
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- simulation library
library UNISIM;
use UNISIM.VComponents.all;

-- the hex_decoder entity declaration
-- read above for behavioral description and port definitions.
entity hex_decoder is
port(
   clk         : in std_logic;
   datain1     : in std_logic_vector(7 downto 0);
   datain2     : in std_logic_vector(7 downto 0);
   display_sseg: out std_logic_vector(7 downto 0); -- dp,g,f,e,d,c,b,a
   anodes      : out std_logic_vector(3 downto 0)
);

-- attributes used to prevent the synthesizer from placing segment
-- encoding in a read-only block ram, all block ram resources
-- being used for the storing the image.
attribute rom_extract : string;
attribute rom_extract of hex_decoder: entity is "no";

end hex_decoder;

architecture Behavioral of hex_decoder is

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

-- 21 bit counter used to obtain the display frequency
signal s: std_logic_vector(20 downto 0) := (others => '0');
-- value of anodes decoded from the most significant 2 bits of "s"
signal temp_anodes: std_logic_vector(3 downto 0) := (others => '0');
-- the 4 bits from datain1 or datain2, that represent the currently
-- displayed number.
signal muxout: std_logic_vector(3 downto 0) := (others => '0');
-- 7 bits that represent the state of the segments for current number,
-- excluding the decimal point, which is always disabled. Segment active
-- when corresponding bit is '0'.
signal display: std_logic_vector(6 downto 0) := (others => '0');

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- encoding of the numbers in hexadecimal
constant d0       : std_logic_vector(6 downto 0) := "1000000";
constant d1       : std_logic_vector(6 downto 0) := "1111001";
constant d2       : std_logic_vector(6 downto 0) := "0100100";
constant d3       : std_logic_vector(6 downto 0) := "0110000";
constant d4       : std_logic_vector(6 downto 0) := "0011001";
constant d5       : std_logic_vector(6 downto 0) := "0010010";
constant d6       : std_logic_vector(6 downto 0) := "0000010";
constant d7       : std_logic_vector(6 downto 0) := "1111000";
constant d8       : std_logic_vector(6 downto 0) := "0000000";
constant d9       : std_logic_vector(6 downto 0) := "0010000";
constant da       : std_logic_vector(6 downto 0) := "0001000";
constant db       : std_logic_vector(6 downto 0) := "0000011";
constant dc       : std_logic_vector(6 downto 0) := "1000110";
constant dd       : std_logic_vector(6 downto 0) := "0100001";
constant de       : std_logic_vector(6 downto 0) := "0000110";
constant df       : std_logic_vector(6 downto 0) := "0001110";
-- disable current display
constant nothing  : std_logic_vector(6 downto 0) := "1111111";

begin

   -- division of the system clock using a 21 bit counter
   slow_clock: process(clk)
   begin
      if(rising_edge(clk)) then
         s <= s + 1;
      end if;
   end process slow_clock;

   -- select the current active display by decoding
   -- most significant 2 bits from "s"
   process(s)
   begin
      if(s(20 downto 19) = "00") then
         temp_anodes <= "1110";
      elsif(s(20 downto 19) = "01") then
         temp_anodes <= "1101";
      elsif(s(20 downto 19) = "10") then
         temp_anodes <= "1011";
      elsif(s(20 downto 19) = "11") then
         temp_anodes <= "0111";
      else
         temp_anodes <= "1111";
      end if;
   end process;

   -- selects 4 bits from datain to decode the currently displayed
   -- number according to the active anod
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(temp_anodes = "1110") then
            muxout <= datain1(3 downto 0);
         elsif(temp_anodes = "1101") then
            muxout <= datain1(7 downto 4);
         elsif(temp_anodes = "1011") then
            muxout <= datain2(3 downto 0);
         elsif(temp_anodes = "0111") then
            muxout <= datain2(7 downto 4);
         end if;
      end if;
   end process;
   
   -- decodes the segments to be activated
   -- from the 4 bits representing the current number
   process(clk)
   begin
      if(rising_edge(clk)) then
         case muxout is
            when "0000" =>
               display <= d0;
            when "0001" =>
               display <= d1;
            when "0010" =>
               display <= d2;
            when "0011" =>
               display <= d3;
            when "0100" =>
               display <= d4;
            when "0101" =>
               display <= d5;
            when "0110" =>
               display <= d6;
            when "0111" =>
               display <= d7;
            when "1000" =>
               display <= d8;
            when "1001" =>
               display <= d9;
            when "1010" =>
               display <= da;
            when "1011" =>
               display <= db;
            when "1100" =>
               display <= dc;
            when "1101" =>
               display <= dd;
            when "1110" =>
               display <= de;
            when "1111" =>
               display <= df;
            when others =>
               display <= nothing;
         end case;
      end if;
   end process;   

   anodes <= temp_anodes;
   
   -- disable decimal point (dp, active low)
   display_sseg <= '1' & display;

end Behavioral;