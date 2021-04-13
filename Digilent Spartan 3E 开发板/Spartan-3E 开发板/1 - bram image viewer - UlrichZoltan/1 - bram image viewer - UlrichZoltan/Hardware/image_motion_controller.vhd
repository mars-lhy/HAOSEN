------------------------------------------------------------------------
-- image_motion_controller.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file describes the logic that changes the image bounds when
-- the image is dragged, the mouse wheel is moved, the resolution is
-- changed, or new image dimensions are received. 
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- This module enables the image to be moved on the screen, by draging
-- it with the mouse (with the left mouse button, or the right button),
-- by rolling the mouse wheel (if the mouse has one). Also, it centers
-- the image that is newly received or the resoultion is changed.
-- Image is placed on the screen by sending to the image_controller the
-- bounds (left-upper horizontal and veritcal position, right-lower
-- horizontal and veritcal position) of the image, and the
-- image_controller enables image reading and displaying only when
-- within this bounds.

-- The image can be moved by holding down the left or right mouse button
-- inside the image and with the button down the mouse is moved, a drag
-- operation. If the click occurs outside the image bounds, the image
-- position does not change. This is done, by storing the difference
-- from the mouse position (its hot-spot - upper-left corner) and the
-- upper-left position of the image at click time and substracting these
-- differences from the mouse position when it is moved. Saturation is
-- used for the image to remain within the visible screen. This means
-- for example that the image will remain entirely in the visible area
-- at the left screen margin, if already there and tring to move it
-- further left.
-- The computation of the new image bounds is done in a multistage
-- fashion, because using a single clock period for this, would increase
-- the maximum clock period to more than 10ns, thus the design might
-- not function well when run at 100MHz. By dividing the computation
-- in 2 stages and precomputing some variables, the design runs well
-- at 100MHz. For the control of the computation a FSM is used.

-- The image can also be moved by rolling the mouse wheel(if available).
-- By rolling the mouse wheel upward the image will move upward on the
-- screen with Z_INCREMENT(8) pixels at a time. If moved downward the
-- image will move downward by the same amount. To move it sideways,
-- the mouse middle button must be held down while rolling the mouse
-- wheel. Saturation is used in this situation also.

-- When receiving a new image, the width and the height of the new image
-- are send before the actual pixel data. The received width and height
-- are in range 0-255 (to fit on the epp_bus) and are incremented by 1
-- to bring them in range 1-256. The software that send the image must
-- substract 1 from the real image width and height before sending them.
-- When receiving a new width or height, the total number of pixels in
-- the image is computed and sent to image_controller, where it is used
-- to set the maximum read address from the memory, since not all images
-- fill the memory. Also when receiving new width and height, the image
-- is centered. This also occurs when the resolution is changed, even
-- if the same resolution is selected.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk         - global clock input (100MHz)
-- resolution  - input pin, from resolution_switcher
--             - 0 when selected resolution is 640x480
--             - 1 when selected resolution is 800x600
-- switch      - input pin, from resolution_switcher
--             - active for one clock period when the resolution is
--             - swiched by the user
-- xpos        - input pin, 10 bits, from mouse_controller
--             - horizontal position of the mouse on the screen
--             - (its hot-spot, left-upper corner)
-- ypos        - input pin, 10 bits, from mouse_controller
--             - vertical position of the mouse on the screen
--             - (its hot-spot, left-upper corner)
-- zpos        - input pin, 4 bits, from mouse_controller
--             - delta movement of the mouse wheel since last report
--             - 2's complement encoding
-- left        - input pin, from mouse_controller
--             - active when left mouse button is pressed
-- middle      - input pin, from mouse_controller
--             - active when middle mouse button is pressed
-- right       - input pin, from mouse_controller
--             - active when right mouse button is pressed
-- new_event   - input pin, from mouse_controller
--             - active for one clock period when a new mouse packet
--             - received (x,y,z movement,button state changed or both)
-- WIDTH_IN    - input pin, 8 bits, from command_dispatcher
--             - width of the image to be sent, in range 0-255
-- HEIGHT_IN   - input pin, 8 bits, from command_dispatcher
--             - height of the image to be sent, in range 0-255
-- SET_WIDTH_IN - input pin, from command_dispatcher
--             - active for one clock period when new width arrived
-- SET_HEIGHT_IN - input pin, from command_dispatcher
--             - active for one clock period when new height arrived
-- HMAX_OUT    - output pin, 10 bits, to image_controller
--             - maximun hcount value for the visible area (actualy
--             - max+1) for the currently selected resolution
-- VMAX_OUT    - output pin, 10 bits, to image_controller
--             - maximun vcount value for the visible area (actualy
--             - max+1) for the currently selected resolution
-- IMAGE_START_POS_H_OUT - output pin, 10 bits, to image_controller
--             - upper-left corner horizontal position of the image
-- IMAGE_START_POS_V_OUT - output pin, 10 bits, to image_controller
--             - upper-left corner vertical position of the image
-- IMAGE_END_POS_H_OUT - output pin, 10 bits, to image_controller
--             - lower-right corner horizontal position of the image
-- IMAGE_END_POS_V_OUT - output pin, 10 bits, to image_controller
--             - lower-right corner vertical position of the image
-- NUM_PIXELS_OUT - output pin, 14 bits, to image_controller
--             - total number of pixels in the image - 1
-- NEW_NUM_PIXELS_OUT - output pin, to image_controller
--             - active for one clock period when NUM_PIXELS_OUT is
--             - recomputed when receiving new width or new height
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

