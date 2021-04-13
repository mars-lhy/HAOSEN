----------------------------------------------------------------------------------
-- Create Date:    20:38:45 09/17/2006 
-- Module Name:    RegistruShiftStanga4biti - arhRegistruShiftStanga4biti
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This is a register that shifts to the left 4 bits.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--clk is the clock signal, ce the clock enable signal and reset the reset signal
--a is the inupt bus containig 4 bits, which will be shifted to the left in the 
--register
--b,c,d,e,f,g,h,i,j,k,l are the outputs of the register
---------------------------------------------------------------------------------
entity RegistruShiftStanga4biti is
	port (clk,ce,reset:in std_logic;
	a:in std_logic_vector(3 downto 0);
	b,c,d,e,f,g,h,i,j,k,l:out std_logic_vector(3 downto 0));
end RegistruShiftStanga4biti;

architecture arhRegistruShiftStanga4biti of RegistruShiftStanga4biti is
begin
	process(clk)				
	variable vb,vc,vd,ve,vf,vg,vh,vi,vj,vk,vl:std_logic_vector(3 downto 0);
	begin
		if (clk'event) and (clk='1') and (ce='1') then 
			if (reset='1') then vb:="0000";--syncronously resets the register
								vc:="0000";
								vd:="0000";
								ve:="0000";
								vf:="0000";
								vg:="0000";
								vh:="0000";
								vi:="0000";
								vj:="0000";
								vk:="0000";
								vl:="0000";
			else vb:=vc;--shifts to the left the digits stored in the register
				vc:=vd;
				vd:=ve;
				ve:=vf;
				vf:=vg;
				vg:=vh;
				vh:=vi;
				vi:=vj;
				vj:=vk;
				vk:=vl;
				vl:=a;
			end if;
		end if;
		b<=vb;
		c<=vc;
		d<=vd;
		e<=ve;
		f<=vf;
		g<=vg;
		h<=vh;
		i<=vi;
		j<=vj;
		k<=vk;
		l<=vl;
	end process;
end arhRegistruShiftStanga4biti;
								