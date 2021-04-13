-----------------------------------------------------------------------------
--FILENAME        : multiplyer.vhd
--DESCRIPTION     : a component that multiplyes two 11 digit numbers stored
--                  on 44 bits and a sign bit and returns the result in
--                  a 11digit number. Uses an end flag to signal the end
--                  of the multiplication operation. Has an asynchronous
--                  reset
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
--                             - comsiders the numbers have decimals
--                               represented by the last two digits
--                  25.09.2006 - added cmp12, cmp13 and cmp14
--                             - updated mult_comm
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity multiplyer is
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
end entity;
                                                                             
architecture multiplyer_arh of multiplyer is  
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
   component mux16t1_4b is
      port (
         a15, a14, a13, a12, a11, a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
            in std_logic_vector(3 downto 0);
         route: in std_logic_vector(3 downto 0);
         b: out std_logic_vector(3 downto 0)
      );
   end component;
   component digit_multiplyer is
      port (
         a, b: in std_logic_vector(3 downto 0);
         res, co: out std_logic_vector(3 downto 0)
      );
   end component;
   component dmux1t32_4b is
      port (
         e: in std_logic;
         a: in std_logic_vector(3 downto 0);
         sel: in std_logic_vector(4 downto 0);                
         b31, b30, b29, b28, b27, b26, b25, b24, b23, b22, b21, b20, b19, b18,
         b17, b16, b15, b14, b13, b12, b11, b10, b9 , b8 , b7 , b6 , b5 , b4 ,
         b3 , b2 , b1 , b0 : out std_logic_vector(3 downto 0)
      );
   end component;
   component or1op is
      port (
         carryin: in std_logic;
         a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
            in std_logic_vector(3 downto 0);
         b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0:
            in std_logic_vector(3 downto 0);
         sgna, sgnb, optype: in std_logic;
         c10, c9, c8, c7, c6, c5, c4, c3, c2, c1, c0:
            out std_logic_vector(3 downto 0);
         carryout: out std_logic;
         sgnc: out std_logic
      );
   end component;
   component reg44b is
      port (
         a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0:
            in std_logic_vector(3 downto 0);
         res, clk: in std_logic; 
         b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0:
            out std_logic_vector(3 downto 0)
      );
   end component;
   component mult_comm is
      port (	  
         res, clk: in std_logic;
         c1, c2: out std_logic_vector(3 downto 0);
         c3: out std_logic_vector(4 downto 0);
         c4, c5: out std_logic
      );
   end component;
   component dffres is
      port (
         d, clk, r: in std_logic;
         q: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
-- control signals
   signal ctrl1, ctrl2: std_logic_vector(3 downto 0);
   signal ctrl3: std_logic_vector(4 downto 0);
   signal ctrlclk: std_logic;
-- signals to store the input numbers
   signal rega10, rega9, rega8, rega7, rega6, rega5, rega4, rega3, rega2,
          rega1 , rega0,
          regb10, regb9, regb8, regb7, regb6, regb5, regb4, regb3, regb2,
          regb1 , regb0: std_logic_vector(3 downto 0);
-- signals used om the multiplication process
   signal router1, router2, mult_res, mult_co: std_logic_vector(3 downto 0);
-- signals used in the addition process
   signal rres0 , rres1 , rres2 , rres3 , rres4 , rres5 , rres6 , rres7 ,
          rres8 , rres9 , rres10, rres11, rres12, rres13, rres14, rres15,
          rres16, rres17, rres18, rres19, rres20, rres21,
          rco0  , rco1  , rco2  , rco3  , rco4  , rco5  , rco6  , rco7  ,
          rco8  , rco9  , rco10 , rco11 , rco12 , rco13 , rco14 , rco15 ,
          rco16 , rco17 , rco18 , rco19 , rco20 , rco21 ,
          res0  , res1  , res2  , res3  , res4  , res5  , res6  , res7  ,
          res8  , res9  , res10 ,
          res11 , res12 , res13 , res14 , res15 , res16 , res17 , res18 ,
          res19 , res20 , res21 ,
          pres0 , pres1 , pres2 , pres3 , pres4 , pres5 , pres6 , pres7 ,
          pres8 , pres9 , pres10,
          pres11, pres12, pres13, pres14, pres15, pres16, pres17, pres18,
          pres19, pres20, pres21,
          qres0 , qres1 , qres2 , qres3 , qres4 , qres5 , qres6 , qres7 ,
          qres8 , qres9 , qres10,
          qres11, qres12, qres13, qres14, qres15, qres16, qres17, qres18,
          qres19, qres20, qres21
          : std_logic_vector(3 downto 0);
   signal ressgn, pressgn1, pressgn2, qressgn1, qressgn2: std_logic;
   signal pres1co, pres2co, qres1co, qres2co: std_logic;
-- signal for storing the sign of c
   signal sc: std_logic;
-- signal for the register clock
	signal regclk, internflag: std_logic;
-- unused signals
   signal u0, u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12, u13, u14,
          u15, u16, u17, u18, u19: std_logic_vector(3 downto 0);
begin
-----------------------------------------------------------------------------
-- We store the imputs into two 44bit registers.
-----------------------------------------------------------------------------
   cmp12: reg44b port map (
      a10=>a10, a9=>a9, a8=>a8, a7=>a7, a6=>a6, a5=>a5, a4=>a4, a3=>a3,
      a2 =>a2 , a1=>a1, a0=>a0,
      res=>res, clk=>ctrlclk,
      b10=>rega10, b9=>rega9, b8=>rega8, b7=>rega7, b6=>rega6, b5=>rega5,
      b4 =>rega4 , b3=>rega3, b2=>rega2, b1=>rega1, b0=>rega0
      );
   cmp13: reg44b port map (
      a10=>b10, a9=>b9, a8=>b8, a7=>b7, a6=>b6, a5=>b5, a4=>b4, a3=>b3,
      a2 =>b2 , a1=>b1, a0=>b0,
      res=>res, clk=>ctrlclk,
      b10=>regb10, b9=>regb9, b8=>regb8, b7=>regb7, b6=>regb6, b5=>regb5,
      b4 =>regb4 , b3=>regb3, b2=>regb2, b1=>regb1, b0=>regb0
      );
-----------------------------------------------------------------------------
-- We select the digits that will be multiplyed into router1 and router2.
-----------------------------------------------------------------------------
   cmp0 : mux16t1_4b port map (
      a15=>"0000", a14=>"0000", a13=>"0000", a12=>"0000", a11=>"0000",
      a10=>rega10, a9 =>rega9 , a8 =>rega8 , a7 =>rega7 , a6 =>rega6 ,
      a5 =>rega5 , a4 =>rega4 , a3 =>rega3 , a2 =>rega2 , a1 =>rega1 ,
      a0 =>rega0 ,
      route => ctrl1, b => router1
   );
   cmp1 : mux16t1_4b port map (
      a15=>"0000", a14=>"0000", a13=>"0000", a12=>"0000", a11=>"0000",
      a10=>regb10, a9 =>regb9 , a8 =>regb8 , a7 =>regb7 , a6 =>regb6 ,
      a5 =>regb5 , a4 =>regb4 , a3 =>regb3 , a2 =>regb2 , a1 =>regb1 ,
      a0 =>regb0 ,
      route => ctrl2, b => router2
   );
-----------------------------------------------------------------------------
-- We multiply the two digits.
-----------------------------------------------------------------------------
   cmp2 : digit_multiplyer port map (
      a => router1, b => router2,
      res => mult_res, co => mult_co
   );
-----------------------------------------------------------------------------
-- We use the demultiplexers to add the digits at the right position in the
-- partial result.
-----------------------------------------------------------------------------   
   cmp3 : dmux1t32_4b port map (
      e => '1', a => mult_res, sel => ctrl3,
      b31=>u0    , b30=>u1    , b29=>u2    , b28=>u3    , b27=>u4    ,
      b26=>u5    , b25=>u6    , b24=>u7    , b23=>u8    , b22=>u9    ,
      b21=>rres21, b20=>rres20, b19=>rres19, b18=>rres18, b17=>rres17,
      b16=>rres16, b15=>rres15, b14=>rres14, b13=>rres13, b12=>rres12,
      b11=>rres11, b10=>rres10, b9=>rres9  , b8=>rres8  , b7=>rres7  ,
      b6=>rres6  , b5=>rres5  , b4=>rres4  , b3=>rres3  , b2=>rres2  ,
      b1=>rres1  , b0=>rres0
   );
   cmp4 : dmux1t32_4b port map (
      e => '1', a => mult_co, sel => ctrl3,
      b31=>u10  , b30=>u11  , b29=>u12  , b28=>u13  , b27=>u14  , b26=>u15  ,
      b25=>u16  , b24=>u17  , b23=>u18  , b22=>u19  , b21=>rco21, b20=>rco20,
      b19=>rco19, b18=>rco18, b17=>rco17, b16=>rco16, b15=>rco15, b14=>rco14,
      b13=>rco13, b12=>rco12, b11=>rco11,	b10=>rco10, b9=>rco9  , b8=>rco8  ,
      b7=>rco7  , b6=>rco6  , b5=>rco5  , b4=>rco4  , b3=>rco3  , b2=>rco2  ,
      b1=>rco1  , b0=>rco0
   );
-----------------------------------------------------------------------------
-- We add rres to the partial result.
-----------------------------------------------------------------------------
   cmp5 : or1op port map (
      carryin=>'0',
      a10=>rres10, a9=>rres9, a8=>rres8, a7=>rres7, a6=>rres6, a5=>rres5,
      a4=>rres4  , a3=>rres3, a2=>rres2, a1=>rres1, a0=>rres0,
      b10=>res10 , b9=>res9 , b8=>res8 , b7=>res7 , b6=>res6 , b5=>res5 ,
      b4=>res4   , b3=>res3 , b2=>res2 , b1=>res1 , b0=>res0 ,
      sgna=>'0' , sgnb=>'0', optype=>'0',
      c10=>pres10, c9=>pres9, c8=>pres8, c7=>pres7, c6=>pres6, c5=>pres5,
      c4=>pres4  , c3=>pres3, c2=>pres2, c1=>pres1, c0=>pres0,
      carryout=>pres1co, sgnc=>pressgn1
   );				 
   cmp6 : or1op port map (
	   carryin=>pres1co,
	   a10=>rres21, a9=>rres20, a8=>rres19, a7=>rres18, a6=>rres17,
      a5 =>rres16, a4=>rres15, a3=>rres14, a2=>rres13, a1=>rres12,
      a0 =>rres11,
	   b10=>res21 , b9=>res20 , b8=>res19 , b7=>res18 , b6=>res17 ,
      b5 =>res16 , b4=>res15 , b3=>res14 , b2=>res13 , b1=>res12 ,
      b0 =>res11,
	   sgna=>'0', sgnb=>'0', optype=>'0',
	   c10=>pres21, c9=>pres20, c8=>pres19, c7=>pres18, c6=>pres17,
      c5 =>pres16, c4=>pres15, c3=>pres14, c2=>pres13, c1=>pres12,
      c0 =>pres11,
	   carryout=>pres2co, sgnc=>pressgn2
   );
-----------------------------------------------------------------------------
-- We add rco to the partial result.
-----------------------------------------------------------------------------
   cmp7 : or1op port map ( 
      carryin=>'0',
	   a10=>rco9  , a9=>rco8 , a8=>rco7 , a7=>rco6 , a6=>rco5  , a5=>rco4 ,
      a4 =>rco3  , a3=>rco2 , a2=>rco1 , a1=>rco0 , a0=>"0000",          
	   b10=>pres10, b9=>pres9, b8=>pres8, b7=>pres7, b6=>pres6 , b5=>pres5,
      b4 =>pres4 , b3=>pres3, b2=>pres2, b1=>pres1, b0=>pres0 ,
	   sgna=>'0', sgnb=>'0', optype=>'0',
	   c10=>qres10, c9=>qres9, c8=>qres8, c7=>qres7, c6=>qres6 , c5=>qres5,
      c4 =>qres4 , c3=>qres3, c2=>qres2, c1=>qres1, c0=>qres0,
	   carryout=>qres1co, sgnc=>qressgn1
   );
   cmp8 : or1op port map ( 
      carryin=>qres1co,
	   a10=>rco20 , a9=>rco19 , a8=>rco18 , a7=>rco17 , a6=>rco16 , a5=>rco15 , 
      a4 =>rco14 , a3=>rco13 , a2=>rco12 , a1=>rco11 , a0=>rco10 ,
	   b10=>pres21, b9=>pres20, b8=>pres19, b7=>pres18, b6=>pres17, b5=>pres16,
      b4 =>pres15, b3=>pres14, b2=>pres13, b1=>pres12, b0=>pres11,
	   sgna=>'0', sgnb=>'0', optype=>'0',
	   c10=>qres21, c9=>qres20, c8=>qres19, c7=>qres18, c6=>qres17, c5=>qres16,
      c4 =>qres15, c3=>qres14, c2=>qres13, c1=>qres12, c0=>qres11,
	   carryout => qres2co, sgnc=> qressgn2
   );
-----------------------------------------------------------------------------
-- We store the partial result in 2 44bit registers.
-----------------------------------------------------------------------------
	regclk <= clk and not(internflag);
   cmp9 :  reg44b port map (
      a10=>qres10, a9=>qres9, a8=>qres8, a7=>qres7, a6=>qres6, a5=>qres5,
      a4 =>qres4 , a3=>qres3, a2=>qres2, a1=>qres1, a0=>qres0,
      res=>res, clk=>regclk,
      b10=>res10 , b9=>res9 , b8=>res8 , b7=>res7 , b6=>res6 , b5=>res5 ,
      b4 =>res4  , b3=>res3 , b2=>res2 , b1=>res1 , b0=>res0
   );
   cmp10:  reg44b port map (
      a10=>qres21, a9=>qres20, a8=>qres19, a7=>qres18, a6=>qres17,
      a5 =>qres16, a4=>qres15, a3=>qres14, a2=>qres13, a1=>qres12,
      a0 =>qres11,
      res=>res, clk=>regclk,
      b10=>res21 , b9=>res20 , b8=>res19 , b7=>res18 , b6=>res17 ,
      b5 =>res16 , b4=>res15 , b3=>res14 , b2=>res13 , b1=>res12 ,
      b0=>res11
   );
-----------------------------------------------------------------------------
-- We add the command unit.
-----------------------------------------------------------------------------	
   cmp11: mult_comm port map (	  
      res=>res, clk=>clk,
      c1=>ctrl1, c2=>ctrl2,
      c3=>ctrl3, c4=>internflag, c5=>ctrlclk
	);
-----------------------------------------------------------------------------
-- We link the numbers to the result such that we get the decimal part
-- in the right place.
-----------------------------------------------------------------------------
   c0 <= res2;
   c1 <= res3;
   c2 <= res4;
   c3 <= res5;
   c4 <= res6;
   c5 <= res7;
   c6 <= res8;
   c7 <= res9;
   c8 <= res10;
   c9 <= res11;
   c10<= res12;
	
	endflag <= internflag;
-----------------------------------------------------------------------------
-- The sign of the result is a function of the signs of the two other
-- numbers.
-----------------------------------------------------------------------------
   sc <= sgna xor sgnb;
   cmp14: dffres port map (
         d=>sc, clk=>ctrlclk, r=>res,
         q=>sgnc
      );
end architecture;