------------------------------------------------------------------------
-- keyboard_controller.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains a controller for a ps/2 compatible keyboard
-- device. This controller is a client for the ps2interface module.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- Please read the following article on the web for understanding how
-- to interface a ps/2 keyboard:
-- http://www.computer-engineering.org/ps2keyboard/

-- This controller is implemented as described in the above article.
-- The keyboard controller receives bytes from the ps2interface which in
-- turn, receives them from the keyboard device. Data is received on the
-- rx_data input port, and is validated by the read signal. "read" is
-- active for one clock period when new byte available on rx_data. Data
-- is sent to the ps2interface on the tx_data output port and validated
-- by the write output signal. "write" should be active for one clock
-- period when tx_data contains the command or data to be sent to the
-- keyboard. ps2interface wraps the byte in a 11 bits packet that is
-- sent through the ps/2 port using the ps/2 protocol. Similarly, when
-- the keyboard sends data, the ps2interface receives 11 bits for every
-- byte, extracts the byte from the ps/2 frame, puts it on rx_data and
-- activates read for one clock period. If an error occurs when sending
-- or receiving a frame from the keyboard, the err input goes high for
-- one clock period. When this occurs, the controller enters reset state

-- When in reset state, the controller resets the keyboard and begins an
-- initialization procedure that consists of setting the typematic rate
-- and delay. After each command is sent, or a byte following a command
-- the keyboard send ack (FAh). Ack is waited after sending a byte
-- to the keyboard, and if anything else is received or an error occurs
-- then the keyboard_controller is placed in reset state. After sending
-- a byte to the keyboard and receiving the ack, the ps2interface is
-- waited upon until it enters idle state.

-- When performing reset, the keyboard does the BAT test (Basic
-- Assurance Test) and then send the result of this test: AAh if the
-- results is OK or FCh if the test failed. After done initializing the
-- keyboard, the FSM used to control the communication is placed in idle
-- state where it waits for an event to occur. There are two types of
-- event: MAKE events and BREAK events. MAKE events occur when a key is
-- pressed or when it is held down. The rate at which the MAKE events
-- are sent when the key is held down is set by the typematic rate.
-- A MAKE event consists of a single byte sent or the E0h byte
-- followed by another byte. If a two byte scancode is sent, it is
-- called an extended scancode. Exception to the rule makes the PAUSE/
-- BREAK key which has a rather complex make scancode (E1,14,77,E1,F0,
-- 14,F0,77). A BREAK event occurs when a key is released and the event
-- consists of sending the MAKE scancode of the key preceded by F0h byte
-- if it is a simple scancode or placing the F0h byte between the E0h
-- byte and the last byte.
-- ex: MAKE  scancode for key A: 1Ch
--     BREAK scancode for key A: F0h 1Ch
-- ex: MAKE  scancode for key RIGHT CONTROL: E0h 14h
--     BREAK scancode for key RIGHT CONTROL: E0h F0h 14h
-- Key PAUSE/BREAK does not have a BREAK scancode.
-- There are 3 set of scancodes and this controller implements the
-- second set, which is used by the majority of keyboards.

-- The controller output the ascii code of the key pressed, held down
-- or released on the ascii output pin. If the key doesn't have a
-- corresponding ascii code, 00h is output. Some special keys are not
-- output on ascii pins, but they are used to set or reset flags.
-- These key are: left shift, control, alt, right shift, control, alt,
-- num lock, caps lock, scroll lock. When shift,control or alt is
-- pressed (or held down), no matter left or right one, the
-- corresponding output pin is set high while it is pressed (shift,ctrl
-- and alt output pins). The status of the shift key is also used to
-- select the ascii code from the ascii codes rom. The rom has 256
-- entries, each of 7 bits. From the scancode received only the least
-- significant 7 bits are used to make the address in the rom, because
-- all the scancodes have last byte lower than 80h, so they can be
-- represented on 7 bits, except for the F7 key which is the only key
-- that has the last byte of the scancode 83h. The most significant
-- bit in the memory address is the status of the shift key ('1' if it
-- is down, '0' if not). This way the correct ascii is provided
-- considering if the shift was pressed when pressing another key.
-- ex: output ascii for key 2 is 32h (number 2) when shift is up and
-- it is 40h (@ character) when shift is down.
-- If num lock, caps lock or scroll lock is pressed for the first time,
-- the controller toggles the state of the corresponding led by keeping
-- track of the state of the led and sending the keyboard to change
-- state of the leds, when one of this keys is pressed (if the keys are
-- held down the leds will not change, although receiving MAKE events,
-- because the controller keeps track if the BREAK event for that key
-- was received or not, meaning the key was released).

