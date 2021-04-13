------------------------------------------------------------------------
-- image_controller.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file describes the logic that receives the image from the
-- epp_data_module, stores the image, reads the image and sends it
-- to be displayed when inside display bounds, describes debug logic
-- to be shown on the 7 segment displays regarding image bounds.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- The image is stored entirely in the block ram. Images of up to 16k
-- pixels can be stored. Each pixel has 12 bits, 4 for each channel(rgb)
-- The pixels are received one channel at a time, starting with blue,
-- then green and red. When on pixel is received (3 consecutive 4 bits)
-- it is written in the ram at the current write position and the
-- position is then incremented.

-- Memory reading begins when the current position on the screen, given
-- by hcount and vcount from the vga_controller, is within bounds. The
-- bounds of the image can change as instructed by the
-- image_motion_controller. Images keep their original aspect ratio, but
-- neither the width nor the height of the image can be greater then 256
-- pixels. Memory read address is not composed of the horizontal and
-- vertical counters, it is incremented after each pixel is read, fifo
-- like behavior. When the last pixel of the image is read, the read
-- counter resets. Max value of the read counter is set by the
-- image_motion_controller and is the product of the width and height of
-- the image.

-- The block ram that holds the image is dual-ported and uses different
-- clocks to read or write the memory. For writing, the system clock
-- (100MHz) is used. For reading, the pixel_clk is used, which is
-- provided by the pixel_clock_switcher. This is 25MHz for the 640x480
-- resolution and 40MHz for the 800x600 resolution.
-- To control the writing in the image memory, a finite state machine is
-- used. It has 4 states: swBlue, swGreen, swRed, swWrite and these are
-- gray coded. The synthesizer is instructed through attributes not to
-- automatically extract the fsm.
-- -> swBlue   - this is the startup state and reset state.
--             - the fsm remains in this state until a new color channel
--             - is received from command_dispatcher.
--             - when data is received (write_pixel_color_in goes high)
--             - the 4 bits on pixel_color_in are read into the 12 bits
--             - register pixel on the most significant 4 bits and a
--             - transition is made into swGreen.
-- -> swGreen  - wait the green color data, reads it into the middle 4
--             - bits of pixel and transitions to swRed
-- -> swRed    - wait the red color data, reads it into least
--             - significant bits of pixel and transitions to swWrite.
-- -> swWrite  - during this state the contents of pixel register is
--             - writen into the block ram and the write counter is
--             - incremented. The fsm transitions to swBlue to receive
--             - a new pixel.
-- Data is read from the memory at every rising edge of pixel_clk, into
-- image_ram_data register. When hcount and vcount are within image
-- bounds, read counter is incremented for every pixel and data from
-- image_ram_data is output on red_out, green_out and blue_out.

