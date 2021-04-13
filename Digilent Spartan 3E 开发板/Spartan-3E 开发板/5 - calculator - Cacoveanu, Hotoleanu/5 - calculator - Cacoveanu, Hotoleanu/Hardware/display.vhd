----------------------------------------------------------------------------------
-- Create Date:    22:37:45 09/26/2006 
-- Module Name:    display - arhdisplay
-- Project Name:   display
-- Tool versions:  Xilinx 8.1 ISE
-- Author:         Hotoleanu Dan 
-- Description:    This module includes the following modules : counter -
--                 arhcounter , counter_selection - arhcounter_selection , dcd -
--                 arhdcd , registru - arhregistru , mux - arhmux , bcd7segments -
--                 arhbcd7segments.These modules are counected together to form 
--                 the device that receives 4 (cifre) in the form of 4 buses of
--                 4 bits and displays them on the board.                 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--clk - clock
--ce - clock enable
--reset - reset
--point - the point which separates the integer part from the decimal part 
--c3,c2,c1,c0 - the digits that are displayed
--d - this output selects the anode that is going to be used
--e - this output selects which of the segments are going to be active or not.
--opoint - output indicating if the input point is active or not
----------------------------------------------------------------------------------
entity display is
   port (clk,ce,reset,point:in std_logic;
   c3,c2,c1,c0:in std_logic_vector(3 downto 0);
   d:out std_logic_vector(3 downto 0);
   e:out std_logic_vector(6 downto 0);
   opoint:out std_logic);
end display;

architecture arhdisplay of display is
component counterdisplay 
   port (clk,ce,reset:in std_logic;
   a:out std_logic_vector(17 downto 0));
end component;

component counter_selection 
   port (clk,ce,reset:in std_logic;
   a:out std_logic_vector(1 downto 0));
end component;

component dcd 
   port (a:in std_logic_vector(1 downto 0);
	point:in std_logic;
   b:out std_logic_vector(3 downto 0);
	displaypoint:out std_logic);
end component;

component registru 
   port (clk,ce,reset:in std_logic;
   a:in std_logic_vector(3 downto 0);
   b:out std_logic_vector(3 downto 0));
end component;

component mux 
   port (a3,a2,a1,a0:in std_logic_vector(3 downto 0);
   s:in std_logic_vector(1 downto 0);
   b:out std_logic_vector(3 downto 0));
end component; 

component bcd7segments 
   port (a:in std_logic_vector(3 downto 0);
   b:out std_logic_vector(6 downto 0));
end component;

signal iesirecounter:std_logic_vector(17 downto 0);--the state of the component
                                                  --counter
signal intrarecounter_selection:std_logic;--the input of the component
                                          --counter_selection and the least
                                          --significant bit of the output
                                          --of the component counter
signal iesirecounter_selection:std_logic_vector(1 downto 0);--the output of the
                                                            --component
                                                            --counter_selection.
                                                            --it is the input for
                                                            --the component dcd.
signal iesireregistru3,iesireregistru2,iesireregistru1,
       iesireregistru0,iesiremux:std_logic_vector(3 downto 0);
--signals iesireregistru3, iesireregistru2, iesireregistru1 and
--iesireregistru0 are the outputs of the registers that store the (cifra).These
--signals are inputs for the multiplexer.Signal ieisremux is the output of the 
--multiplexer and is input for the component bcd7segments.
signal displaypoint:std_logic;--this signal is used to generate the clock impulse
                              --for the flip-flop which stores the point between
										--the integer and the decimal part of the number							
						
begin
   comp1: counterdisplay port map(clk,ce,reset,iesirecounter);
   comp2: counter_selection port map (iesirecounter(17),ce,reset,
	       iesirecounter_selection);
   comp3: dcd port map (iesirecounter_selection,point,d,opoint);
   comp4: registru port map (clk,ce,reset,c3,iesireregistru3);
   comp5: registru port map (clk,ce,reset,c2,iesireregistru2);
   comp6: registru port map (clk,ce,reset,c1,iesireregistru1);
   comp7: registru port map (clk,ce,reset,c0,iesireregistru0); 
   comp8: mux port map (iesireregistru3,iesireregistru2,
	       iesireregistru1,iesireregistru0,iesirecounter_selection,iesiremux);
   comp9: bcd7segments port map (iesiremux,e);
end arhdisplay;