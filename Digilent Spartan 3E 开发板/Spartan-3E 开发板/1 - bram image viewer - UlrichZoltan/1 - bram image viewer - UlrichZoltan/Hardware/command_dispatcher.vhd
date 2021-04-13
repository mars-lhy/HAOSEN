------------------------------------------------------------------------
-- command_dispatcher.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the logic that interprets commands for the
-- software running on a computer connected to the fpga and generates
-- the appropriate signals for its client, namely image_controller and
-- image_motion_controller.
-- This component is a client for the epp_controller.
-- The epp_controller exchanges bytes with the connected computer (which
-- must run the corresponding provided software, or another user made
-- software that implements the protocol for image transfer as this
-- design does) on certain addresses. The epp_controller forwards bytes
-- received from the computer to its clients i.e. the command_dispatcher
-- The epp_controller "doesn't know" the meaning of the received or sent
-- data, the command_dispatcher interprets this data and implements the
-- protocol for receiving images.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- This component implements a finite state machine for interpreting the
-- received data from the epp_controller and transitions to different
-- states according with this data. The epp_controller provides the
-- write_in signal, which is active (on '1') when new bytes have been
-- received and address and data is available and valid on ports
-- epp_adr_in and epp_data_in respectively. The write_in signal is
-- active for one clock period only.
-- The finite state machine has 4 possible states:
-- -> sIdle - no new data has been received so far
--          - the write_in input is constantly checked for new data.
--          - If received a byte on address COMMAND_RECV_TAG_PORT (255)
--          - then the received data is checked.
--          - If received COMMAND_RECV_TAG_WIDTH (0) then the computer
--          - will send next the width of the image and a transition is
--          - made to state sSetWidth.
--          - If received COMMAND_RECV_TAG_HEIGHT (1) then the computer
--          - will send next the height of the image and a transition is
--          - made to state sSetHeight.
--          - If received COMMAND_RECV_TAG_START_IMAGE (2) then the
--          - computer will send next the bytes of the image one after
--          - another until receiving COMMAND_RECV_TAG_STOP_IMAGE and
--          - a transition is made to state sWritePixelColor.
--          - Also when receiving COMMAND_RECV_TAG_START_IMAGE,
--          - clear_write_counter is set active for one clock period
--          - to reset the write counter into the ram that holds the
--          - image.
--          - All data received on address COMMAND_RECV_TAG_PORT is to
--          - specify the command type.
--          - All data received on address COMMAND_RECV_DATA_PORT is
--          - the actual data sent by the computer, such as the actual
--          - width, height or pixel data.
-- -> sSetWidth - data on epp_data_in is put on the width_out output and
--          - set_width_out is set active for one clock period.
-- -> sSetHeight - data on epp_data_in is put on the height_out output
--          - and set_height_out is set active for one clock period.
-- -> sWritePixelColor - in this state pixel data is received on address
--          - COMMAND_RECV_DATA_PORT until COMMAND_RECV_TAG_STOP_IMAGE
--          - is received on address COMMAND_RECV_TAG_PORT, in which
--          - case a transition is made back into sIdle.
--          - when a new byte is received, write_pixel_out is set active
--          - for one clock period.
--          - One pixel is composed of 3 bytes: 1 byte for blue, 1 byte
--          - for green and 1 byte for red, in this order. Images are
--          - stored in 12 bits/pixel format, although 24 bits are
--          - received per pixel. Valid pixel channel data is placed
--          - on the most significat 4 bits of each received byte.
--          - Notice that epp_data_in is 8 bits width and
--          - pixel_color_out is 4 bits width, the most significant 4
--          - bits from epp_data_in. This is where the conversion from
--          - 24 bpp image to 12 bpp image is made.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk            - global clock input with frequency of 100MHz
-- write_in       - input from epp_controller. When active indicates new
--                - data on epp_data_in and the receiving address is
--                - valid on epp_adr_in.
-- epp_adr_in     - address (of 8 bits) of the last received data.
-- epp_data_in    - last received data through the epp interface.
-- width_out      - width of last received image.
-- height_out     - height of last received image.
-- set_width_out  - when active indicates new width (valid on width_out)
--                - received.
-- set_height_out - when active indicates new height (valid on
--                - height_out) received.
-- pixel_color_out - value of last color channel of pixel received.
-- write_pixel_color_out - when active indicates new component of pixel
--                - (1 of the 3 color channels) received and valid on
--                - pixel_color_out.
-- clear_write_counter_out - when active indicates that write counter of
--                - image holding ram should be reset because a new
--                - image is about to be transfered.
------------------------------------------------------------------------
-- Revision History:
-- 09/18/2006(UlrichZ): created
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- simulation library.
library UNISIM;
use UNISIM.VComponents.all;