-- the image_motion_controller entity declaration
-- read above for behavioral description and port definitions.
entity image_motion_controller is
port(
   clk         : in std_logic;
   
   -- resolution related ports
   resolution  : in std_logic;
   switch      : in std_logic;
   
   -- mouse related ports
   xpos        : in std_logic_vector(9 downto 0);
   ypos        : in std_logic_vector(9 downto 0);
   zpos        : in std_logic_vector(3 downto 0);
   left        : in std_logic;
   middle      : in std_logic;
   right       : in std_logic;
   new_event   : in std_logic;

   -- image dimension related input ports
   WIDTH_IN       : in std_logic_vector(7 downto 0);
   HEIGHT_IN      : in std_logic_vector(7 downto 0);
   SET_WIDTH_IN   : in std_logic;
   SET_HEIGHT_IN  : in std_logic;

   -- image position and dimension related output ports
   HMAX_OUT                : out std_logic_vector(9 downto 0);
   VMAX_OUT                : out std_logic_vector(9 downto 0);
   IMAGE_START_POS_H_OUT   : out std_logic_vector(9 downto 0);
   IMAGE_START_POS_V_OUT   : out std_logic_vector(9 downto 0);
   IMAGE_END_POS_H_OUT     : out std_logic_vector(9 downto 0);
   IMAGE_END_POS_V_OUT     : out std_logic_vector(9 downto 0);
   NUM_PIXELS_OUT          : out std_logic_vector(13 downto 0);
   NEW_NUM_PIXELS_OUT      : out std_logic
);

-- disable resource sharing for increased performance
attribute resource_sharing : string;
attribute resource_sharing of image_motion_controller: entity is "no"; 

end image_motion_controller;

architecture Behavioral of image_motion_controller is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- maximum values for horizontal and vertical counters for both
-- resolutions, for visible area
constant HMAX_640                      : std_logic_vector(9 downto 0)
                                       := "1010000000"; -- 640
constant VMAX_640                      : std_logic_vector(9 downto 0)
                                       := "0111100000"; -- 480
constant HMAX_800                      : std_logic_vector(9 downto 0)
                                       := "1100100000"; -- 800
constant VMAX_800                      : std_logic_vector(9 downto 0)
                                       := "1001011000"; -- 600
-- the position increment when then mouse wheel is moved
constant Z_INCREMENT : std_logic_vector(3 downto 0) := "1000"; -- 8

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------                                       := "1001011000"; -- 600

-- default values for the image position at 640x480
-- computed so that the image is centered
signal DEFAULT_IMAGE_START_POS_H_640   : std_logic_vector(9 downto 0); 
signal DEFAULT_IMAGE_START_POS_V_640   : std_logic_vector(9 downto 0);
signal DEFAULT_IMAGE_END_POS_H_640     : std_logic_vector(9 downto 0);
signal DEFAULT_IMAGE_END_POS_V_640     : std_logic_vector(9 downto 0);

-- default values for the image position at 800x600
-- computed so that the image is centered
signal DEFAULT_IMAGE_START_POS_H_800   : std_logic_vector(9 downto 0);
signal DEFAULT_IMAGE_START_POS_V_800   : std_logic_vector(9 downto 0);
signal DEFAULT_IMAGE_END_POS_H_800     : std_logic_vector(9 downto 0);
signal DEFAULT_IMAGE_END_POS_V_800     : std_logic_vector(9 downto 0);

