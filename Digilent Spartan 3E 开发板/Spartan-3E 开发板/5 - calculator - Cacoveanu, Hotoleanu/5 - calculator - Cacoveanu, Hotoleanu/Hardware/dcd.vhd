----------------------------------------------------------------------------------
-- Create Date:    21:58:14 09/26/2006 
-- Module Name:    dcd - arhdcd
-- Project Name:   display
-- Tool versions:  Xilinx 8.1 ISE
-- Author:         Hotoleanu Dan 
-- Description:    This module is a decoder with the entrance on 2 bits.It 
--                 consists of an entrance on 2 bits(a) and an emergence on 4 
--                 bits(b).Depending on the combination of the 2 bits of entrance 
--                 one of the bits of the emergence will be active and the other                 
--                 bits of the emrgence will be inactive.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity dcd is
   port (a:in std_logic_vector(1 downto 0); --a is the input.
	point:in std_logic;--if point is '1' then the output displaypoint is '1' else 
	                   --it is '0'
   b:out std_logic_vector(3 downto 0);--b is the output.
	displaypoint:out std_logic);--displaypoint is the clock signal for the
                               --flip-flop which stores the point between
                               --the integer and the decimal part of the number										 
end dcd;

architecture arhdcd of dcd is
begin                                
   process(a)                        
	begin
	--the following code selects, depending on the input , the combination of the 
	--output sequence such that only one (anod) is active.'0' is the active bit.
	--it also decides if the point is going to be diplayed or not
	case a is 
	when "11" => b<="0111";
	             displaypoint<='1';
	when "10" => b<="1011";
	             if (point='1') then displaypoint<='0';
					 else displaypoint<='1';
					 end if;
	when "01" => b<="1101";
	             displaypoint<='1';
	when "00" => b<="1110";
	             displaypoint<='1';
	when others => b<="1111";
	               displaypoint<='1';
	end case;
   end process;
end arhdcd;