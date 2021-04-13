------------------------------------------------------------------------
-- request_controller.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the logic to register a request with the epp
-- controller when a certain key is pressed, request that will be sent
-- to the software running on the connected computer next time it will
-- poll for a request.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- If a new key event is received from the keyboard_controller, check
-- if it is a MAKE event. If it is not, ignore the event, else, if the
-- SPACE key was pressed, then register with the epp controller the
-- request to send the next image. If the BACKSPACE was pressed then
-- request previous image. If Q was pressed request start of live feed
-- from a camera. If A was pressed request stop of live feed. Any other
-- key is ignored.
-- A request is registered with the epp controller by placing the
-- desired request on the request_out output pins and setting high
-- for one clock period the new_request_out pin.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk            - global clock signal
-- ascii_in       - input pin, 7 bits, from keyboard_controller
--                - ascii code for the most recently pressed of released
--                - key.
-- event_type_in  - input pin, from keyboard controller
--                - indicates type of event that occurred
--                - '0' for a MAKE  event
--                - '1' for a BREAK event
-- ready_in       - input pin, from keyboard_controller
--                - active for one clock period when new event occurred
--                - and ascii is available on the ascii_in pins.
-- request_out    - output pin, 3 bits, to the epp_controller
--                - the code of the desired request.
-- new_request_out - output pin, to epp_controller
--                - active for one clock period when sending a new
--                - request and request is valid on request_out pins.
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

-- the request_controller entity declaration
-- read above for behavioral description and port definitions.
entity request_controller is
port(
   clk               : in std_logic;
   ascii_in          : in std_logic_vector(6 downto 0);
   event_type_in     : in std_logic;
   ready_in          : in std_logic;

   request_out       : out std_logic_vector(2 downto 0);
   new_request_out   : out std_logic
);
end request_controller;

architecture Behavioral of request_controller is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- ascii codes of keys space, backspace, q and a.
constant SPACE    : std_logic_vector(6 downto 0) := "0100000"; -- 0x20
constant BACKSPACE: std_logic_vector(6 downto 0) := "0001000"; -- 0x08
constant LETTER_Q : std_logic_vector(6 downto 0) := "1110001"; -- 0x71
constant LETTER_A : std_logic_vector(6 downto 0) := "1100001"; -- 0x61

-- command sent to the computer software through the epp interface
-- to send the next image, the previous image, to start the live
-- video feed from the webcam or to stop the live feed.
constant NEXT_IMAGE  : std_logic_vector(2 downto 0) := "001"; -- 1
constant PREV_IMAGE  : std_logic_vector(2 downto 0) := "010"; -- 2
constant START_VIDEO : std_logic_vector(2 downto 0) := "011"; -- 3
constant STOP_VIDEO  : std_logic_vector(2 downto 0) := "100"; -- 4

-- types of key events that can occur.
constant MAKE_EVENT  : std_logic := '0';
constant BREAK_EVENT : std_logic := '1';

begin

   -- wait for a new key event from the keyboard controller
   -- if a MAKE event occurs for the q key, then send a request
   -- to the computer software through the epp interface to
   -- send the next image. Similarly for the A,space and backspace keys
   do_request: process(clk)
   begin
      if(rising_edge(clk)) then  
         if(ready_in = '1') then
            if(ascii_in = LETTER_Q and event_type_in = MAKE_EVENT)
            then
               request_out <= START_VIDEO;
               new_request_out <= '1';
            elsif(ascii_in = LETTER_A and event_type_in = MAKE_EVENT)
            then
               request_out <= STOP_VIDEO;
               new_request_out <= '1';
            elsif(ascii_in = SPACE and event_type_in = MAKE_EVENT)
            then
               request_out <= NEXT_IMAGE;
               new_request_out <= '1';
            elsif(ascii_in = BACKSPACE and event_type_in = MAKE_EVENT)
            then
               request_out <= PREV_IMAGE;
               new_request_out <= '1';
            end if;
         else
            new_request_out <= '0';
         end if;
      end if;
   end process do_request;

end Behavioral;