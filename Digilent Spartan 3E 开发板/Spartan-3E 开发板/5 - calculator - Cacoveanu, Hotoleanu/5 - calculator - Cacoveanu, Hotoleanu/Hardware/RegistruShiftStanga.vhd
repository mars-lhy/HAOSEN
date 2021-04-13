----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    RegistruShiftStanga - arhRegistruShiftStanga
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    The module is a register which shifts to the left a digit
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
---------------------------------------------------------------------------------
--a,b,c,d,e,f,g,h,i,j,k are digits of the number which will be loaded.
--clk - clock
--ce - clock enable
--pl - parallel load
--reset - reset 
--ao,bo,co,do,eo,fo,go,ho,io,jo,ko are digits of the number which was loaded and 
--shifted
--------------------------------------------------------------------------------

entity RegistruShiftStanga is
	port ( a,b,c,d,e,f,g,h,i,j,k:in std_logic_vector(3 downto 0);
	clk,ce,pl,reset:in std_logic;
	ao,bo,co,do,eo,fo,go,ho,io,jo,ko:out std_logic_vector(3 downto 0));
end RegistruShiftStanga;

architecture Behavioral of RegistruShiftStanga is

begin
	process(clk)
	variable vao,vbo,vco,vdo,veo,vfo,vgo,
	vho,vio,vjo,vko:std_logic_vector(3 downto 0);
	begin
		if (clk'event) and (clk='1') and (ce='1') then
			if (reset='1') then vao:="0000";--resets the register
								vbo:="0000";
								vco:="0000";
								vdo:="0000";
								veo:="0000";
								vfo:="0000";
								vgo:="0000";
								vho:="0000";
								vio:="0000";
								vjo:="0000";
								vko:="0000";
			elsif (pl='1') then vao:=a;--loads the register
									vbo:=b;
									vco:=c;
									vdo:=d;
									veo:=e;
									vfo:=f;
									vgo:=g;
									vho:=h;
									vio:=i;
									vjo:=j;
									vko:=k;
							else vao:=vbo;--shifts the digits to the left
									vbo:=vco;
									vco:=vdo;
									vdo:=veo;
									veo:=vfo;
									vfo:=vgo;
									vgo:=vho;
									vho:=vio;
									vio:=vjo;
									vjo:=vko;
									vko:="0000";
			end if;
		end if;
		ao<=vao;
		bo<=vbo;
		co<=vco;
		do<=vdo;
		eo<=veo;
		fo<=vfo;
		go<=vgo;
		ho<=vho;
		io<=vio;
		jo<=vjo;
		ko<=vko;
	end process;
end Behavioral;