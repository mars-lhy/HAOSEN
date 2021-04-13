------------------------------------------------------------------------
-- mouse_displayer.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zolt�n
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the implementation of a mouse cursor.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- Mouse position is received from the mouse_controller, horizontal and
-- vertical counters are received from vga_module and if the counters
-- are inside the mouse cursor bounds, then the mouse is sent to the
-- screen instead of the received pixels. The mouse cursor is 16x16
-- pixels and used 2 colors: white and black. For the color encoding
-- 2 bits are used to be able to use transparency. The cursor is stored
-- in a distributed ram memory 256x2bits in dimension. If the current
-- pixel of the mouse is "00" then output color is black, if "01" then
-- white and if "10" or "11" then the pixel is perfectly transparent
-- and the input colors are output. This way, the mouse will not be a
-- 16x16 square and will have an arrow shape.
-- Memory address is composed from the difference of the vga counters
-- and mouse position. xdiff is the difference on 4 bits (because cursor
-- is 16 pixels width) between the horizontal vga counter and the xpos
-- of the mouse. ydiff is the difference on 4 bits (because cursor
-- has 16 pixels in height) between the vertical vga counter and the
-- ypos of the mouse. By concatenating ydiff and xdiff (in this order)
-- the memory address of the current pixel is obtained.
-- Distributed memory is forced by the attributes, because the block
-- rams are entirely used for storing images.
-- If blank input from the vga_module is active, this means that current
-- pixel is not inside visible screen and color outputs are set to black
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk            - global clock signal (100MHz)
-- pixel_clk      - input pin, from pixel_clock_switcher, the clock used
--                - by the vga_controller for the currently used
--                - resolution, generated by a dcm. 25MHz for 640x480
--                - and 40MHz for 800x600. This clock is used to read
--                - pixels from memory and output data on color outputs.
-- xpos           - input pin, 10 bits, from mouse_controller
--                - the x position of the mouse relative to the upper
--                - left corner
-- ypos           - input pin, 10 bits, from mouse_controller
--                - the y position of the mouse relative to the upper
--                - left corner
-- hcount         - input pin, 11 bits, from vga_module
--                - the horizontal counter from the vga_controller
--                - tells the horizontal position of the current pixel
--                - on the screen from left to right.
-- vcount         - input pin, 11 bits, from vga_module
--                - the vertical counter from the vga_controller
--                - tells the vertical position of the current pixel
--                - on the screen from top to bottom.
-- blank          - input pin, from vga_module
--                - if active, current pixel is not in visible area,
--                - and color outputs should be set on 0.
-- red_in         - input pin, 4 bits, from effects_layer
--                - red channel input of the image to be displayed
-- green_in       - input pin, 4 bits, from effects_layer
--                - green channel input of the image to be displayed
-- blue_in        - input pin, 4 bits, from effects_layer
--                - blue channel input of the image to be displayed
-- red_out        - output pin, 4 bits, to vga hardware module.
--                - red output channel
-- green_out      - output pin, 4 bits, to vga hardware module.
--                - green output channel
-- blue_out       - output pin, 4 bits, to vga hardware module.
--                - blue output channel
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

-- the mouse_displayer entity declaration
-- read above for behavioral description and port definitions.
entity mouse_displayer is
port (
   clk      : in std_logic;
   
   pixel_clk: in std_logic;
   xpos     : in std_logic_vector(9 downto 0);
   ypos     : in std_logic_vector(9 downto 0);

   hcount   : in std_logic_vector(10 downto 0);
   vcount   : in std_logic_vector(10 downto 0);
   blank    : in std_logic;

   red_in   : in std_logic_vector(3 downto 0);
   green_in : in std_logic_vector(3 downto 0);
   blue_in  : in std_logic_vector(3 downto 0);

   red_out  : out std_logic_vector(3 downto 0);
   green_out: out std_logic_vector(3 downto 0);
   blue_out : out std_logic_vector(3 downto 0)
);

-- force synthesizer to extract distributed ram for the
-- displayrom signal, and not a block ram, because the block ram
-- is entirely used to store the image.
attribute rom_extract : string;
attribute rom_extract of mouse_displayer: entity is "yes";
attribute rom_style : string;
attribute rom_style of mouse_displayer: entity is "distributed";

end mouse_displayer;

architecture Behavioral of mouse_displayer is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

