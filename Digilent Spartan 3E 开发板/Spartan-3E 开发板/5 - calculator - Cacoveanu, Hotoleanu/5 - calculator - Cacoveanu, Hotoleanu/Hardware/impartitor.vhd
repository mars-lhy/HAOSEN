----------------------------------------------------------------------------------
-- Create Date:    22:37:45 09/26/2006 
-- Module Name:    impartitor - arhimpartitor
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is the divider
--                 It receives 2 numbers: d(number) and i(number), and divides 
--                 them obtainig the result c(number)         
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--clk - clock
--ce - clock enable
--d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0 the number d that is divided by i
--i10,i9,i8,i7,i6,i5,i4,i3,i2,i1,i0 the number i
--c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0 the number c
----------------------------------------------------------------------------------
entity impartitor is
	port (clk,ce,reset:in std_logic;
	d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0,
	i10,i9,i8,i7,i6,i5,i4,i3,i2,i1,i0:in std_logic_vector(3 downto 0);
	c10,c9,c8,c7,c6,c5,c4,c3,c2,c1,c0:out std_logic_vector(3 downto 0));
end impartitor;

architecture arhimpartitor of impartitor is	
component registrusimplu 
	port (a,b,c,d,e,f,g,h,i,j,k:in std_logic_vector(3 downto 0);
	clk,ce,reset:in std_logic;
	ao,bo,co,do,eo,fo,go,ho,io,jo,ko:out std_logic_vector(3 downto 0));
end component;

component  multiplexor 
	port (a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0,
	b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0:in std_logic_vector(3 downto 0);
	sa:in std_logic_vector(3 downto 0);
	sb:in std_logic_vector(3 downto 0);
	s:in std_logic;
	c:out std_logic_vector(3 downto 0));
end component;

component RegistruShiftStanga4biti
	port (clk,ce,reset:in std_logic;
	a:in std_logic_vector(3 downto 0);
	b,c,d,e,f,g,h,i,j,k,l:out std_logic_vector(3 downto 0));
end component;

component counter1 
	port (clk,ce,reset:in std_logic;
	a:out std_logic_vector(3 downto 0);
	reached:out std_logic);
end component;

component counter_ct
	port (clk,ce,reset:in std_logic;
	a:out std_logic_vector(3 downto 0);
	reached:out std_logic);
end component;

component counter 
	port (clk,ce,cd,reset:in std_logic;
	a:out std_logic_vector(3 downto 0);
   reached:out std_logic);
end component;   

component counter11 
	port (clk,ce,reset:in std_logic;
	a:out std_logic_vector(3 downto 0);
	reached:out std_logic);
end component;

component comparator 
	port (a,b:in std_logic_vector(43 downto 0);
	c:out std_logic);
end component;

component unitatedecomanda 
	port (clk,ce,reset,ct1reached,ct2reached,
	ctreached,aegalb,countreached:in std_logic;
	endeimp,resdeimp,enimp,resimp,enct1,resct1,enct2,resct2,encounter,rescounter,
	enct,resct,eninmultitor,resinmultitor,countdirection,enregistru,resregistru,
	enpl,enrez,resrez,enregscad,resregscad,s:out std_logic);
end component;

component inmultitor 
	port (a:in std_logic_vector(3 downto 0);
	b,c,d,e,f,g,h,i,j,k,l:in std_logic_vector(3 downto 0);
	clk,ce,pl,reset:in std_logic;
	bo,co,do,eo,fo,go,ho,io,jo,ko,lo:out std_logic_vector(3 downto 0));
end component;

component or1op 
	port(
	carryin: in std_logic;
	a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0: in std_logic_vector(3 downto 0);
	b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0: in std_logic_vector(3 downto 0);
	sgna, sgnb, optype: in std_logic;
	c10, c9, c8, c7, c6, c5, c4, c3, c2, c1, c0: out std_logic_vector(3 downto 0);
	carryout: out std_logic;
	sgnc: out std_logic
	);
end component;

signal s11,s12,s13,s14,s15,s16,s17,s18,s19,s110,s111,s21,s22,s23,s24,s25,s26,s27,
       s28,s29,s210,s211,s3,s41,s42,s43,s44,s45,s46,s47,s48,s49,s410,s411,s5,s6,
		 s71,s72,s73,s74,s75,s76,s77,s78,s79,s710,s711,s81,s82,s83,s84,s85,s86,s87,
		 s88,s89,s810,s811,s9,saux1,sc1,sc2,sc3,sc4,
		 sc5,sc6,sc7,sc8,sc9,sc10,sc11:std_logic_vector(3 downto 0);
