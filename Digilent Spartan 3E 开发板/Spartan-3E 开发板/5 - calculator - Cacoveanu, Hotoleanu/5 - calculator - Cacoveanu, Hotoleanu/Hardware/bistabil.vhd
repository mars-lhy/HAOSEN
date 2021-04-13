----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    bistabil - arhbistabil
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a flip - flop
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--a - input
--clk - clock
--ce - clock enable
--c - output
---------------------------------------------------------------------------------
entity bistabil is
	port (a:in std_logic;
	clk,ce,reset:in std_logic;
	c:out std_logic);
end bistabil;

architecture arhbistabil of bistabil is
begin
	process(clk)
	begin
		if (clk'event) and (clk='1') and (ce='1') then 
			if (reset='1') then c<='0';--syncronously resets the flip - flop
			else c<=a;
			end if;
		end if;
	end process;
end arhbistabil;