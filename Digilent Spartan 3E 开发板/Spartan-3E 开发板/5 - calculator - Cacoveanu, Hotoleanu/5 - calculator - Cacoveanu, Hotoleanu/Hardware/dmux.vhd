----------------------------------------------------------------------------------
-- Create Date:    13:04:55 10/03/2006 
-- Module Name:    dmux - arhdmux
-- Project Name:   calculatorgata
-- Author:         Hotoleanu Dan 
-- Description:    This module is a 1:3 demultiplexer.
--                 It receives package of two buses and two signals and 
--                 sends them in 3 directions: to the divider, to the multiplyer
--                 and to the module that performs the adding and substracting 
--                 operation 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
---------------------------------------------------------------------------------
--enable - enable
--sgna - sign of the number a
--sgnb - sign of the number b
--a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0 - digits of the number a
--b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0 - digits of the number b
--f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03 - returns a if the selection is"11"
--f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02 - returns a if the selection is"10"
--f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01 - returns a if the selection is
--                                               "01" or "00"
--g103,g93,g83,g73,g63,g53,g43,g33,g23,g13,g03 - returns b if the selection is"11"
--g102,g92,g82,g72,g62,g52,g42,g32,g22,g12,g02 - returns b if the selection is"10"
--g101,g91,g81,g71,g61,g51,g41,g31,g21,g11,g01 - returns b if the selection is
--                                               "00" or "01"
--sign1a - returns the sign of a if the selection is "00" or "01"
--sign1b - returns the sign of b if the selection is "00" or "01"
--sign2a - returns the sign of a if the selection is "10"
--sign2b - returns the sign of b if the selection is "10"
--sign3a - returns the sign of a if the selection is "11"
--sign3b - returns the sign of b if the selection is "11"
----------------------------------------------------------------------------------
entity dmux is
   port (enable,sgna,sgnb:in std_logic;
   selection:in std_logic_vector(1 downto 0);
   a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0:in std_logic_vector(3 downto 0);
   b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0:in std_logic_vector(3 downto 0);
   f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03:out std_logic_vector(3 downto 0);
   f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02:out std_logic_vector(3 downto 0);
   f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01:out std_logic_vector(3 downto 0);
   g103,g93,g83,g73,g63,g53,g43,g33,g23,g13,g03:out std_logic_vector(3 downto 0);
   g102,g92,g82,g72,g62,g52,g42,g32,g22,g12,g02:out std_logic_vector(3 downto 0);
   g101,g91,g81,g71,g61,g51,g41,g31,g21,g11,g01:out std_logic_vector(3 downto 0);
	sign1a,sign1b,sign2a,sign2b,sign3a,sign3b:out std_logic);
end dmux;

architecture arhdmux of dmux is
begin
   process(enable,selection,
   a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0)
   begin
      if (enable='1') then 
         if (selection="00") or (selection="01") then 
            f101<=a10;
            f91<=a9;
            f81<=a8;
            f71<=a7;
            f61<=a6;
            f51<=a5;
            f41<=a4;
            f31<=a3;
            f21<=a2;
            f11<=a1;
            f01<=a0;
            g101<=b10;
            g91<=b9;
            g81<=b8;
            g71<=b7;
            g61<=b6;
            g51<=b5;
            g41<=b4;
            g31<=b3;
            g21<=b2;
            g11<=b1;
            g01<=b0;
				sign1a<=sgna;
				sign1b<=sgnb;
         elsif (selection="10") then
            f102<=a10;
            f92<=a9;
            f82<=a8;
            f72<=a7;
            f62<=a6;
            f52<=a5;
            f42<=a4;
            f32<=a3;
            f22<=a2;
            f12<=a1;
            f02<=a0;
            g102<=b10;
            g92<=b9;
            g82<=b8;
            g72<=b7;
            g62<=b6;
            g52<=b5;
            g42<=b4;
            g32<=b3;
            g22<=b2;
            g12<=b1;
            g02<=b0;
				sign2a<=sgna;
				sign2b<=sgnb;
         elsif (selection="11") then 
            f103<=a10;
            f93<=a9;
            f83<=a8;
            f73<=a7;
            f63<=a6;
            f53<=a5;
            f43<=a4;
            f33<=a3;
            f23<=a2;
            f13<=a1;
            f03<=a0;
            g103<=b10;
            g93<=b9;
            g83<=b8;
            g73<=b7;
            g63<=b6;
            g53<=b5;
            g43<=b4;
            g33<=b3;
            g23<=b2;
            g13<=b1;
            g03<=b0;
				sign3a<=sgna;
				sign3b<=sgnb;
         end if;
      end if;
   end process;
end arhdmux;
            
   
   