-- For debuging purposes the bounds of the image are output on hex1_out
-- and hex2_out, one position at a time. With a button from the fpga
-- the user can select the currently displayed position. "counter" reg,
-- of 2 bits, is used for this, incrementing it every time the button is
-- pushed. If the counter is "00" then the left upper corner horizontal
-- position is displayed, when "01" - the right lower corner horizontal
-- position, when "10" - the left upper corner vertical position and
-- the right lower corner vertical position for "11". To know which
-- position is currently displayed, two leds are tied to the value of
-- the counter.
------------------------------------------------------------------------
-- 
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk            - global clock input (100MHz)
-- rst            - global reset input
-- btn            - input from the button of the fpga that is used to
--                - increment the counter telling which position of the
--                - image to be displayed on the 7 segments.
-- pixel_color_in - input pin, 4 bits, from command_dispatcher
--                - represents the value of the last color channel
--                - received.
-- write_pixel_color_in - input pin, from command_dispatcher, active
--                - for one clock period when new pixel data received
--                - and available on pixel_color_in.
-- clear_write_counter_in - input pin, from command_dispatcher, active
--                - one clock period when a new image is about to be
--                - sent to reset the write address counter.
-- hex1_out       - output pin, 8 bits, least significant 8 bits of data
--                - to be displayed on the 7-segment displays.
-- hex2_out       - output pin, 8 bits, most significant 8 bits of data
--                - to be displayed on the 7-segment displays.
-- pixel_clk      - input pin, from pixel_clock_switcher, the clock used
--                - by the vga_controller for the currently used
--                - resolution, generated by a dcm. 25MHz for 640x480
--                - and 40MHz for 800x600. This clock is used to read
--                - pixels from memory and output data on color outputs.
-- hcount         - input pin, 11 bits
--                - the horizontal counter from the vga_controller
--                - tells the horizontal position of the current pixel
--                - on the screen from left to right.
-- vcount         - input pin, 11 bits
--                - the vertical counter from the vga_controller
--                - tells the vertical position of the currentl pixel
--                - on the screen from top to bottom.
-- red_out        - value of the red channel of the currently displayed
--                - pixel, "1111" when current pixel is from background
-- green_out      - value of the green channel of the currently
--                - displayed pixel, "1111" when background
-- blue_out       - value of the blue channel of the currently displayed
--                - pixel, "1111" when current pixel is from background
-- inside_image   - output pin, active when current pixel is within the
--                - image bounds. Used by effects_layer to apply effects
--                - only to image, not to background.
-- counter_out    - output, 2 bits, indicate which image position is
--                - currently available on hex1_out and hex2_out.
--                - Tied to 2 leds on the fpga board.
-- HMAX           - input, 10 bits, from image_motion_controller
--                - maximum value of the horizontal counter that is
--                - visible on screen. (640 or 800).
-- VMAX           - input, 10 bits, from image_motion_controller
--                - maximum value of the vertical counter that is
--                - visible on screen. (480 or 600).
-- IMAGE_START_POS_H - input, 10 bits, from image_motion_controller
--                - horizontal position of the upper left corner.
-- IMAGE_START_POS_V - input, 10 bits, from image_motion_controller
--                - vertical position of the upper left corner.
-- IMAGE_END_POS_H - input, 10 bits, from image_motion_controller
--                - horizontal position of the lower right corner.
-- IMAGE_END_POS_V - input, 10 bits, from image_motion_controller
--                - vertical position of the lower right corner.
-- NUM_PIXELS_IN  - input, 14 bits, from image_motion_controller
--                - total number of pixels in the current image
--                - it is the product of the width and the height of
--                - the image. Used to set the maximum read address from
--                - the memory.
-- NEW_NUM_PIXELS_IN - input pin, from image_motion_controller.
--                - active for one clock period when NUM_PIXELS_IN is
--                - valid.
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

-- the image_controller entity declaration
-- read above for behavioral description and port definitions.
entity image_controller is
port(
   clk                     : in std_logic;
   rst                     : in std_logic;
   btn                     : in std_logic;

   pixel_color_in          : in std_logic_vector(3 downto 0);
   write_pixel_color_in    : in std_logic;
   clear_write_counter_in  : in std_logic;

   hex1_out                : out std_logic_vector(7 downto 0);
   hex2_out                : out std_logic_vector(7 downto 0);

   pixel_clk               : in std_logic;
   
   hcount                  : in std_logic_vector(10 downto 0);
   vcount                  : in std_logic_vector(10 downto 0);

   red_out                 : out std_logic_vector(3 downto 0);
   green_out               : out std_logic_vector(3 downto 0);
   blue_out                : out std_logic_vector(3 downto 0);
   inside_image            : out std_logic;

   counter_out             : out std_logic_vector(1 downto 0);

   HMAX                    : in std_logic_vector(9 downto 0);
   VMAX                    : in std_logic_vector(9 downto 0);
   IMAGE_START_POS_H       : in std_logic_vector(9 downto 0);
   IMAGE_START_POS_V       : in std_logic_vector(9 downto 0);
   IMAGE_END_POS_H         : in std_logic_vector(9 downto 0);
   IMAGE_END_POS_V         : in std_logic_vector(9 downto 0);

   NUM_PIXELS_IN           : in std_logic_vector(13 downto 0);
   NEW_NUM_PIXELS_IN       : in std_logic
);
end image_controller;

architecture Behavioral of image_controller is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- hand coded (gray) values for the FSM states
constant swBlue      : std_logic_vector(1 downto 0) := "00";
constant swGreen     : std_logic_vector(1 downto 0) := "01";
constant swRed       : std_logic_vector(1 downto 0) := "10";
constant swWrite     : std_logic_vector(1 downto 0) := "11";

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

-- declaration of the 16Kx12bits ram to store the image
type ram_16K is array (0 to 16383) of std_logic_vector(11 downto 0);
signal image_ram: ram_16K;

-- write address counter
signal writepos   : std_logic_vector(13 downto 0) := (others => '0');
-- read address counter
signal readpos    : std_logic_vector(13 downto 0) := (others => '0');

-- maximum read position, set by the image_motion_controller.
signal READPOS_MAX : std_logic_vector(13 downto 0)
                   := "11111111111111"; -- 16383

-- when active enables writing to ram
signal enable_ram_write : std_logic := '0';

