----------------------------------------------------------------------------------
-- Create Date:    13:04:55 10/03/2006 
-- Module Name:    muxx - arhmuxx 
-- Project Name:   calculatorgata
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is a 3:1 multiplexer.
--                 It receives the results of the operations and sends them to 
--                 the special demultiplexer
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--enable - enable
--signmult - sign of a*b
--signor1op - sign of a-b or a+b
--signimp - sign of a/b
--selection - selection
--f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03 - receives the result of a/b
--f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02 - receives the result of a*b
--f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01 - receives the result of a+b or a-b
--c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0 - returns the result of the selection
--sign - returns the sign of the selection result
----------------------------------------------------------------------------------
entity muxx is
   port (enable,signmult,signor1op,signimp:in std_logic;
   selection:in std_logic_vector(1 downto 0);
   f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03:in std_logic_vector(3 downto 0);
   f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02:in std_logic_vector(3 downto 0);
   f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01:in std_logic_vector(3 downto 0);
   c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0:out std_logic_vector(3 downto 0);
   sign:out std_logic);
end muxx;

architecture arhmuxx of muxx is
begin
   process(enable, selection,signimp,signmult,signor1op,
   f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03,
   f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02,
   f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01)
   begin
      if (enable='1') then
         if (selection="00") or (selection="01") then 
            c10<=f101;
            c9<=f91;
            c8<=f81;
            c7<=f71;
            c6<=f61;
            c5<=f51;
            c4<=f41;
            c3<=f31;
            c2<=f21;
            c1<=f11;
            c0<=f01;
				sign<=signor1op;
         elsif (selection="10") then 
            c10<=f102;
            c9<=f92;
            c8<=f82;
            c7<=f72;
            c6<=f62;
            c5<=f52;
            c4<=f42;
            c3<=f32;
            c2<=f22;
            c1<=f12;
            c0<=f02;
				sign<=signmult;
         elsif (selection="11") then 
            c10<=f103;
            c9<=f93;
            c8<=f83;
            c7<=f73;
            c6<=f63;
            c5<=f53;
            c4<=f43;
            c3<=f33;
            c2<=f23;
            c1<=f13;
            c0<=f03;
				sign<=signimp;
         end if;
      end if;
   end process;
end arhmuxx;
            
   
