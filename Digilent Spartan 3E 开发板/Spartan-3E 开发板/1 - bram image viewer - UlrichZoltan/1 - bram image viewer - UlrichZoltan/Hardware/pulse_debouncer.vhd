------------------------------------------------------------------------
-- pulse_debouncer.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the logic to debounce and create a one clock
-- period width pulse from the input signal. Input signal must be active
-- on '1' logic.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- The input signal(a) must be active on high. The module generates
-- a one clock period width pulse (active on high) from the debounced
-- input signal. For the input to be considered clean, 64 clock periods
-- must pass with it being active.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk      - global clock signal
-- a        - input pin, signal the is debounced and pulse extracted
--          - for it.
-- b        - output pin, the pulse signal obtained from the input a.
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

-- the pulse_debouncer entity declaration
-- read above for behavioral description and port definitions.
entity pulse_debouncer is
Port(
   clk   : in std_logic;
   a     : in std_logic;
   b     : out std_logic
);
end pulse_debouncer;

architecture Behavioral of pulse_debouncer is

-- debounced input signal. Remains on '1' logic while input is '1' logic
-- If input goes low (even for one clock period), filtered_output goes
-- low and stays low until for 2^6 = 64 clock periods the input signal
-- is high.
signal filtered_output: std_logic := '0';

-- intermediary signal to generate the one clock period width pulse
signal temp: std_logic := '0';

-- 6 bit counter, counting is enabled while input signal is high
-- counter is reset is input signal goes low
-- if reaches top value filtered_output goes high and remains high
-- until input signal goes low.
signal counter: std_logic_vector(5 downto 0) := (others => '0');

begin
   
   -- debounces the input signal 'a'
   debounce: process(clk)
   begin
      if(rising_edge(clk)) then
         -- if input low reset counter and reset filtered_output
         if(a = '0') then
            counter <= (others => '0');
            filtered_output <= '0';
         -- else, enable counting and if reached top value
         -- filtered_output goes high.
         else
            counter <= counter + 1;
            if(counter = "111111") then
               filtered_output <= '1';
            end if;
         end if;
      end if;
   end process debounce;

   -- generate the pulse (active for one clock period on '1' logic)
   pulse: process(clk)
   begin
      if(rising_edge(clk)) then
         -- if input signal (filtered_output) goes low
         -- reset output and intermediary signal
         if(filtered_output = '0') then
            temp <= '0';
            b <= '0';
         -- if intermediary signal is low, this is the first
         -- clock period input goes high
         -- put output high
         -- else, this is not the first clock period input
         -- is high, so reset output.
         else
            if(temp = '0') then
               temp <= '1';
               b <= '1';
            else
               b <= '0';
            end if;
         end if;
      end if;
   end process pulse;

end Behavioral;