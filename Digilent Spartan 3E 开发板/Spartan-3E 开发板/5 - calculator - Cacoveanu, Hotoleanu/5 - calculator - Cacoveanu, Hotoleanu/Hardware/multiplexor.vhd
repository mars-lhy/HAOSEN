----------------------------------------------------------------------------------
-- Create Date:    20:29:45 09/17/2006 
-- Module Name:    multiplexor - arhmultiplexor
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a multiplexer that receives data on 22 buses of
--                 4 bits width.This data is organized into two numbers, one that
--                 contains the digits on the buses denoted with a(number) and one 
--                 that contains the digits on the buses denoted with b(number)  
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0 are the 
--input buses: a(number) the first bus and b(number) the second bus.
--s selection bit, selects between the numbers a and b
--sa and sb selection buses, select between the digits of the number a or b
--c outup bus(a digit), the result of the selection
----------------------------------------------------------------------------------
entity multiplexor is
	port (a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,
	b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0:in std_logic_vector(3 downto 0);
	sa:in std_logic_vector(3 downto 0);
	sb:in std_logic_vector(3 downto 0);
	s:in std_logic;
	c:out std_logic_vector(3 downto 0));
end multiplexor;

architecture arhmultiplexor of multiplexor is
begin			  
	process(s,sa,sb,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,
	b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0)
	begin	
		if (s='1') then --selects between the numberas a or b
		                --s='1' means the multiplexer selects the number b
			if (sb="1010") then c<=b10;--selects between the digits of the number b
			elsif (sb="1001") then c<=b9;
			elsif (sb="1000") then c<=b8;
			elsif (sb="0111") then c<=b7;
			elsif (sb="0110") then c<=b6;
			elsif (sb="0101") then c<=b5;
			elsif (sb="0100") then c<=b4;
			elsif (sb="0011") then c<=b3;
			elsif (sb="0010") then c<=b2;
			elsif (sb="0001") then c<=b1;
			elsif (sb="0000") then c<=b0;
			end if;
			elsif (s='0') then --s='0' means that the number a is selected 
			if (sa="1010") then c<=a10;--selects between the digits of the number a
			elsif (sa="1001") then c<=a9;
			elsif (sa="1000") then c<=a8;
			elsif (sa="0111") then c<=a7;
			elsif (sa="0110") then c<=a6;
			elsif (sa="0101") then c<=a5;
			elsif (sa="0100") then c<=a4;
			elsif (sa="0011") then c<=a3;
			elsif (sa="0010") then c<=a2;
			elsif (sa="0001") then c<=a1;
			elsif (sa="0000") then c<=a0;
			end if;
		end if;
	end process;
end arhmultiplexor;