-- declaration of entity command_dispatcher.
-- read above for behavioral description and port definitions.
entity command_dispatcher is
port(
   clk                     : in std_logic;
   write_in                : in std_logic;
   epp_adr_in              : in std_logic_vector(7 downto 0);
   epp_data_in             : in std_logic_vector(7 downto 0);

   width_out               : out std_logic_vector(7 downto 0);
   height_out              : out std_logic_vector(7 downto 0);
   set_width_out           : out std_logic;
   set_height_out          : out std_logic;

   pixel_color_out         : out std_logic_vector(3 downto 0);
   write_pixel_color_out   : out std_logic;
   clear_write_counter_out : out std_logic
);
end command_dispatcher;

-- begining of architecture behavioral of command_dispatcher
architecture Behavioral of command_dispatcher is

------------------------------------------------------------------------
-- CONSTANTS DECLARATION
------------------------------------------------------------------------
constant COMMAND_RECV_TAG_PORT         : std_logic_vector(7 downto 0)
                                       := "11111111"; -- 255
constant COMMAND_RECV_TAG_WIDTH        : std_logic_vector(7 downto 0)
                                       := "00000000"; --   0
constant COMMAND_RECV_TAG_HEIGHT       : std_logic_vector(7 downto 0)
                                       := "00000001"; --   1
constant COMMAND_RECV_TAG_START_IMAGE  : std_logic_vector(7 downto 0)
                                       := "00000010"; --   2
constant COMMAND_RECV_TAG_STOP_IMAGE   : std_logic_vector(7 downto 0)
                                       := "00000011"; --   3
constant COMMAND_RECV_DATA_PORT        : std_logic_vector(7 downto 0)
                                       := "10101010"; -- 170
------------------------------------------------------------------------
-- SIGNALS DECLARATION
------------------------------------------------------------------------

-- fsm possible states.
type command_fsm is (sIdle,sSetWidth,sSetHeight,sWritePixelColor);
signal command_state : command_fsm := sIdle;

-- stores the width of the last received image (or incoming image)
signal width         : std_logic_vector(7 downto 0) := (others => '0');
-- stores the height of the last received image (or incoming image)
signal height        : std_logic_vector(7 downto 0) := (others => '0');
-- stores the value of last received pixel channel (blue, green, red)
signal pixel_color   : std_logic_vector(3 downto 0) := (others => '0');

-- signal active for one clock period when received new width
signal set_width           : std_logic := '0';
-- signal active for one clock period when received new height
signal set_height          : std_logic := '0';
-- signal active for one clock period when received new color channel
signal write_pixel_color   : std_logic := '0';
-- signal active for one clock period when starting transfer of image
signal clear_write_counter : std_logic := '0';

