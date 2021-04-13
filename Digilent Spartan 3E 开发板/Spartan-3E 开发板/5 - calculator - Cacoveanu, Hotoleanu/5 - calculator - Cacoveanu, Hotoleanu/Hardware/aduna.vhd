----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    aduna - arhaduna
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module adds two digits and the partial result obtained in
--                 a previous adding
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;   
use ieee.std_logic_arith.all;
----------------------------------------------------------------------------------
--a,b the input for the digits
--c - carry in bit
--d - the result
--cout - carry out bit
----------------------------------------------------------------------------------
entity aduna is
	port (a,b:in std_logic_vector(3 downto 0);
	c:in std_logic;
	d:out std_logic_vector(3 downto 0);
	cout:out std_logic);
end aduna;

architecture arhaduna of aduna is
begin  
	process(a,b,c)				 
	variable suma:integer range 0 to 20;
	begin
	--adds the inputs a and b and the partial result
		suma:=conv_integer(a)+conv_integer(b)+conv_integer(c);
		if (suma<10) then cout<='0';
			d<=a+b+c;
		elsif (suma=10) then cout<='1';
			d<="0000";
		elsif (suma=11) then cout<='1';
			d<="0001";
		elsif (suma=12) then cout<='1';
			d<="0010";
		elsif (suma=13) then cout<='1';
			d<="0011";
		elsif (suma=14) then cout<='1';
			d<="0100";
		elsif (suma=15) then cout<='1';
			d<="0101";
		elsif (suma=16) then cout<='1';
			d<="0110";
		elsif (suma=17) then cout<='1';
			d<="0111";
		elsif (suma=18) then cout<='1';
			d<="1000";
		else cout<='0';
			d<="0000";
		end if;
	end process;
end arhaduna;