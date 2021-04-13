----------------------------------------------------------------------------------
-- Create Date:    22:37:45 09/17/2006 
-- Module Name:    registrusimplu - arhregistrusimplu
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a register which store data on 11 buses of 4
--                 bits width.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--a,b,c,d,e,f,g,h,i,j,k are the input buses which form the digits
--of the number.
--clk is the clock signal, ce is the clock enable signal and reset is the 
--reset signal
--ao,bo,co,do,eo,fo,go,ho,io,jo,ko are the outputs.
----------------------------------------------------------------------------------
entity registrusimplu is
	port (a,b,c,d,e,f,g,h,i,j,k:in std_logic_vector(3 downto 0);
	clk,ce,reset:in std_logic;
	ao,bo,co,do,eo,fo,go,ho,io,jo,ko:out std_logic_vector(3 downto 0));
end registrusimplu;

architecture arhregistrusimplu of registrusimplu is
begin
	process(clk)
	begin
		if (clk'event) and (clk='1') and (ce='1') then
			if (reset='1') then ao<="0000";--syncronously resets the register
								bo<="0000";
								co<="0000";
								do<="0000";													
								eo<="0000";
								fo<="0000";
								go<="0000";
								ho<="0000";
								io<="0000";
								jo<="0000";
								ko<="0000";
							else ao<=a;--the inputs are stored in the register
								bo<=b;
								co<=c;
								do<=d;													
								eo<=e;
								fo<=f;
								go<=g;
								ho<=h;
								io<=i;
								jo<=j;
								ko<=k;
			end if;
		end if;
	end process;
end arhregistrusimplu;