-- data read from image ram, at each rising edge of the pixel_clk
signal image_ram_data: std_logic_vector(11 downto 0)
                     := (others => '0');

-- signal that holds the current state of the FSM
signal pixel_write_state: std_logic_vector(1 downto 0)
                        := (others => '0');

-- buffer that holds the color channel data until written into memory
signal pixel : std_logic_vector(11 downto 0) := (others => '0');

-- active when hcount and vcount are within the bounds of the image
signal in_range      : std_logic := '0';

-- the same as in_range, only delay with one pixel_clk period,
-- to account for the time it takes the memory to fetch the pixel
-- enables the output of image pixels
-- if inactive, output pixels are white, as part of the background
signal enable_output : std_logic := '0';

-- holds the red channel, read from the memory
signal red: std_logic_vector(3 downto 0);
-- holds the green channel, read from the memory
signal green: std_logic_vector(3 downto 0);
-- holds the blue channel, read from the memory
signal blue: std_logic_vector(3 downto 0);

-- counter is used to determine which image bound to output
-- on hex1_out and hex2_out
signal counter: std_logic_vector(1 downto 0) := (others => '0');

-- active when hcount = HMAX and vcount = VMAX, and used to
-- clear the memory read address.
-- This way, if something happens to the read address, on the next frame
-- the address will be correct.
signal new_page: std_logic := '0';

------------------------------------------------------------------------
-- ATTRIBUTES
------------------------------------------------------------------------

-- instructs the synthesizer not to automatically extract FSM
attribute fsm_extract : string;
attribute fsm_extract of pixel_write_state: signal is "no";
attribute fsm_encoding : string;
attribute fsm_encoding of pixel_write_state: signal is "user";
attribute signal_encoding : string;
attribute signal_encoding of pixel_write_state: signal is "user";