begin

   width_out <= width;
   height_out <= height;
   pixel_color_out <= pixel_color;
   
   set_width_out <= set_width;
   set_height_out <= set_height;
   write_pixel_color_out <= write_pixel_color;
   clear_write_counter_out <= clear_write_counter;

   -- implementation of the synchronous finite state machine
   -- state changes every clock period.
   -- only one process for managing the fsm.
   manage_fsm: process(clk)
   begin
      if(rising_edge(clk)) then
         
         -- default values for signals.
         -- guaranties the deactivation of these signals
         -- after one clock period.
         set_width <= '0';
         set_height <= '0';
         write_pixel_color <= '0';
         clear_write_counter <= '0';
         
         case command_state is
                      
            -- wait new data from epp_controller
            -- and transition of appropriate state when data received
            when sIdle =>
               -- listen to write_in indicating new data
               if(write_in = '1') then
                  -- a new command issued
                  if(epp_adr_in = COMMAND_RECV_TAG_PORT) then
                     -- new width to be received next
                     if(epp_data_in = COMMAND_RECV_TAG_WIDTH) then
                        command_state <= sSetWidth;
                     -- new height to be received next
                     elsif(epp_data_in = COMMAND_RECV_TAG_HEIGHT) then
                        command_state <= sSetHeight;
                     -- new image to be received next
                     elsif(epp_data_in = COMMAND_RECV_TAG_START_IMAGE)
                     then
                        clear_write_counter <= '1';
                        command_state <= sWritePixelColor;
                     else
                        command_state <= sIdle;
                     end if;
                  else
                     command_state <= sIdle;
                  end if;
               else
                  command_state <= sIdle;
               end if;

            -- wait for the new width of the upcoming image
            when sSetWidth =>
               -- listen to write_in indicating new data
               if(write_in = '1') then
                  -- if data received on data port
                  if(epp_adr_in = COMMAND_RECV_DATA_PORT) then
                     -- read data into width register
                     width <= epp_data_in;
                     -- signal new width to clients
                     set_width <= '1';
                     -- and transtion back to sIdle
                     command_state <= sIdle;
                  else
                     -- invalid address of data, remain here
                     command_state <= sSetWidth;
                  end if;
               else
                  -- no new data yet, remain here
                  command_state <= sSetWidth;
               end if;

            -- wait for the new height of the upcoming image
            when sSetHeight =>
                -- listen to write_in indicating new data
                if(write_in = '1') then
                  -- if data received on data port
                  if(epp_adr_in = COMMAND_RECV_DATA_PORT) then
                     -- read data into height register
                     height <= epp_data_in;
                     -- signal new height to clients
                     set_height <= '1';
                     -- and transtion back to sIdle
                     command_state <= sIdle;
                  else
                     -- invalid address of data, remain here
                     command_state <= sSetHeight;
                  end if;
               else
                  -- no new data yet, remain here
                  command_state <= sSetHeight;
               end if;

            -- receive pixel data and forward to image_controller
            -- when received COMMAND_RECV_TAG_STOP_IMAGE transition
            -- back to sIdle
            when sWritePixelColor =>
               -- listen to write_in indicating new data
               if(write_in = '1') then
                  -- if data received on tag port
                  if(epp_adr_in = COMMAND_RECV_TAG_PORT) then
                     -- if received COMMAND_RECV_TAG_STOP_IMAGE
                     if(epp_data_in = COMMAND_RECV_TAG_STOP_IMAGE) then
                        -- back to sIdle
                        command_state <= sIdle;
                     else
                        -- remain here
                        command_state <= sWritePixelColor;
                     end if;
                  -- if data received on data port
                  elsif(epp_adr_in = COMMAND_RECV_DATA_PORT) then
                     -- read most significant 4 bits into pixel_color
                     pixel_color <= epp_data_in(7 downto 4);
                     -- activate write_pixel_color
                     write_pixel_color <= '1';
                     -- remain in this state and wait for new data
                     command_state <= sWritePixelColor;
                  else
                     command_state <= sWritePixelColor;
                  end if;
               else
                  command_state <= sWritePixelColor;
               end if;

            -- in case of transition to invalid states
            -- go back to sIdle
            when others =>
               command_state <= sIdle;
              
         end case;         

      end if;
   end process manage_fsm;

end Behavioral;