signal ct1reached,ct2reached,ctreached,aegalb,endeimp,resdeimp,enimp,
       resimp,enct1,resct1,enct2,resct2,encounter,rescounter,enct,resct,
		 eninmultitor,resinmultitor,countdirection,enregistru,resregistru,enpl,enrez,
		 resrez,saux2,enregscad,resregscad,s,countreached:std_logic;
signal totala,totalb:std_logic_vector(43 downto 0);

begin  
	totala<=s41(3)&s41(2)&s41(1)&s41(0)&s42(3)&s42(2)&s42(1)&s42(0)&s43(3)&s43(2)
	       &s43(1)&s43(0)&s44(3)&s44(2)&s44(1)&s44(0)&s45(3)&s45(2)&s45(1)&s45(0)
			 &s46(3)&s46(2)&s46(1)&s46(0)&s47(3)&s47(2)&s47(1)&s47(0)&s48(3)&s48(2)
			 &s48(1)&s48(0)&s49(3)&s49(2)&s49(1)&s49(0)&s410(3)&s410(2)&s410(1)
			 &s410(0)&s411(3)&s411(2)&s411(1)&s411(0);
	totalb<=s71(3)&s71(2)&s71(1)&s71(0)&s72(3)&s72(2)&s72(1)&s72(0)&s73(3)&s73(2)
	       &s73(1)&s73(0)&s74(3)&s74(2)&s74(1)&s74(0)&s75(3)&s75(2)&s75(1)&s75(0)
			 &s76(3)&s76(2)&s76(1)&s76(0)&s77(3)&s77(2)&s77(1)&s77(0)&s78(3)&s78(2)
			 &s78(1)&s78(0)&s79(3)&s79(2)&s79(1)&s79(0)&s710(3)&s710(2)&s710(1)
			 &s710(0)&s711(3)&s711(2)&s711(1)&s711(0);
	deimpartit_sch: registrusimplu port map (d10,d9,d8,d7,d6,d5,d4,d3,d2,d1,d0,
	                clk,endeimp,resdeimp,s11,s12,s13,s14,s15,s16,s17,s18,
						 s19,s110,s111);
	impartitor_sch: registrusimplu port map (i10,i9,i8,i7,i6,i5,i4,i3,i2,i1,i0,
	                clk,enimp,resimp,s81,s82,s83,s84,s85,s86,s87,s88,s89,
						 s810,s811);
	multiplexor_sch: multiplexor port map (s21,s22,s23,s24,s25,s26,s27,s28,s29,
	                 s210,s211,s11,s12,s13,s14,s15,s16,s17,s18,s19,s110,s111,
						  s6,s5,s,s3);
	registru: RegistruShiftStanga4biti port map (clk,enregistru,resregistru,s3,
	          s41,s42,s43,s44,s45,s46,s47,s48,s49,s410,s411);
	counter1_sch: counter11 port map (clk,enct1,resct1,s5,ct1reached);
	counter2_sch: counter1 port map (clk,enct2,resct2,s6,ct2reached);
	counter_ct_sch:counter_ct port map (clk,enct,resct,saux1,ctreached); 
	comparator_sch: comparator port map (totala,totalb,aegalb);
	numere_sch: counter port map (clk,encounter,countdirection,
	            rescounter,s9,countreached);
	unitatedecomanda_sch: unitatedecomanda port map (clk,ce,reset,ct1reached,
	                      ct2reached,ctreached,aegalb,countreached,
								 endeimp,resdeimp,enimp,resimp,enct1,resct1,enct2,
								 resct2,encounter,rescounter,enct,resct,eninmultitor,
								 resinmultitor,countdirection,enregistru,resregistru,
								 enpl,enrez,resrez,enregscad,resregscad,s);		 
	inmultitor_sch: inmultitor port map (s9,s811,s810,s89,s88,s87,s86,s85,s84,
	                s83,s82,s81,clk,eninmultitor,enpl,resinmultitor,s71,s72,
						 s73,s74,s75,s76,s77,s78,s79,s710,s711);
	scazator_sch: or1op port map ('0',s41,s42,s43,s44,s45,s46,s47,s48,s49,
	              s410,s411,s71,s72,s73,s74,s75,s76,s77,s78,s79,s710,s711,
					  '0','0','1',sc1,sc2,sc3,sc4,sc5,sc6,sc7,sc8,sc9,sc10,
					  sc11,open,saux2);
	rezultat_sch: RegistruShiftStanga4biti port map (clk,enrez,resrez,s9,c10,
	              c9,c8,c7,c6,c5,c4,c3,c2,c1,c0);
	registruscazator_sch: registrusimplu port map (sc1,sc2,sc3,sc4,sc5,sc6,sc7,
	                      sc8,sc9,sc10,sc11,clk,enregscad,resregscad,s21,s22,
								 s23,s24,s25,s26,s27,s28,s29,s210,s211);
end arhimpartitor;
	
	