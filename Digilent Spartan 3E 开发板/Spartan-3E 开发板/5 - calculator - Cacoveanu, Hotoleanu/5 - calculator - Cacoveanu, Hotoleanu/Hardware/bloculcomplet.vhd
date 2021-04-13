----------------------------------------------------------------------------------
-- Create Date:    13:04:55 10/03/2006 
-- Module Name:    bloculcomplet - arhbloculcomplet 
-- Project Name:   calculatorgata
-- Author:         Hotoleanu Dan 
-- Description:    This module contains the main modules:clockdivider, dataentry,
--                 dmux, impartitor(divider), signofdivision, multiplyer, or1op, 
--                 muxx(multiplexer), specialdmux, display and is the interface 
--                 of the calculator 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--clk - clock
--kd - keyboard data
--kc - keyboard clock
--reset - reset
--sw0 - switch 0
--sw1 - switch 1
--d - selection for the anodes
--e - selection for the 7 segments
--opoint - displays the point
---------------------------------------------------------------------------------
entity bloculcomplet is
   port (clk, kd, kc, reset,sw0,sw1: in std_logic;
   d:out std_logic_vector(3 downto 0);
	e:out std_logic_vector(6 downto 0);
	opoint:out std_logic);
end bloculcomplet;

architecture arhbloculcomplet of bloculcomplet is
component dataentry is
   port (
      clk, kd, kc, reset: in std_logic;
      nra10, nra9, nra8, nra7, nra6, nra5, nra4, nra3, nra2, nra1, nra0:
         out std_logic_vector(3 downto 0);
      nrb10, nrb9, nrb8, nrb7, nrb6, nrb5, nrb4, nrb3, nrb2, nrb1, nrb0:
         out std_logic_vector(3 downto 0);
      sgna, sgnb: out std_logic;
      optype: out std_logic_vector(1 downto 0);
      ready_flag: out std_logic
   );
end component;

component impartitor is
	port (clk,ce,reset:in std_logic;
	d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0,
	i10,i9,i8,i7,i6,i5,i4,i3,i2,i1,i0:in std_logic_vector(3 downto 0);
	c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0:out std_logic_vector(3 downto 0));
end component;

component multiplyer is
   port (  
      a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
         in std_logic_vector(3 downto 0);
      b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0:
         in std_logic_vector(3 downto 0);
      sgna, sgnb, clk, res: in std_logic;
      c10, c9, c8, c7, c6, c5, c4, c3, c2, c1, c0:
         out std_logic_vector(3 downto 0);
      sgnc: out std_logic;
      endflag: out std_logic
   );
end component;

component or1op is
   port (
      carryin: in std_logic;
      a10, a9, a8, a7, a6, a5, a4, a3, a2, a1,
         a0: in std_logic_vector(3 downto 0);
      b10, b9, b8, b7, b6, b5, b4, b3, b2, b1,
         b0: in std_logic_vector(3 downto 0);
      sgna, sgnb, optype: in std_logic;
      c10, c9, c8, c7, c6, c5, c4, c3, c2, c1,
         c0: out std_logic_vector(3 downto 0);
      carryout: out std_logic;
      sgnc: out std_logic
   );
end component;

component display is
   port (clk,ce,reset,point:in std_logic;
	c3,c2,c1,c0:in std_logic_vector(3 downto 0);
	d:out std_logic_vector(3 downto 0);
	e:out std_logic_vector(6 downto 0);
	opoint:out std_logic);
end component;

component dmux is
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
end component;

component muxx is
   port (enable,signmult,signor1op,signimp:in std_logic;
   selection:in std_logic_vector(1 downto 0);
   f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03:in std_logic_vector(3 downto 0);
   f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02:in std_logic_vector(3 downto 0);
   f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01:in std_logic_vector(3 downto 0);
   c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0:out std_logic_vector(3 downto 0);
	sign:out std_logic);
end component;

component signofdivision is
   port (clk,sgna,sgnb:in std_logic;
   signc:out std_logic);
end component;

component specialdmux is
   port (sign,sw0,sw1:in std_logic;
   a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0:in std_logic_vector(3 downto 0);
   c3,c2,c1,c0:out std_logic_vector(3 downto 0);
   point:out std_logic);
end component;

component clockdivider is
    Port ( clk : in  STD_LOGIC;
           res : in  STD_LOGIC;
           outclk : out  STD_LOGIC);
end component;

signal a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,
       b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0:std_logic_vector(3 downto 0);