-- After a scancode is completely received, its ascii code (or 00h if it
-- has none) is output on ascii pins and the ready output pin is set
-- set high for one clock period, for the clients of this controller to
-- know that a new key event occurred. Also, the type of the event
-- (MAKE or BREAK event) is output on the event_type output pin. If the
-- event_type is low, and ready is active, a MAKE event occurred, else
-- if it is high and ready is active, a BREAK event occurred.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk         - global clock signal
-- rst         - global reset signal
-- rx_data     - input pin, 8 bits, from ps2interface
--             - last received byte from the ps2 device.
-- read        - input pin, from ps2interface
--             - active for one clock period when a new byte is
--             - available on rx_data.
-- err         - input pin, from ps2interface
--             - active high for one clock period when error occurs
--             - in the ps2interface when sending or receiving data.
-- busy        - input pin, from ps2interface
--             - when low, ps2interface is in idle state
--             - when high, ps2interface is sending or receiving data.
-- tx_data     - output pin, 8 bits, to ps2interface
--             - byte to be sent to the ps2 device
-- write       - output pin, to ps2interface
--             - high for one clock period when sending a byte to the
--             - ps2 device and the byte is valid on tx_data.
-- ascii       - output pin, 7 bits, to clients of this controller
--             - the ascii code of the most recently pressed or released
--             - key, or 00h if the key has no corresponding ascii code.
-- shift       - output pin, to clients of this controller
--             - state of the left or right (or both) shift keys
--             - '1' if the key is pressed
--             - '0' if it isn't pressed
-- ctrl        - output pin, to clients of this controller
--             - state of the left or right (or both) control keys
--             - '1' if the key is pressed
--             - '0' if it isn't pressed
-- alt         - output pin, to clients of this controller
--             - state of the left or right (or both) alt keys
--             - '1' if the key is pressed
--             - '0' if it isn't pressed
-- event_type  - output pin, to clients of this controller
--             - '0' if a MAKE  event occurred
--             - '1' if a BREAK event occurred
-- ready       - output pin, to clients of this controller
--             - active high for one clock period when a new key
--             - is pressed or released (non special key, see above).
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

-- the keyboard_controller entity declaration
-- read above for behavioral description and port definitions.
entity keyboard_controller is
port(
   clk         : in std_logic;
   rst         : in std_logic;

   rx_data     : in std_logic_vector(7 downto 0);
   read        : in std_logic;
   err         : in std_logic;
   busy        : in std_logic;
   
   tx_data     : out std_logic_vector(7 downto 0);
   write       : out std_logic;
   
   ascii       : out std_logic_vector(6 downto 0);
   shift       : out std_logic;
   ctrl        : out std_logic;
   alt         : out std_logic;
   event_type  : out std_logic;
   ready       : out std_logic
);

-- Attributes instructing the synthesizer to extract
-- distributed memory for all memory inferred for this entity.
-- If these attributes are deleted or commented, the synthesizer
-- would infer block ram for the scancode to ascii rom.
-- If block ram is preferred then please delete or comment
-- the attribute lines.
attribute rom_extract : string;
attribute rom_extract of keyboard_controller: entity is "yes";
attribute rom_style : string;
attribute rom_style of keyboard_controller: entity is "distributed";

end keyboard_controller;

architecture Behavioral of keyboard_controller is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- reset command
constant DO_RESET : std_logic_vector(7 downto 0) := x"FF";
-- acknowledge from the keyboard for sent commands or
-- bytes following commands.
constant ACK      : std_logic_vector(7 downto 0) := x"FA";
-- this byte is sent by the keyboard when the BAT test is successful
constant BAT_OK   : std_logic_vector(7 downto 0) := x"AA";