-- width and height of the image, in range 1-256
signal WIDTH : std_logic_vector(8 downto 0);
signal HEIGHT: std_logic_vector(8 downto 0);

-- image bounds and max values for the counters (visible area)
-- sent to the image_controller
signal HMAX: std_logic_vector(9 downto 0) := HMAX_640;
signal VMAX: std_logic_vector(9 downto 0) := VMAX_640;
signal IMAGE_START_POS_H: std_logic_vector(9 downto 0);
signal IMAGE_START_POS_V: std_logic_vector(9 downto 0);
signal IMAGE_END_POS_H  : std_logic_vector(9 downto 0);
signal IMAGE_END_POS_V  : std_logic_vector(9 downto 0);

-- indicate whether a drag operation is ongoing
signal drag_active: std_logic := '0';

-- the difference from the mouse position and the image
-- left-upper corner, at the time a click occurred
signal xdiff: std_logic_vector(9 downto 0) := (others => '0');
signal ydiff: std_logic_vector(9 downto 0) := (others => '0');

-- hold precomputed values for xpos + WIDTH and ypos + HEIGHT
-- for faster computation
signal xpos_plus_WIDTH : std_logic_vector(9 downto 0) :=(others => '0');
signal ypos_plus_HEIGHT: std_logic_vector(9 downto 0) :=(others => '0');

-- intermediary non-saturated values for the image bounds
signal new_upper_x: std_logic_vector(9 downto 0) := (others => '0');
signal new_upper_y: std_logic_vector(9 downto 0) := (others => '0');
signal new_lower_x: std_logic_vector(9 downto 0) := (others => '0');
signal new_lower_y: std_logic_vector(9 downto 0) := (others => '0');

type pipeline_state_fsm is (idle,stage1,stage2);
-- signal that holds the current state of the FSM for
-- multistage computing
signal pipeline_state : pipeline_state_fsm := idle;

-- value of left, right, switch signals, delayed
-- one clock period
signal prev_left : std_logic := '0';
signal prev_right: std_logic := '0';
signal prev_switch: std_logic := '0';

-- when active indicates new mouse wheel movement occurred
signal z_movement: std_logic := '0';

-- indicates new width received and adjusted WIDTH is valid
signal new_x_dimension : std_logic := '0';
-- indicates new height received and adjusted HEIGHT is valid
signal new_y_dimension : std_logic := '0';

-- value of set_width_in and set_height_in delayed
-- one clock period
signal delayed_set_width_in   : std_logic := '0';
signal delayed_set_height_in   : std_logic := '0';