signal f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03:std_logic_vector(3 downto 0);
signal f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02:std_logic_vector(3 downto 0);
signal f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01:std_logic_vector(3 downto 0);
signal g103,g93,g83,g73,g63,g53,g43,g33,g23,g13,g03:std_logic_vector(3 downto 0);
signal g102,g92,g82,g72,g62,g52,g42,g32,g22,g12,g02:std_logic_vector(3 downto 0);
signal g101,g91,g81,g71,g61,g51,g41,g31,g21,g11,g01:std_logic_vector(3 downto 0);
signal signaindmux,signbindmux,enable,sign,point:std_logic;
signal selectiondmux:std_logic_vector(1 downto 0); 
signal signaofdmux3,signbofdmux3,signaofdmux2,signbofdmux2,
       signaofdmux1,signbofdmux1:std_logic;
signal flagimp,signimp,signmult,flagmult,signor1op:std_logic;
signal c10imp,c9imp,c8imp,c7imp,c6imp,c5imp,c4imp,
       c3imp,c2imp,c1imp,c0imp:std_logic_vector(3 downto 0);
signal c10mult,c9mult,c8mult,c7mult,c6mult,c5mult,c4mult,
       c3mult,c2mult,c1mult,c0mult:std_logic_vector(3 downto 0);
signal c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0:std_logic_vector(3 downto 0);
signal s3spd,s2spd,s1spd,s0spd:std_logic_vector(3 downto 0);
signal c10sc,c9sc,c8sc,c7sc,c6sc,c5sc,c4sc,
       c3sc,c2sc,c1sc,c0sc:std_logic_vector(3 downto 0);
signal multiplyerclk: std_logic;

begin
	 c0_sch: clockdivider port map (clk, reset, multiplyerclk);
    c1_sch:dataentry port map (clk,kd,kc,reset,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,
	                        b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0,signaindmux,
									signbindmux,selectiondmux,enable);
	 c2_sch:dmux port map (enable,signaindmux,signbindmux,selectiondmux,a10,a9,a8,
	                       a7,a6,a5,a4,a3,a2,a1,a0,
	                        b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0,
									f103,f93,f83,f73,f63,f53,f43,f33,f23,f13,f03,
									f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02,
									f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01,
									g103,g93,g83,g73,g63,g53,g43,g33,g23,g13,g03,
									g102,g92,g82,g72,g62,g52,g42,g32,g22,g12,g02,
									g101,g91,g81,g71,g61,g51,g41,g31,g21,g11,g01,
									signaofdmux1,signbofdmux1,signaofdmux2,signbofdmux2,
									signaofdmux3,signbofdmux3);
	  c3_sch:impartitor port map (multiplyerclk,'1',not enable,f103,f93,f83,f73,
	                          f63,f53,f43,f33,f23,f13,f03,
	                          g103,g93,g83,g73,g63,g53,g43,g33,g23,g13,g03,									  
									  c10imp,c9imp,c8imp,c7imp,c6imp,c5imp,c4imp,c3imp,
									  c2imp,c1imp,c0imp);
	  c4_sch:signofdivision port map (clk,signaofdmux3,signbofdmux3,signimp);
	  c5_sch:multiplyer port map (f102,f92,f82,f72,f62,f52,f42,f32,f22,f12,f02,
                             g102,g92,g82,g72,g62,g52,g42,g32,g22,g12,g02,
									  signaofdmux2,
									  signbofdmux2,multiplyerclk,not enable,
									  c10mult,c9mult,c8mult,c7mult,c6mult,c5mult,c4mult,
									  c3mult,c2mult,c1mult,c0mult,signmult,flagmult);
	  c6_sch:or1op port map ('0',f101,f91,f81,f71,f61,f51,f41,f31,f21,f11,f01,
	                     g101,g91,g81,g71,g61,g51,g41,g31,g21,g11,g01,
								signaofdmux1,signbofdmux1,selectiondmux(0),
								c10sc,c9sc,c8sc,c7sc,c6sc,c5sc,c4sc,c3sc,c2sc,c1sc,c0sc,
								open,signor1op);
	  c7_sch:muxx port map (enable,signmult,signor1op,signimp,selectiondmux,
	                    c10imp,c9imp,c8imp,c7imp,c6imp,c5imp,c4imp,c3imp,c2imp,
							  c1imp,c0imp,c10mult,c9mult,c8mult,c7mult,c6mult,
							  c5mult,c4mult,c3mult,c2mult,c1mult,c0mult,
							  c10sc,c9sc,c8sc,c7sc,c6sc,c5sc,c4sc,c3sc,c2sc,c1sc,c0sc,
		                 c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0,sign);
	  c8_sch:specialdmux port map (sign,sw0,sw1,c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0, 	  
	                           s3spd,s2spd,s1spd,s0spd,point); 
     c9_sch:display port map (clk,enable,reset,point,s3spd,s2spd,s1spd,s0spd,
	                       d,e,opoint);
							  
end arhbloculcomplet;