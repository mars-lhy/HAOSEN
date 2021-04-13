------------------------------------------------------------------------
-- resolution_switcher.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the logic to change the used resolution by
-- pressing a key combination on the keyboard.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- Places the code for the currently selected resolution on the
-- resolution output pin. If 640x480 is selected places '0' on this
-- output, else if 800x600 is selected, places '1' on it.
-- When changing the resolution (even if the same resolution is
-- selected) then, set high output switch for one clock period, to
-- inform listeners to the resolution change.
-- 640x480 is selected by pressing the CTRL (left, right or both) + 1
-- key combination
-- 800x600 is selected by pressing the CTRL (left, right or both) + 2
-- key combination
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk            - global clock signal
-- rst            - global reset signal
-- ctrl           - input pin, from keyboard_controller
--                - indicates state of the control key (pressed or not)
-- ascii          - input pin, 7 bits, from keyboard_controller
--                - ascii code of the most recently pressed or released
--                - key (or 00h if it has none).
-- ready          - input pin, from keyboard_controller
--                - active for one clock period when a new key event
--                - occurs
-- switch         - output pin, to clients
--                - active for one clock period when resolution changes.
-- resolution     - output pin, to clients
--                - '0' if 640x480 is selected
--                - '1' if 800x600 is selected
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

-- the resolution_switcher entity declaration
-- read above for behavioral description and port definitions.
entity resolution_switcher is
port(
   clk         : in std_logic;
   rst         : in std_logic;

   ctrl        : in std_logic;
   ascii       : in std_logic_vector(6 downto 0);
   ready       : in std_logic;

   switch      : out std_logic;
   resolution  : out std_logic
);
end resolution_switcher;

architecture Behavioral of resolution_switcher is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- constants defining the value for the resolution output depending
-- on the currently selected resolution.
constant RES_640  : std_logic := '0';
constant RES_800  : std_logic := '1';

-- ascii code for numbers 1 and 2
constant ASCII_1  : std_logic_vector(6 downto 0) := "0110001"; -- 0x31
constant ASCII_2  : std_logic_vector(6 downto 0) := "0110010"; -- 0x32

begin

   -- if reset occurs, set the 640x480 resolution and inform clients
   -- else if, new key event occurs, if control is down and
   -- key 1 is pressed switch to 640x480 resolution, else ctrl + 2 is
   -- pressed switch to 800x600 resolution.
   switch_resolution: process(clk,rst)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            switch <= '1';
            resolution <= RES_640;
         elsif(ready = '1') then
            if(ctrl = '1') then
               if(ascii = ASCII_1) then
                  resolution <= RES_640;
                  switch <= '1';
               elsif(ascii = ASCII_2) then
                  resolution <= RES_800;
                  switch <= '1';
               else
                  switch <= '0';
               end if;              
            else
               switch <= '0';
            end if;
         else
            switch <= '0';
         end if;
      end if;
   end process switch_resolution;

end Behavioral;