-- bytes part of the key scancode
-- if a scancode starts with E0 and is followed by a single byte,
-- this means a key has pressed or held down (MAKE event) that has an
-- extended scancode.
-- if a scancode starts with F0 or E0 F0 then a key was released
-- (BREAK event).
constant E0       : std_logic_vector(7 downto 0) := x"E0";
constant F0       : std_logic_vector(7 downto 0) := x"F0";

-- command to set the typematic rate and delay
-- when holding down a key.
constant SET_TYPEMATIC_RATE_AND_DELAY
         : std_logic_vector(7 downto 0) := x"F3";
-- the desired typematic rate and delay
-- (10cps and 0.25s delay)
constant TYPEMATIC_RATE_AND_DELAY
         : std_logic_vector(7 downto 0) := x"0D";
-- the command sent to the keyboard when the leds must be set.                       
constant DO_SET_LEDS : std_logic_vector(7 downto 0) := x"ED";

-- scancode for num lock,caps lock and scroll lock
constant NUM_LOCK    : std_logic_vector(7 downto 0) := x"77";
constant CAPS_LOCK   : std_logic_vector(7 downto 0) := x"58";
constant SCROLL_LOCK : std_logic_vector(7 downto 0) := x"7E";

-- scancodes for left shift,right shift, left control and left alt keys
-- the scancode for right control and right alt are the same as for
-- left control and alt, but their are preceded by E0 (they have
-- extended code).
constant L_SHIFT     : std_logic_vector(7 downto 0) := x"12";
constant R_SHIFT     : std_logic_vector(7 downto 0) := x"59";
constant L_CTRL      : std_logic_vector(7 downto 0) := x"14";
constant L_ALT       : std_logic_vector(7 downto 0) := x"11";

-- constants that identify the type of event that occurred.
-- MAKE event to pressing or holding down a key.
-- BREAK event for releasing a key.
constant MAKE_EVENT  : std_logic := '0';
constant BREAK_EVENT  : std_logic := '1';