begin

   ---------------------------------------------------------------------
   -- ASSIGN OUTPUTS
   ---------------------------------------------------------------------

   HMAX <= HMAX_800 when resolution = '1' else HMAX_640;
   VMAX <= VMAX_800 when resolution = '1' else VMAX_640;

   IMAGE_START_POS_H_OUT <= IMAGE_START_POS_H;
   IMAGE_START_POS_V_OUT <= IMAGE_START_POS_V;
   IMAGE_END_POS_H_OUT <= IMAGE_END_POS_H;
   IMAGE_END_POS_V_OUT <= IMAGE_END_POS_V;
   HMAX_OUT <= HMAX;
   VMAX_OUT <= VMAX;

   ---------------------------------------------------------------------
   -- DELAY INPUT SIGNALS
   ---------------------------------------------------------------------   

   prev_left <= left when rising_edge(clk);
   prev_right <= right when rising_edge(clk);
   prev_switch <= switch when rising_edge(clk);

   delayed_set_width_in <= set_width_in when rising_edge(clk);
   delayed_set_height_in <= set_height_in when rising_edge(clk);

   ---------------------------------------------------------------------
   -- WIDTH, HEIGHT and NUM PIXELS
   ---------------------------------------------------------------------

   -- compute new total number of pixels when new width or new height
   -- is received and inform image_controller
   -- delayed set_width_in and set_height_in are used, to allow for
   -- computation of new width and height (see process below)
   process(clk)
   variable product: std_logic_vector(17 downto 0) := (others => '0');
   begin
      if(rising_edge(clk)) then
         NEW_NUM_PIXELS_OUT <= '0';
         if(delayed_set_width_in = '1' or delayed_set_height_in = '1')
         then
            product := (WIDTH * HEIGHT) - 1;
            -- the product cannot be greater than 16K-1, due to max
            -- image size
            NUM_PIXELS_OUT <= product(13 downto 0);
            NEW_NUM_PIXELS_OUT <= '1';
         end if;
      end if;
   end process;
   
   -- if new image width is received, compute new default
   -- image positions for both used resolutions
   -- received width (WIDTH_IN) is in range 0-255 and 1 is
   -- added to it to transform to range (1-256)
   -- Note: the software running on the computer should
   -- send width-1 as the image width
   do_width: process(clk)
   variable upper_x_640: std_logic_vector(9 downto 0);
   variable upper_x_800: std_logic_vector(9 downto 0);
   variable lower_x_640: std_logic_vector(9 downto 0);
   variable lower_x_800: std_logic_vector(9 downto 0);
   begin
      if(rising_edge(clk)) then
         -- no new width dimension yet
         new_x_dimension <= '0';
         if(set_width_in = '1') then
            -- adjust width to range 1-256 (WIDTH has 9 bits)
            WIDTH <= ('0' & WIDTH_IN) + 1;
            -- compute HMAX - WIDTH, which is double the
            -- horizontal value for the new upper-left corner
            upper_x_640 := (HMAX_640 - (("00" & WIDTH_IN) + 1));
            upper_x_800 := (HMAX_800 - (("00" & WIDTH_IN) + 1));
            -- divide upper_x by 2 and add the new width to obtain
            -- the horizontal value for the new lower-right corner
            lower_x_640 := ("0" & upper_x_640(9 downto 1)) +
                           (("00" & WIDTH_IN) + 1);
            lower_x_800 := ("0" & upper_x_800(9 downto 1)) +
                           (("00" & WIDTH_IN) + 1);
            -- assign new bounds to the registers holding default
            -- position
            DEFAULT_IMAGE_START_POS_H_640 <= 
                                          "0" & upper_x_640(9 downto 1);
            DEFAULT_IMAGE_END_POS_H_640 <= lower_x_640;
            DEFAULT_IMAGE_START_POS_H_800 <= 
                                          "0" & upper_x_800(9 downto 1);
            DEFAULT_IMAGE_END_POS_H_800 <= lower_x_800;
            -- announce new width
            new_x_dimension <= '1';
         end if;
      end if;
   end process do_width;

   -- if new image height is received, compute new default
   -- image positions for both used resolutions
   -- received height (HEIGHT_IN) is in range 0-255 and 1 is
   -- added to it to transform to range (1-256)
   -- Note: the software running on the computer should
   -- send height-1 as the image height
   do_height: process(clk)
   variable upper_y_640: std_logic_vector(9 downto 0);
   variable upper_y_800: std_logic_vector(9 downto 0);
   variable lower_y_640: std_logic_vector(9 downto 0);
   variable lower_y_800: std_logic_vector(9 downto 0);
   begin
      if(rising_edge(clk)) then
         -- no new height dimension yet
         new_y_dimension <= '0';
         if(set_height_in = '1') then
            -- adjust height to range 1-256 (HEIGHT has 9 bits)
            HEIGHT <= ('0' & HEIGHT_IN) + 1;
            -- compute VMAX - HEIGHT, which is double the
            -- vertical value for the new upper-left corner
            upper_y_640 := (VMAX_640 - (("00" & HEIGHT_IN) + 1));
            upper_y_800 := (VMAX_800 - (("00" & HEIGHT_IN) + 1));
            -- divide upper_y by 2 and add the new height to obtain
            -- the vertical value for the new lower-right corner
            lower_y_640 := ("0" & upper_y_640(9 downto 1)) +
                           (("00" & HEIGHT_IN) + 1);
            lower_y_800 := ("0" & upper_y_800(9 downto 1)) +
                           (("00" & HEIGHT_IN) + 1);
            -- assign new bounds to the registers holding default
            -- position
            DEFAULT_IMAGE_START_POS_V_640 <= 
                                          "0" & upper_y_640(9 downto 1);
            DEFAULT_IMAGE_END_POS_V_640 <= lower_y_640;
            DEFAULT_IMAGE_START_POS_V_800 <= 
                                          "0" & upper_y_800(9 downto 1);
            DEFAULT_IMAGE_END_POS_V_800 <= lower_y_800;
            -- announce new height
            new_y_dimension <= '1';
         end if;
      end if;
   end process do_height;

   ---------------------------------------------------------------------
   -- MOUSE MOTION
   ---------------------------------------------------------------------
      
   -- precompute xpos + WIDTH
   do_xpos_plus_WIDTH: process(clk)
   begin
      if(rising_edge(clk)) then
         xpos_plus_WIDTH <= xpos + WIDTH;
      end if;
   end process do_xpos_plus_WIDTH;

   -- precompute ypos + HEIGHT
   do_ypos_plus_HEIGHT: process(clk)
   begin
      if(rising_edge(clk)) then
         ypos_plus_HEIGHT <= ypos + HEIGHT;
      end if;
   end process do_ypos_plus_HEIGHT;

   -- this process determines if a drag operation is performed
   -- and activates drag_active accordingly
   do_drag_active: process(clk)
   begin
      if(rising_edge(clk)) then
         -- if just pressed left or right mouse button
         if((left = '1' and prev_left = '0') or
            (right = '1' and prev_right = '0')) then
            -- then, if click was within image bounds
            if(xpos >= IMAGE_START_POS_H and xpos < IMAGE_END_POS_H and
               ypos >= IMAGE_START_POS_V and ypos < IMAGE_END_POS_V)
            then
               -- a drag operation began
               drag_active <= '1';
            else
               -- click out off image bounds
               drag_active <= '0';
            end if;
         -- else if mouse left or right button down and drag_active is
         -- high, the drag operation was not finished yet, and
         -- drag_active is kept high
         elsif(drag_active = '1' and (left = '1' or right = '1')) then
            drag_active <= '1';
         -- there is no active drag operation
         else
            drag_active <= '0';
         end if;
      end if;
   end process do_drag_active;

   -- if user just click (or right-clicked), compute
   -- the difference on horizontal axis and vertical axis
   -- from the mouse position and the upper left image corner
   -- This difference will be subtracted from the mouse position
   -- when image is dragged to compute image left upper corner
   diffs: process(clk)
   begin
      if(rising_edge(clk)) then
         if((left  = '1' and prev_left  = '0') or
            (right = '1' and prev_right = '0'))
         then
            xdiff <= xpos - IMAGE_START_POS_H;
            ydiff <= ypos - IMAGE_START_POS_V;
         end if;  
      end if;
   end process diffs;

   ---------------------------------------------------------------------
   -- MULTISTAGE COMPUTING OF NEW BOUNDS
   ---------------------------------------------------------------------

   -- one process synchronous FSM description for the new image
   -- bounds computation
   -- Multistaging is necessary not to increase over 10ns the
   -- maximum clock period, so the design can run at 100MHz
   pipeline: process(clk)
   begin
      if(rising_edge(clk)) then
         case pipeline_state is
            
            -- wait for the user to begin dragging the image
            -- with the mouse and go to stage1 else wait some
            -- more in idle state.
            when idle =>
               if(drag_active = '1') then                  
                  pipeline_state <= stage1;
               else
                  pipeline_state <= idle;
               end if;

            -- perform stage1 of the computation
            -- intermediary new image position
            when stage1 =>
               pipeline_state <= stage2;
            
            -- perform stage2 of the computation
            -- saturation of intermediary position
            when stage2 =>
               pipeline_state <= idle;

         end case;
      end if;
   end process pipeline;
   
   -- first stage of the computation
   -- assign values to new_upper_x,new_upper_y,new_lower_x,new_lower_y
   -- by subtracting original difference (xdiff and ydiff) from xpos,
   -- ypos and precomputed xpos+WIDTH and ypos+HEIGHT,
   -- or if mouse wheel movement occurred, by adding or
   -- subtracting Z_INCREMENT from current image position.
   move_stage_1: process(clk)
   begin
      if(rising_edge(clk)) then
         -- no mouse wheel movement yet
         z_movement <= '0';
         -- if stage1 of computation
         -- compute new intermediary position of image
         if(pipeline_state = stage1) then
            new_upper_x <= xpos - xdiff;
            new_upper_y <= ypos - ydiff;
            new_lower_x <= xpos_plus_WIDTH - xdiff;
            new_lower_y <= ypos_plus_HEIGHT - ydiff;
         -- else if some mouse event
         elsif(new_event = '1') then
            -- and mouse wheel moved
            if(zpos /= "0000") then
               -- mouse wheel movement detected
               z_movement <= '1';
               -- positive movement of mouse wheel
               if(zpos(3) = '0') then
                  -- if middle button up, do vertical movement
                  if(middle = '0') then
                     new_upper_x <= IMAGE_START_POS_H;
                     new_upper_y <= IMAGE_START_POS_V + Z_INCREMENT;
                     new_lower_x <= IMAGE_END_POS_H;
                     new_lower_y <= IMAGE_END_POS_V + Z_INCREMENT;
                  -- if middle button down, do horizontal movement
                  else
                     new_upper_x <= IMAGE_START_POS_H + Z_INCREMENT;
                     new_upper_y <= IMAGE_START_POS_V;
                     new_lower_x <= IMAGE_END_POS_H + Z_INCREMENT;
                     new_lower_y <= IMAGE_END_POS_V;
                  end if;
               -- negative movement of mouse wheel
               else                  
                  -- if middle button up, do vertical movement
                  if(middle = '0') then
                     new_upper_x <= IMAGE_START_POS_H;
                     new_upper_y <= IMAGE_START_POS_V - Z_INCREMENT;
                     new_lower_x <= IMAGE_END_POS_H;
                     new_lower_y <= IMAGE_END_POS_V - Z_INCREMENT;
                  -- if middle button down, do horizontal movement
                  else
                     new_upper_x <= IMAGE_START_POS_H - Z_INCREMENT;
                     new_upper_y <= IMAGE_START_POS_V;
                     new_lower_x <= IMAGE_END_POS_H - Z_INCREMENT;
                     new_lower_y <= IMAGE_END_POS_V;
                  end if;
               end if;
            end if;
         end if;
      end if;
   end process move_stage_1;

   -- second stage of the computation
   -- do saturation of movement, for the image not to leave
   -- the screen in any direction
   -- also, if just switched resolution of received new image dimensions
   -- then reset image position to defaults (center image).
   move_stage_2: process(clk)
   begin
      if(rising_edge(clk)) then
         -- if just switched resolution or received new image
         -- dimensions, reset position to default values (center image)
         if(switch = '1' or prev_switch = '1' or
            new_x_dimension  = '1' or new_y_dimension = '1')
         then
            -- if resolution is 800x600
            if(resolution = '1') then
               IMAGE_START_POS_H <= DEFAULT_IMAGE_START_POS_H_800;
               IMAGE_END_POS_H   <= DEFAULT_IMAGE_END_POS_H_800;
               IMAGE_START_POS_V <= DEFAULT_IMAGE_START_POS_V_800;
               IMAGE_END_POS_V   <= DEFAULT_IMAGE_END_POS_V_800;
            -- if resolution is 640x480
            else
               IMAGE_START_POS_H <= DEFAULT_IMAGE_START_POS_H_640;
               IMAGE_END_POS_H   <= DEFAULT_IMAGE_END_POS_H_640;
               IMAGE_START_POS_V <= DEFAULT_IMAGE_START_POS_V_640;
               IMAGE_END_POS_V   <= DEFAULT_IMAGE_END_POS_V_640;
            end if;
         -- if finished computing new position due to image drag
         -- or mouse wheel movement
         elsif(pipeline_state = stage2 or z_movement = '1') then
            -- do not let image leave screen to the right
            if(new_upper_x >= HMAX) then
               IMAGE_START_POS_H <= (others => '0');
               IMAGE_END_POS_H   <= "0" & WIDTH;
            -- do not let image leave screen to the left
            -- new_lower_x would be greater than HMAX if image moved
            -- left when at the left margin of the screen
            elsif(new_lower_x >= HMAX) then
               IMAGE_START_POS_H <= HMAX - WIDTH;
               IMAGE_END_POS_H   <= HMAX;
            -- image is in screen, at least horizontally
            else
               IMAGE_START_POS_H <= new_upper_x;
               IMAGE_END_POS_H   <= new_lower_x;
            end if;
            -- do not let image leave screen downward
            if(new_upper_y >= VMAX) then
               IMAGE_START_POS_V <= (others => '0');
               IMAGE_END_POS_V   <= "0" & HEIGHT;
            -- do not let image leave screen upward
            -- new_lower_y would be greater than VMAX if image moved
            -- up when at the top margin of the screen
            elsif(new_lower_y >= VMAX) then
               IMAGE_START_POS_V <= VMAX - HEIGHT;
               IMAGE_END_POS_V   <= VMAX;
            -- image is in screen, at least vertically
            else
               IMAGE_START_POS_V <= new_upper_y;
               IMAGE_END_POS_V   <= new_lower_y;
            end if;
         end if;
      end if;
   end process move_stage_2;

end Behavioral;