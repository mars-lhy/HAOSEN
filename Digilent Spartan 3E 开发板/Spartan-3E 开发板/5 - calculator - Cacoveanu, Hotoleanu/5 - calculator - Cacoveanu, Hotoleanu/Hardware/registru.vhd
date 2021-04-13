----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    registru - arhregistru
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a register that stores data
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
---------------------------------------------------------------------------------
--a - input for the digit
--clk - clock
--ce - clock enable
--reset - reset
--b - the output stores the digit
---------------------------------------------------------------------------------
entity registru is
	port (a:in std_logic_vector(3 downto 0);
	clk,ce,reset:in std_logic;
	b:out std_logic_vector(3 downto 0));
end registru;

architecture arhregistru of registru is
begin
	process(clk)
	begin
		if (clk'event) and (clk='1') and (ce='1') then 
			if (reset='1') then b<="0000";--resets the register
			else b<=a;
			end if;
		end if;
	end process;
end arhregistru;