begin

   ---------------------------------------------------------------------
   -- FLAGS LOGIC
   ---------------------------------------------------------------------

   inside_image <= enable_output;

   -- increment counter when button is pressed
   -- button input is passed through pulse_debouncer
   -- before arriving to btn input pin, this way
   -- btn will be active only for one clock period
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(btn = '1') then
            counter <= counter + 1;
         end if;
      end if;
   end process;

   counter_out <= counter;
   
   -- if hcount and vcount are within bounds, enable ram read.
   in_range <= '1' when (hcount >= ('0' & IMAGE_START_POS_H) and
                         hcount <  ('0' & IMAGE_END_POS_H)   and
                         vcount >= ('0' & IMAGE_START_POS_V) and
                         vcount <  ('0' & IMAGE_END_POS_V)) else
               '0';

   -- read data on pixel_color_in into pixel buffer
   -- onto the corresponding bits, depending on the
   -- current state of the FSM and whether write_pixel_color_in
   -- is active or not. When a pixel is completly read into pixel,
   -- active the ram writing.
   write_pixel: process(clk)
   begin
      if(rising_edge(clk)) then
         -- if received blue channel, read into pixel and
         -- do not enable ram writing
         if(pixel_write_state = swBlue and
            write_pixel_color_in = '1')
         then
            pixel(11 downto 8) <= pixel_color_in;
            enable_ram_write <= '0';
         -- if received green channel, read into pixel and
         -- do not enable ram writing
         elsif(pixel_write_state = swGreen and
               write_pixel_color_in = '1')
         then
            pixel(7 downto 4) <= pixel_color_in;
            enable_ram_write <= '0';
         -- if received red channel, read into pixel and
         -- do not enable ram writing
         elsif(pixel_write_state = swRed and
               write_pixel_color_in = '1')
         then
            pixel(3 downto 0) <= pixel_color_in;
            enable_ram_write <= '0';
         -- if fsm in swWrite state, buffer contains a valid pixel
         -- and it is written into memory.
         elsif(pixel_write_state = swWrite) then
            enable_ram_write <= '1';
         else
            enable_ram_write <= '0';
         end if;
      end if;
   end process write_pixel;

   -- when new number of pixels arrives from image_motion_controller
   -- read the value into READPOS_MAX
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(NEW_NUM_PIXELS_IN = '1') then
            READPOS_MAX <= NUM_PIXELS_IN;
         end if;
      end if;
   end process;
   
   -- delay in_range signal with one pixel_clk period
   -- and assign the delayed signal to enable_output.
   -- This way read time from the memory is accounted for
   process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then  
         if(in_range = '1') then
            enable_output <= '1';
         else
            enable_output <= '0';
         end if;
      end if;
   end process;

   -- when hcount = HMAX and vcount = VMAX a frame has finished
   -- displaying and new_page is activated to reset the read
   -- address
   new_page <= '1' when ((hcount = ('0' & HMAX)) and
                         (vcount = ('0' & VMAX))) else
               '1' when rst = '1' else
               '0';

   ---------------------------------------------------------------------
   -- COLOR MANAGEMENT LOGIC
   ---------------------------------------------------------------------

   red_out <= red;
   green_out <= green;
   blue_out <= blue;

   -- if enable_output is active, place on to color outputs
   -- the data from the image ram, else place "1111" (white)
   -- as background.
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(enable_output = '1') then
            red   <= image_ram_data(3 downto 0);
            green <= image_ram_data(7 downto 4);
            blue  <= image_ram_data(11 downto 8);
         else
            red <= (others => '1');
            green <= (others => '1');
            blue <= (others => '1');
         end if;
      end if;
   end process;
   
   ---------------------------------------------------------------------
   -- RAM READ/WRITE LOGIC
   ---------------------------------------------------------------------
   
   -- synchronously (with clk) write into memory when
   -- enable_ram_write is active and increment write address.
   -- if rst or clear_write_counter_in is active reset address.
   process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1' or clear_write_counter_in = '1') then
            writepos <= (others => '0');
         elsif(enable_ram_write = '1') then
            image_ram(conv_integer(writepos)) <= pixel;
            writepos <= writepos + 1;
         end if;
      end if;
   end process;

   -- synchronously with pixel_clk read from memory, and
   -- if in_range is active increment read adsress.
   -- if readpos reached maximum value for this image, reset readpos
   -- if new_page is active reset readpos.
   process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then  
         if(new_page = '1') then
            readpos <= (others => '0');
         elsif(in_range = '1') then
            if(readpos = READPOS_MAX) then
               readpos <= (others => '0');
            else
               readpos <= readpos + 1;
            end if;
         end if;
         image_ram_data <= image_ram(conv_integer(readpos));
      end if;
   end process;

   ---------------------------------------------------------------------
   -- DEBUG LOGIC
   ---------------------------------------------------------------------

   -- output on hex1_out the 8 least significant bits from the
   -- image bound indicated by "counter"
   hex1_out <= IMAGE_START_POS_H(7 downto 0) when counter = "00" else
               IMAGE_END_POS_H(7 downto 0) when counter = "01" else
               IMAGE_START_POS_V(7 downto 0) when counter = "10" else
               IMAGE_END_POS_V(7 downto 0);
               
   -- output on hex1_out the 2 most significant bits from the
   -- image bound indicated by "counter". Pad with "00000" to
   -- get 8 bits to output.
   hex2_out <= "000000" & IMAGE_START_POS_H(9 downto 8)
               when counter = "00" else
               "000000" & IMAGE_END_POS_H(9 downto 8)
               when counter = "01" else
               "000000" & IMAGE_START_POS_V(9 downto 8)
               when counter = "10" else
               "000000" & IMAGE_END_POS_V(9 downto 8);

   ---------------------------------------------------------------------
   -- PIXEL WRITE FSM LOGIC
   ---------------------------------------------------------------------
      
   -- one process synchronous FSM for controlling the writing
   -- the image into memory. One pixel is received by consecutively
   -- sending the blue channel, then the green channel, and finally the
   -- red channel. When all these 3 channel are read, write buffer into
   -- image ram.
   manage_pixel_write_fsm: process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            pixel_write_state <= swBlue;
         else
            case pixel_write_state is
               
               -- wait for the blue channel to arive
               when swBlue =>
                  if(write_pixel_color_in = '1') then
                     pixel_write_state <= swGreen;
                  else
                     pixel_write_state <= swBlue;
                  end if;
               
               -- wait for the green channel to arive
               when swGreen =>
                  if(write_pixel_color_in = '1') then
                     pixel_write_state <= swRed;
                  else
                     pixel_write_state <= swGreen;
                  end if;
               
               -- wait for the red channel to arive
               when swRed =>
                  if(write_pixel_color_in = '1') then
                     pixel_write_state <= swWrite;
                  else
                     pixel_write_state <= swRed;
                  end if;

               -- write the pixel buffer into memory
               -- and go back to sBlue for waiting another pixel
               when swWrite =>
                  pixel_write_state <= swBlue;

               -- if invalid transition occurs, go back to swBlue
               when others =>
                  pixel_write_state <= swBlue;

            end case;
         end if;
      end if;
   end process manage_pixel_write_fsm;
   
end Behavioral;