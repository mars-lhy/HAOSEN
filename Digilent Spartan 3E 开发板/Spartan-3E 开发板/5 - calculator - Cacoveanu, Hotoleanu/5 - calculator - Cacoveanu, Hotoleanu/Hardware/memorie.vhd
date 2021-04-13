----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    memorie - arhmemorie
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a matrix that stores the results of the 
--                 multiplication of all the combinations of the digits.
--                 It receives 2 digits one is the row and one is the column and 
--                 the result of the multiplication is stored at the location
--                 where the row and the column intersect
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--a,b - the digits
--cz - the decimal digit of the number
--cu - the unit digit of the number
----------------------------------------------------------------------------------
entity memorie is
	port (a,b:in std_logic_vector(3 downto 0);
	cz,cu:out std_logic_vector(3 downto 0));
end memorie;

architecture arhmemorie of memorie is 
begin
	process(a,b)
	begin
	if (a="0000") or (b="0000") then cu<="0000";
									cz<="0000";
	elsif (a="0001") and (b="0001") then cu<="0001";
		cz<="0000";
	elsif (a="0001") then cu<=b;
		cz<="0000";
	elsif (b="0001") then cu<=a;
		cz<="0000";
	elsif (a="0010") and (b="0010") then cu<="0100";
		cz<="0000";
	elsif (a="0010") and (b="0011") then cu<="0110";
		cz<="0000";
	elsif (a="0010") and (b="0100") then cu<="1000";
		cz<="0000";	
	elsif (a="0010") and (b="0101") then cu<="0000";
		cz<="0001";
	elsif (a="0010") and (b="0110") then cu<="0010";
		cz<="0001";
	elsif (a="0010") and (b="0111") then cu<="0100";
		cz<="0001";
	elsif (a="0010") and (b="1000") then cu<="0110";
		cz<="0001";
	elsif (a="0010") and (b="1001") then cu<="1000";
		cz<="0001";
	elsif (a="0011") and (b="0010") then cu<="0110";
		cz<="0000";	
	elsif (a="0100") and (b="0010") then cu<="1000";
		cz<="0000";	
	elsif (a="0101") and (b="0010") then cu<="0000";
		cz<="0001";
	elsif (a="0110") and (b="0010") then cu<="0010";
		cz<="0001";
	elsif (a="0111") and (b="0010") then cu<="0100";
		cz<="0001";
	elsif (a="1000") and (b="0010") then cu<="0110";
		cz<="0001";
	elsif (a="1001") and (b="0010") then cu<="1000";
		cz<="0001";	
	elsif (a="0011") and (b="0011") then cu<="1001";
		cz<="0000";
	elsif (a="0011") and (b="0100") then cu<="0010";
		cz<="0001";						
	elsif (a="0011") and (b="0101") then cu<="0101";
		cz<="0001";	
	elsif (a="0011") and (b="0110") then cu<="1000";
		cz<="0001";
	elsif (a="0011") and (b="0111") then cu<="0001";
		cz<="0010";	
	elsif (a="0011") and (b="1000") then cu<="0100";
		cz<="0010";	 
	elsif (a="0011") and (b="1001") then cu<="0111";
		cz<="0010";
	elsif (b="0011") and (a="0100") then cu<="0010";
		cz<="0001";						
	elsif (b="0011") and (a="0101") then cu<="0101";
		cz<="0001";	
	elsif (b="0011") and (a="0110") then cu<="1000";
		cz<="0001";
	elsif (b="0011") and (a="0111") then cu<="0001";
		cz<="0010";	
	elsif (b="0011") and (a="1000") then cu<="0100";
		cz<="0010";	 
	elsif (b="0011") and (a="1001") then cu<="0111";
		cz<="0010";
	elsif (a="0100") and (b="0100") then cu<="0110";
		cz<="0001";
	elsif (a="0100") and (b="0101") then cu<="0000";
		cz<="0010";
	elsif (a="0100") and (b="0110") then cu<="0100";
		cz<="0010";
	elsif (a="0100") and (b="0111") then cu<="1000";
		cz<="0010";
	elsif (a="0100") and (b="1000") then cu<="0010";
		cz<="0011";	
	elsif (a="0100") and (b="1001") then cu<="0110";
		cz<="0011";	   
	elsif (b="0100") and (a="0101") then cu<="0000";
		cz<="0010";
	elsif (b="0100") and (a="0110") then cu<="0100";
		cz<="0010";
	elsif (b="0100") and (a="0111") then cu<="1000";
		cz<="0010";
	elsif (b="0100") and (a="1000") then cu<="0010";
		cz<="0011";	
	elsif (b="0100") and (a="1001") then cu<="0110";
		cz<="0011";
	elsif (a="0101") and (b="0101") then cu<="0101";
		cz<="0010";	
	elsif (a="0101") and (b="0110") then cu<="0000";
		cz<="0011";	   
	elsif (a="0101") and (b="0111") then cu<="0101";
		cz<="0011";	   							  
	elsif (a="0101") and (b="1000") then cu<="0000";
		cz<="0100";
	elsif (a="0101") and (b="1001") then cu<="0101";
		cz<="0100";	  
	elsif (b="0101") and (a="0110") then cu<="0000";
		cz<="0011";	   
	elsif (b="0101") and (a="0111") then cu<="0101";
		cz<="0011";	   							  
	elsif (b="0101") and (a="1000") then cu<="0000";
		cz<="0100";
	elsif (b="0101") and (a="1001") then cu<="0101";
		cz<="0100";
	elsif (a="0110") and (b="0110") then cu<="0110";
		cz<="0011";
	elsif (a="0110") and (b="0111") then cu<="0010";
		cz<="0100";
	elsif (a="0110") and (b="1000") then cu<="1000";
		cz<="0100";	 
	elsif (a="0110") and (b="1001") then cu<="0100";
		cz<="0101";	   
	elsif (b="0110") and (a="0111") then cu<="0010";
		cz<="0100";
	elsif (b="0110") and (a="1000") then cu<="1000";
		cz<="0100";	 
	elsif (b="0110") and (a="1001") then cu<="0100";
		cz<="0101";	 
	elsif (a="0111") and (b="0111") then cu<="1001";
		cz<="0100";
	elsif (a="0111") and (b="1000") then cu<="0110";
		cz<="0101";
	elsif (a="0111") and (b="1001") then cu<="0011";
		cz<="0110";			
	elsif (b="0111") and (a="1000") then cu<="0110";
		cz<="0101";
	elsif (b="0111") and (a="1001") then cu<="0011";
		cz<="0110";
	elsif (a="1000") and (b="1000") then cu<="0100";
		cz<="0110";
	elsif (a="1000") and (b="1001") then cu<="0010";
		cz<="0111";	
	elsif (b="1000") and (a="1001") then cu<="0010";
		cz<="0111";
	elsif (a="1001") and (b="1001") then cu<="0001";
		cz<="1000";
	end if;	 						
	end process;
end arhmemorie;
	
		