type rom is array(0 to 255) of std_logic_vector(6 downto 0);
-- the rom (256x7bits) that is used to translate scancode into ascii
-- the ascii code for a key with scancode x is aciirom('0' & x) when
-- the shift key is not pressed, else it is ascriirom('1' & x).
-- ex: the ascii code for scancode 1Ch(28, key A) is 61h('a') if the
-- shift key is up and 41h('A') if the shift key is down.
-- The scancode is 7 bits width and the address of the memory has 8 bits
-- The most significant bit of the memory address is the state of the
-- shift key ('1' if pressed, '0' if not). This way, the memory is
-- divided into 2 parts: the first half holds ascii codes for keys
-- that are pressed while the shift key is up, and the second half
-- holds the ascii codes for the keys pressed while the shift key is
-- down. For example, if the number 2 key is pressed and the shift is
-- up, then the memory address for the corresponding ascii code is 1Eh
-- and 9Eh for when the shift key is down.
-- Keys that do not have an ascii code (ex: numlock,shift,F1) are mapped
-- to ascii code 00h.
constant asciirom: rom := (

-- WITH SHIFT UP

"0000000", -- 00
"0000000", -- 01  F9
"0000000", -- 02
"0000000", -- 03  F5
"0000000", -- 04  F3
"0000000", -- 05  F1
"0000000", -- 06  F2
"0000000", -- 07  F12
"0000000", -- 08
"0000000", -- 09  F10
"0000000", -- 0A  F8
"0000000", -- 0B  F6
"0000000", -- 0C  F4
"0001001", -- 0D  TAB
"1100000", -- 0E  `
"0000000", -- 0F
"0000000", -- 10
"0000000", -- 11  L_ALT
"0000000", -- 12  L_SHIFT
"0000000", -- 13
"0000000", -- 14  L_CTRL
"1110001", -- 15  Q
"0110001", -- 16  1
"0000000", -- 17
"0000000", -- 18
"0000000", -- 19
"1111010", -- 1A  Z
"1110011", -- 1B  S
"1100001", -- 1C  A
"1110111", -- 1D  W
"0110010", -- 1E  2
"0000000", -- 1F
"0000000", -- 20
"1100011", -- 21  C
"1111000", -- 22  X
"1100100", -- 23  D
"1100101", -- 24  E
"0110100", -- 25  4
"0110011", -- 26  3
"0000000", -- 27
"0000000", -- 28
"0100000", -- 29  SPACE
"1110110", -- 2A  V
"1100110", -- 2B  F
"1110100", -- 2C  T
"1110010", -- 2D  R
"0110101", -- 2E  5
"0000000", -- 2F
"0000000", -- 30
"1101110", -- 31  N
"1100010", -- 32  B
"1101000", -- 33  H
"1100111", -- 34  G
"1111001", -- 35  Y
"0110110", -- 36  6
"0000000", -- 37
"0000000", -- 38
"0000000", -- 39
"1101101", -- 3A  M
"1101010", -- 3B  J
"1110101", -- 3C  U
"0110111", -- 3D  7
"0111000", -- 3E  8
"0000000", -- 3F
"0000000", -- 40
"0101100", -- 41  ,
"1101011", -- 42  K
"1101001", -- 43  I
"1101111", -- 44  O
"0110000", -- 45  0
"0111001", -- 46  9
"0000000", -- 47
"0000000", -- 48
"0101110", -- 49  .
"0101111", -- 4A  /
"1101100", -- 4B  L
"0111011", -- 4C  ;
"1110000", -- 4D  P
"0101101", -- 4E  -
"0000000", -- 4F
"0000000", -- 50
"0000000", -- 51
"0100111", -- 52  '
"0000000", -- 53
"1011011", -- 54  [
"0111101", -- 55  =
"0000000", -- 56
"0000000", -- 57
"0000000", -- 58  CAPS
"0000000", -- 59  R_SHIFT
"0001010", -- 5A  ENTER
"1011101", -- 5B  ]
"0000000", -- 5C
"1011100", -- 5D  \
"0000000", -- 5E
"0000000", -- 5F
"0000000", -- 60
"0000000", -- 61
"0000000", -- 62
"0000000", -- 63
"0000000", -- 64
"0000000", -- 65
"0001000", -- 66  BACKSPACE
"0000000", -- 67
"0000000", -- 68
"0110001", -- 69  KP 1
"0000000", -- 6A
"0110100", -- 6B  KP 4
"0110111", -- 6C  KP 7
"0000000", -- 6D
"0000000", -- 6E
"0000000", -- 6F
"0110000", -- 70  KP 0
"0101110", -- 71  KP .
"0110010", -- 72  KP 2
"0110101", -- 73  KP 5
"0110110", -- 74  KP 6
"0111000", -- 75  KP 8
"0011011", -- 76  ESCAPE
"0000000", -- 77  NUM_LOCK
"0000000", -- 78  F11
"0101011", -- 79  KP +
"0110011", -- 7A  KP 3
"0101101", -- 7B  KP -
"0101010", -- 7C  KP *
"0111001", -- 7D  KP 9
"0000000", -- 7E  SCROLL_LOCK
"0000000", -- 7F

-- WITH SHIFT DOWN

"0000000", -- 00
"0000000", -- 01  F9
"0000000", -- 02
"0000000", -- 03  F5
"0000000", -- 04  F3
"0000000", -- 05  F1
"0000000", -- 06  F2
"0000000", -- 07  F12
"0000000", -- 08
"0000000", -- 09  F10
"0000000", -- 0A  F8
"0000000", -- 0B  F6
"0000000", -- 0C  F4
"0001001", -- 0D  TAB
"1111110", -- 0E  ~
"0000000", -- 0F
"0000000", -- 10
"0000000", -- 11  L_ALT
"0000000", -- 12  L_SHIFT
"0000000", -- 13
"0000000", -- 14  L_CTRL
"1010001", -- 15  Q
"0010001", -- 16  !
"0000000", -- 17
"0000000", -- 18
"0000000", -- 19
"1011010", -- 1A  Z
"1010011", -- 1B  S
"1000001", -- 1C  A
"1010111", -- 1D  W
"1000000", -- 1E  @
"0000000", -- 1F
"0000000", -- 20
"1000011", -- 21  C
"1011000", -- 22  X
"1010100", -- 23  D
"1000101", -- 24  E
"0100100", -- 25  $
"0100011", -- 26  #
"0000000", -- 27
"0000000", -- 28
"0100000", -- 29  SPACE
"1010110", -- 2A  V
"1000110", -- 2B  F
"1010100", -- 2C  T
"1010010", -- 2D  R
"0100101", -- 2E  %
"0000000", -- 2F
"0000000", -- 30
"1001110", -- 31  N
"1000010", -- 32  B
"1001000", -- 33  H
"1000111", -- 34  G
"1011001", -- 35  Y
"1011110", -- 36  ^
"0000000", -- 37
"0000000", -- 38
"0000000", -- 39
"1001101", -- 3A  M
"1001010", -- 3B  J
"1010101", -- 3C  U
"0100110", -- 3D  &
"0101010", -- 3E  *
"0000000", -- 3F
"0000000", -- 40
"0111100", -- 41  <
"1001011", -- 42  K
"1001001", -- 43  I
"1001111", -- 44  O
"0101001", -- 45  )
"0101000", -- 46  (
"0000000", -- 47
"0000000", -- 48
"0111110", -- 49  >
"0111111", -- 4A  ?
"1001100", -- 4B  L
"0111010", -- 4C  :
"1010000", -- 4D  P
"1011111", -- 4E  _
"0000000", -- 4F
"0000000", -- 50
"0000000", -- 51
"0100010", -- 52  "
"0000000", -- 53
"1111011", -- 54  {
"0101011", -- 55  +
"0000000", -- 56
"0000000", -- 57
"0000000", -- 58  CAPS
"0000000", -- 59  R_SHIFT
"0001010", -- 5A  ENTER
"1111101", -- 5B  }
"0000000", -- 5C
"1111100", -- 5D  |
"0000000", -- 5E
"0000000", -- 5F
"0000000", -- 60
"0000000", -- 61
"0000000", -- 62
"0000000", -- 63
"0000000", -- 64
"0000000", -- 65
"0001000", -- 66  BACKSPACE
"0000000", -- 67
"0000000", -- 68
"0110001", -- 69  KP 1
"0000000", -- 6A
"0110100", -- 6B  KP 4
"0110111", -- 6C  KP 7
"0000000", -- 6D
"0000000", -- 6E
"0000000", -- 6F
"0110000", -- 70  KP 0
"0101110", -- 71  KP .
"0110010", -- 72  KP 2
"0110101", -- 73  KP 5
"0110110", -- 74  KP 6
"0111000", -- 75  KP 8
"0011011", -- 76  ESCAPE
"0000000", -- 77  NUM_LOCK
"0000000", -- 78  F11
"0101011", -- 79  KP +
"0110011", -- 7A  KP 3
"0101101", -- 7B  KP -
"0101010", -- 7C  KP *
"0111001", -- 7D  KP 9
"0000000", -- 7E  SCROLL_LOCK
"0000000"  -- 7F
);

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

-- the states of the FSM that controls the communication with the
-- keyboard. States that end in "_wait_ack" wait for the ack (FAh)
-- from the keyboard, after sending a command or a following byte.
-- States that end in "_wait_not_busy" wait for the busy signal from
-- the ps2interface to go low, meaning ps2interface is in idle state,
-- so a byte (command or following data) can be sent to the keyboard.
type fsm_state is
(
   reset,reset_wait_ack,wait_bat_completion,bat_wait_not_busy,
   set_typematic,set_typematic_wait_ack,set_typematic_wait_not_busy,
   send_typematic,send_typematic_wait_ack,send_typematic_wait_not_busy,
   idle,new_key,normal,normal_wait_not_busy,extended,break,
   extended_received,break_received,set_leds,set_leds_wait_ack,
   set_leds_wait_not_busy,send_leds,send_leds_wait_ack,
   send_leds_wait_not_busy,data_ready
);
-- current state of the FSM. Implicitly reset.
signal state: fsm_state := reset;

-- register to hold the received data from the ps2interface
-- loaded when read = '1'
-- needed because value on rx_data might change during processing
-- of the previously received value and the original value
-- would be lost.
signal received_data: std_logic_vector(7 downto 0) := (others => '0');

-- state of the shift,ctrl and alt keys
-- '0' if up
-- '1' if down
signal shift_down,ctrl_down,alt_down: std_logic := '0';

-- state of the numlock, capslock and scrolllock leds.
-- if '0' leds should be disabled
-- if '1' leds should be enabled
signal num,caps,scroll: std_logic := '0';

-- intermediary signals to hold the information
-- whether the break code was received for num,caps and scroll locks
-- Prevents the toggling of the leds while corresponding keys are
-- held down.
signal received_num_break     : std_logic := '1';
signal received_caps_break    : std_logic := '1';
signal received_scroll_break  : std_logic := '1';

-- data read from the asciirom.
-- represents the ascii code of the scancode received.
signal asciirom_output: std_logic_vector(6 downto 0) := (others => '0');

begin

   -- output the state of the shift,control and alt keys
   shift <= shift_down;
   ctrl <= ctrl_down;
   alt <= alt_down;

   -- the ascii code for the most recently received scancode
   -- the most significant bit of the memory address is shift_down
   -- to select between the ascii codes the the was pressed
   -- with the shift down or not.
   asciirom_output <= 
    asciirom(conv_integer(shift_down & received_data(6 downto 0)))
    when rising_edge(clk);

   -- one process synchronous FSM for managing the communication
   -- with the keyboard
   -- When reset or powered-up, the FSM enters reset state.
   -- From reset state, the FSM transition through a series of
   -- states that initialize the keyboard.
   -- When the keyboard is initialized, it enters idle state
   -- and wait for an event to occur.
   manage_fsm: process(clk,rst)
   begin
      if(rst = '1') then
         state <= reset;
      elsif(rising_edge(clk)) then
         
         -- default values for write and ready signals
         -- ensures only active for one clock period
         -- since FSM transition on the next rising edge
         -- of the clock from the state that activated these
         -- signals.
         write <= '0';
         ready <= '0';

         case state is

            -- send the reset command to the keyboard
            -- and reset status signals.
            when reset =>
               tx_data <= DO_RESET;
               write <= '1';
               shift_down <= '0';
               ctrl_down <= '0';
               alt_down <= '0';
               received_num_break <= '1';
               received_caps_break <= '1';
               received_scroll_break <= '1';
               num <= '0';
               caps <= '0';
               scroll <= '0';
               state <= reset_wait_ack;

            -- wait ack for sending the reset command
            -- if anything else is received, or an error occurs
            -- go to reset state.
            when reset_wait_ack =>
               if(read = '1') then
                  if(rx_data = ACK) then
                     state <= wait_bat_completion;
                  else
                     state <= reset;
                  end if;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= reset_wait_ack;
               end if;

            -- wait for the keyboard to send the BAT completion
            -- test result. If received BAT_OK, go to bat_wait_not_busy
            -- else go to reset state.
            when wait_bat_completion =>
               if(read = '1') then
                  if(rx_data = BAT_OK) then
                     state <= bat_wait_not_busy;
                  else
                     state <= reset;
                  end if;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= wait_bat_completion;
               end if;

            -- wait for the ps2interface to be idle
            -- to be able to send a new command
            when bat_wait_not_busy =>
               if(busy = '0') then
                  state <= set_typematic;
               else
                  state <= bat_wait_not_busy;
               end if;

            -- send the set typematic rate and delay command
            when set_typematic =>
               tx_data <= SET_TYPEMATIC_RATE_AND_DELAY;
               write <= '1';
               state <= set_typematic_wait_ack;

            -- wait ack for sending the command
            when set_typematic_wait_ack =>
               if(read = '1') then
                  if(rx_data = ACK) then
                     state <= set_typematic_wait_not_busy;
                  else
                     state <= reset;
                  end if;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= set_typematic_wait_ack;
               end if;

            -- wait for the ps2interface to be idle
            -- to be able to send a new command
            when set_typematic_wait_not_busy =>
               if(busy = '0') then
                  state <= send_typematic;
               else
                  state <= set_typematic_wait_not_busy;
               end if;

            -- send the typematic rate and delay value
            when send_typematic =>
               tx_data <= TYPEMATIC_RATE_AND_DELAY;
               write <= '1';
               state <= send_typematic_wait_ack;

            -- wait ack for sending the typematic rate and delay value
            when send_typematic_wait_ack =>
               if(read = '1') then
                  if(rx_data = ACK) then
                     state <= send_typematic_wait_not_busy;
                  else
                     state <= reset;
                  end if;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= send_typematic_wait_ack;
               end if;

            -- wait for the ps2interface to be idle
            -- and go to idle state and wait for events
            when send_typematic_wait_not_busy =>
               if(busy = '0') then
                  state <= idle;
               else
                  state <= send_typematic_wait_not_busy;
               end if;

            -- wait for events, and when one occurs
            -- save the data on rx_data in received_data.
            -- After this, transition to new_key, to
            -- figure out what kind of an event this is.
            -- If error occurs, go to reset state.
            when idle =>
               if(read = '1') then
                  received_data <= rx_data;
                  state <= new_key;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= idle;
               end if;
               
            -- if received data is E0 then extended
            -- make or break code will be received, go to extended.
            -- else if received F0, break code will be received,
            -- go to break state, else this is a simple make code,
            -- go to normal state.
            when new_key =>
               if(received_data = E0) then
                  state <= extended;
               elsif(received_data = F0) then
                  state <= break;
               else
                  state <= normal;
               end if;

            -- if received a simple make code,
            -- determine if a special key was pressed (or held down)
            -- if left shift or right shift was pressed set high
            -- shift_down. Similarly for left control and alt.
            -- If numlock was pressed, and this is the first time
            -- a make event occurs for numlock after receiving
            -- its break code, then toggle the state of the numlock
            -- led status register and mark that break code not received
            -- yet. Similarly for caps lock and scroll lock.
            -- If the leds status has changes, go to normal_wait_not_busy
            -- to send the keyboard the new leds status.
            -- If this is a normal key, mark this is a make event and
            -- go to data_ready state.
            when normal =>
               if(received_data = L_SHIFT) then
                  shift_down <= '1';
                  state <= idle;
               elsif(received_data = R_SHIFT) then
                  shift_down <= '1';
                  state <= idle;
               elsif(received_data = L_CTRL) then
                  ctrl_down <= '1';
                  state <= idle;
               elsif(received_data = L_ALT) then
                  alt_down <= '1';
                  state <= idle;
               elsif(received_data = NUM_LOCK) then
                  state <= idle;
                  if(received_num_break = '1') then
                     num <= not num;
                     received_num_break <= '0';
                     state <= normal_wait_not_busy;
                  end if;
               elsif(received_data = CAPS_LOCK) then
                  state <= idle;
                  if(received_caps_break = '1') then
                     caps <= not caps;
                     received_caps_break <= '0';
                     state <= normal_wait_not_busy;
                  end if;
               elsif(received_data = SCROLL_LOCK) then
                  state <= idle;
                  if(received_scroll_break = '1') then
                     scroll <= not scroll;
                     received_scroll_break <= '0';
                     state <= normal_wait_not_busy;
                  end if;
               else
                  event_type <= MAKE_EVENT;
                  state <= data_ready;
               end if;

            -- wait for the ps2interface not to be busy, to be able
            -- to send the set leds status command.
            when normal_wait_not_busy =>
               if(busy = '0') then
                  state <= set_leds;
               else
                  state <= normal_wait_not_busy;
               end if;

            -- the received value was E0h and we wait for
            -- another byte to arrive. When it arrives go to
            -- extended_received.
            when extended =>
               if(read = '1') then
                  received_data <= rx_data;
                  state <= extended_received;
               else
                  state <= extended;
               end if;

            -- the received value was F0 or E0 F0
            -- wait for the final byte to arrive
            -- and go to break_received state.
            when break =>
               if(read = '1') then
                  received_data <= rx_data;
                  state <= break_received;
               else
                  state <= break;
               end if;

            -- the next byte after E0 arrived
            -- if it is F0, this is a break code
            -- and go to break state
            -- else, if it is the scancode for right control
            -- then set high ctrl_down. Do similarly for right alt.
            -- Note: the scancode for left and right ctrl (and alt) is
            -- the same, except right ctrl and alt are extended
            -- scancodes
            -- else mark make event and go to data_ready.
            when extended_received =>
               if(received_data = F0) then
                  state <= break;
               elsif(received_data = L_CTRL) then
                  ctrl_down <= '1';
                  state <= idle;
               elsif(received_data = L_ALT) then
                  alt_down <= '1';
                  state <= idle;
               else
                  event_type <= MAKE_EVENT;
                  state <= data_ready;
               end if;

            -- received byte after F0 (or after E0 F0)
            -- if it is the break code of shift, ctrl or alt
            -- reset shift_down,ctrl_down or alt_down
            -- If it is the break code of num lock, caps lock
            -- or scroll lock, mark that the break code for these
            -- keys has been received, meaning that keys where released
            -- Else, mark break event and go to data_ready.
            when break_received =>
               if(received_data = L_SHIFT) then
                  shift_down <= '0';
                  state <= idle;
               elsif(received_data = R_SHIFT) then
                  shift_down <= '0';
                  state <= idle;
               elsif(received_data = L_CTRL) then
                  ctrl_down <= '0';
                  state <= idle;
               elsif(received_data = L_ALT) then
                  alt_down <= '0';
                  state <= idle;
               elsif(received_data = NUM_LOCK) then
                  received_num_break <= '1';
                  state <= idle;
               elsif(received_data = CAPS_LOCK) then
                  received_caps_break <= '1';
                  state <= idle;
               elsif(received_data = SCROLL_LOCK) then
                  received_scroll_break <= '1';
                  state <= idle;
               else
                  event_type <= BREAK_EVENT;
                  state <= data_ready;
               end if;

            -- send the set leds command to the keyboard
            when set_leds =>
               tx_data <= DO_SET_LEDS;
               write <= '1';
               state <= set_leds_wait_ack;

            -- wait ack for sending the set leds command
            when set_leds_wait_ack =>
               if(read = '1') then
                  if(rx_data = ACK) then
                     state <= set_leds_wait_not_busy;
                  else
                     state <= reset;
                  end if;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= set_leds_wait_ack;
               end if;

            -- wait for ps2interface not to be busy
            when set_leds_wait_not_busy =>
               if(busy = '0') then
                  state <= send_leds;
               else
                  state <= set_leds_wait_not_busy;
               end if;

            -- send the new leds status
            -- led status byte has the following format
            -- bits    7   6   5   4   3    2      1      0
            --       -------------------------------------------
            --       | 0 | 0 | 0 | 0 | 0 | caps | num | scroll |
            --       -------------------------------------------
            -- For enabling a led, set its corresponding bit in this
            -- status byte.
            when send_leds =>
               tx_data <= "00000" & caps & num & scroll;
               write <= '1';
               state <= send_leds_wait_ack;

            -- wait ack for sending the leds status byte
            when send_leds_wait_ack =>
               if(read = '1') then
                  if(rx_data = ACK) then
                     state <= send_leds_wait_not_busy;
                  else
                     state <= reset;
                  end if;
               elsif(err = '1') then
                  state <= reset;
               else
                  state <= send_leds_wait_ack;
               end if;

            -- wait for the ps2interface to be idle and
            -- transition to idle state.
            when send_leds_wait_not_busy =>
               if(busy = '0') then
                  state <= idle;
               else
                  state <= send_leds_wait_not_busy;
               end if;

            -- a new key was received, event type is already set
            -- set ready high for one clock period (will be reset
            -- on the next rising edge of the clk by the default
            -- value), output ascii code from memory and transition
            -- to idle state to wait for another event to occur.
            when data_ready =>
               ready <= '1';
               ascii <= asciirom_output;
               state <= idle;

            -- if invalid transition occurred, go to reset state.
            when others =>
               state <= reset;

         end case;
      end if;
   end process manage_fsm;

end Behavioral;