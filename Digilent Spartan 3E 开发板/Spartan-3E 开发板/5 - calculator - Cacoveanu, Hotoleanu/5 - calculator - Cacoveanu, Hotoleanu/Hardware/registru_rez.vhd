----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    registru_rez - arhregistru_rez
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a register which shifts to the right a digit
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--a - the input for the digit
--clk - clock 
--ce - clock enable
--reset - reset 
--b,c,d,e,f,g,h,i,j,k,l - the number obtained by shifting the entering digits
--------------------------------------------------------------------------------

entity registru_rez is
	port (a:in std_logic_vector(3 downto 0);
	clk,ce,reset:in std_logic;
	b,c,d,e,f,g,h,i,j,k,l:out std_logic_vector(3 downto 0));
end registru_rez;

architecture arhregistru_rez of registru_rez is
begin	
	process(clk)
	variable bo,co,do,eo,fo,go,ho,io,jo,ko,lo:std_logic_vector(3 downto 0);
	begin
		if (clk'event) and (clk='1') and (ce='1') then
			if (reset='1') then bo:="0000";--resets syncronously the register
								co:="0000";
								do:="0000";
								eo:="0000";
								fo:="0000";
								go:="0000";
								ho:="0000";
								io:="0000";
								jo:="0000";
								ko:="0000";
								lo:="0000";
			else  --shifts to the right the digits 
			lo:=ko;	
			ko:=jo;
			jo:=io;
			io:=ho;
			ho:=go;	
			go:=fo;
			fo:=eo;
			eo:=do;
			do:=co;
			co:=bo;
			bo:=a;
			end if;
		end if;
		b<=bo;
		c<=co;
		d<=do;
		e<=eo;
		f<=fo;
		g<=go;
		h<=ho;
		i<=io;
		j<=jo;
		k<=ko;
		l<=lo;
	end process;
end arhregistru_rez;
	