type displayrom is array(0 to 255) of std_logic_vector(1 downto 0);
-- the memory that holds the cursor.
-- 00 - black
-- 01 - white
-- 1x - transparent
constant mouserom: displayrom := (
"00","00","11","11","11","11","11","11","11","11","11","11","11","11","11","11",
"00","01","00","11","11","11","11","11","11","11","11","11","11","11","11","11",
"00","01","01","00","11","11","11","11","11","11","11","11","11","11","11","11",
"00","01","01","01","00","11","11","11","11","11","11","11","11","11","11","11",
"00","01","01","01","01","00","11","11","11","11","11","11","11","11","11","11",
"00","01","01","01","01","01","00","11","11","11","11","11","11","11","11","11",
"00","01","01","01","01","01","01","00","11","11","11","11","11","11","11","11",
"00","01","01","01","01","01","01","01","00","11","11","11","11","11","11","11",
"00","01","01","01","01","01","00","00","00","00","11","11","11","11","11","11",
"00","01","01","01","01","01","00","11","11","11","11","11","11","11","11","11",
"00","01","00","00","01","01","00","11","11","11","11","11","11","11","11","11",
"00","00","11","11","00","01","01","00","11","11","11","11","11","11","11","11",
"00","11","11","11","00","01","01","00","11","11","11","11","11","11","11","11",
"11","11","11","11","11","00","01","01","00","11","11","11","11","11","11","11",
"11","11","11","11","11","00","01","01","00","11","11","11","11","11","11","11",
"11","11","11","11","11","11","00","00","11","11","11","11","11","11","11","11"
);                                                                                                                     

-- width and height of cursor.
constant OFFSET: std_logic_vector(4 downto 0) := "10000";   -- 16

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

--signal rompos: std_logic_vector(7 downto 0) := (others => '0');

-- pixel from the display memory, representing currently displayed
-- pixel of the cursor, if the cursor is being display at this point
signal mousepixel: std_logic_vector(1 downto 0) := (others => '0');
-- when high, enables displaying of the cursor, and reading the
-- cursor memory.
signal enable_mouse_display: std_logic := '0';

-- difference in range 0-15 between the vga counters and mouse position
signal xdiff: std_logic_vector(3 downto 0) := (others => '0');
signal ydiff: std_logic_vector(3 downto 0) := (others => '0');

begin

   -- compute xdiff
   x_diff: process(clk)
   variable temp_diff: std_logic_vector(10 downto 0) := (others => '0');
   begin
      if(rising_edge(clk)) then
         temp_diff := hcount - ('0' & xpos);
         xdiff <= temp_diff(3 downto 0);
      end if;
   end process x_diff;

   -- compute ydiff
   y_diff: process(clk)
   variable temp_diff: std_logic_vector(10 downto 0) := (others => '0');
   begin
      if(rising_edge(clk)) then
         temp_diff := vcount - ('0' & ypos);
         ydiff <= temp_diff(3 downto 0);
      end if;
   end process y_diff;

--   rompos <= (ydiff & xdiff) when rising_edge(clk);

   -- read pixel from memory at address obtained by concatenation of
   -- ydiff and xdiff
   mousepixel <= mouserom(conv_integer(ydiff & xdiff))
                 when rising_edge(pixel_clk);

   -- set enable_mouse_display high if vga counters inside cursor block
   enable_mouse: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(hcount >= xpos and hcount < (xpos + OFFSET) and
            vcount >= ypos and vcount < (ypos + OFFSET))
         then
            enable_mouse_display <= '1';
         else
            enable_mouse_display <= '0';
         end if;
      end if;
   end process enable_mouse;  

   -- if cursor display is enabled, then, according to pixel
   -- value, set the output color channels.
   process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         -- if in visible screen
         if(blank = '0') then
            -- in display is enabled
            if(enable_mouse_display = '1') then
               -- white pixel of cursor
               if(mousepixel = "01") then
                  red_out <= (others => '1');
                  green_out <= (others => '1');
                  blue_out <= (others => '1');
               -- black pixel of cursor
               elsif(mousepixel = "00") then
                  red_out <= (others => '0');
                  green_out <= (others => '0');
                  blue_out <= (others => '0');
               -- transparent pixel of cursor
               -- let input pass to output
               else
                  red_out <= red_in;
                  green_out <= green_in;
                  blue_out <= blue_in;
               end if;
            -- cursor display is not enabled
            -- let input pass to output.
            else
               red_out <= red_in;
               green_out <= green_in;
               blue_out <= blue_in;
            end if;
         -- not in visible screen, black outputs.
         else
            red_out <= (others => '0');
            green_out <= (others => '0');
            blue_out <= (others => '0');
         end if;
      end if;
   end process;

end Behavioral;