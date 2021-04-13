----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    counter1 - arhcounter1
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a comparator which compares two numbers on 44
--                 bits each and signals if a>=b
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--a and b are the numbers which are compared
--c is the result of the comparison
----------------------------------------------------------------------------------
entity comparator is
	port (a,b:in std_logic_vector(43 downto 0);
	c:out std_logic);
end comparator;

architecture arhcomparator of comparator is
begin
	process(a,b)
	begin
		if (a>=b) then c<='1';
		else c<='0'; 
		end if;
	end process;
end arhcomparator;