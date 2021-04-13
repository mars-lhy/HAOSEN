----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    inmultitor - arhinmultitor
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is the partial multiplier foe the divider
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--a is the input from the counter numere and is a digit
--b,c,d,e,f,g,h,i,j,k,l are the digits of the number stored in impartitor
--clk - clock 
--ce - clock enable
--pl - parallel load
--reset - reset
--bo,co,do,eo,fo,go,ho,io,jo,ko,lo are the digits of the number which results 
--from the multiplication
----------------------------------------------------------------------------------
entity inmultitor is
	port (a:in std_logic_vector(3 downto 0);
	b,c,d,e,f,g,h,i,j,k,l:in std_logic_vector(3 downto 0);
	clk,ce,pl,reset:in std_logic;
	bo,co,do,eo,fo,go,ho,io,jo,ko,lo:out std_logic_vector(3 downto 0));
end inmultitor;

architecture arhinmultitor of inmultitor is	
component RegistruShiftStanga
	port ( a,b,c,d,e,f,g,h,i,j,k:in std_logic_vector(3 downto 0);
	clk,ce,pl,reset:in std_logic;
	ao,bo,co,do,eo,fo,go,ho,io,jo,ko:out std_logic_vector(3 downto 0));
end component;
component registru 
	port (a:in std_logic_vector(3 downto 0);
	clk,ce,reset:in std_logic;
	b:out std_logic_vector(3 downto 0));
end component;	 
component aduna 
	port (a,b:in std_logic_vector(3 downto 0);
	c:in std_logic;
	d:out std_logic_vector(3 downto 0);
	cout:out std_logic);
end component;	 
component bistabil 
	port (a:in std_logic;
	clk,ce,reset:in std_logic;
	c:out std_logic);
end component;
component memorie 
	port (a,b:in std_logic_vector(3 downto 0);
	cz,cu:out std_logic_vector(3 downto 0));
end component;
component registru_rez 
	port (a:in std_logic_vector(3 downto 0);
	clk,ce,reset:in std_logic;
	b,c,d,e,f,g,h,i,j,k,l:out std_logic_vector(3 downto 0));
end component; 
signal sbo,sco,sdo,seo,sfo,sgo,sho,sio,sjo,sko,slo,scz,
       scu,sa,sb,sd:std_logic_vector(3 downto 0);
signal scout,sc:std_logic;
begin 
	c1: RegistruShiftStanga port map(b,c,d,e,f,g,h,i,j,k,l,
	    clk,ce,pl,reset,sbo,sco,sdo,seo,sfo,sgo,sho,sio,sjo,sko,slo);
	c2: memorie port map(a,sbo,scz,scu);
	c3: registru port map(scz,clk,ce,reset,sa);
	c4: aduna port map(sa,scu,sc,sd,scout);
	c5: bistabil port map(scout,clk,ce,reset,sc);
	c6: registru_rez port map(sd,clk,ce,reset,bo,co,do,eo,fo,go,ho,
	    io,jo,ko,lo);
end arhinmultitor;
	