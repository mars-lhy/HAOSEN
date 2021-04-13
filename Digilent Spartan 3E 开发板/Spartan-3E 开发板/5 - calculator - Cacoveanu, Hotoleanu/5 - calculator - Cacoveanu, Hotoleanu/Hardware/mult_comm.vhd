-----------------------------------------------------------------------------
--FILENAME        : mult_comm.vhd
--DESCRIPTION     : the command unit for the multiplyer component
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 23.09.2006 - created
--                  25.09.2006 - added output c5, used as a control clock
--                               in the multiplyer
--                             - added component cmp8
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mult_comm is
   port (	  
      res, clk: in std_logic;
      c1, c2: out std_logic_vector(3 downto 0);
      c3: out std_logic_vector(4 downto 0);
      c4, c5: out std_logic
   );
end entity;
	
architecture mult_comm_arh of mult_comm is
-----------------------------------------------------------------------------
-- We use two ctrot10 counters, two d flip flops and 5 adders.
-----------------------------------------------------------------------------
   component ctr0t10 is
      port (
         res, clk: in std_logic;
         o: out std_logic_vector(3 downto 0)
      );
   end component;
   component dffres is
      port(
         d, clk, r: in std_logic;
         q: out std_logic
      );
   end component;
   component adder is
      port (
         ci, a, b, e: in std_logic;
         r, co: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal clk1, clk2, n10: std_logic;							   
   signal tc1, tc2, cri1: std_logic_vector(3 downto 0);
   signal cri2: std_logic_vector(2 downto 0);
   signal countres, reachedend, endc: std_logic;
   signal sw, swclk: std_logic;
begin
-----------------------------------------------------------------------------
-- The first clock is used to load the data into the registers of the
-- multiplier. Output c5 is used as their clock. The first clock also
-- activates a switch and triggers the start of the multiplication process.
-----------------------------------------------------------------------------
   swclk <= (not(sw)) and clk;
   cmp8 : dffres port map (
         d=>'1', clk=>swclk, r=>res,
         q=>sw
      );                                                                     
   c5 <= swclk; 
-----------------------------------------------------------------------------
-- Counters start only after c5 has been active once and the sw switch has
-- been set.
-----------------------------------------------------------------------------
   clk1 <= clk and sw and not(reachedend);
-----------------------------------------------------------------------------
-- The counters reset signal is high when the command unit reset imput is
-- high or the end of the computation has been reached (each counter reached
-- "1010").
-----------------------------------------------------------------------------
   countres <= reachedend or res;
-----------------------------------------------------------------------------
-- First counter's clock is the cock imput of the command unit.
-----------------------------------------------------------------------------
   cmp0 : ctr0t10 port map (res => countres, clk => clk1, o => tc1);
-----------------------------------------------------------------------------
-- When the first counter reaches "1010", n10 is stored in a d flip flop
-- and at the next clock it will send a clock signal to the second counter.
-----------------------------------------------------------------------------
   n10 <= not(tc1(0)) and tc1(1) and not(tc1(2)) and tc1(3);
   cmp1 : dffres  port map (d=>n10, clk=>clk1, r => '0', q=>clk2);
   cmp2 : ctr0t10 port map (res=>countres, clk=>clk2, o=>tc2);
-----------------------------------------------------------------------------
-- The current numbers reached by the two counters stored in tc1 and tc2 are
-- added in output c3.
-----------------------------------------------------------------------------
   cmp3 : adder   port map (
      ci=>'0'    , a=>tc1(0), b=>tc2(0), e=>'1',
      r=>c3(0), co=>cri1(0)
   );
   cmp4 : adder   port map (
      ci=>cri1(0), a=>tc1(1), b=>tc2(1), e=>'1',
      r=>c3(1), co=>cri1(1)
   );
   cmp5 : adder   port map (
      ci=>cri1(1), a=>tc1(2), b=>tc2(2), e=>'1',
      r=>c3(2), co=>cri1(2)
   );
   cmp6 : adder   port map (
      ci=>cri1(2), a=>tc1(3), b=>tc2(3), e=>'1',
      r=>c3(3), co=>c3(4)
   );
-----------------------------------------------------------------------------
-- The end of the coputation is set when the flag has already been set in
-- a previos clock step or when both counters reach "1010".
-----------------------------------------------------------------------------
endc <= not(tc1(0)) and tc1(1) and not(tc1(2)) and tc1(3) and
        not(tc2(0)) and tc2(1) and not(tc2(2)) and tc2(3);
-----------------------------------------------------------------------------
-- The flag signalling the end of the multiplication operation is set (it
-- will be set '1' after 121 input clock signals) and stored in a d flip
-- flop.
-----------------------------------------------------------------------------
cmp7 : dffres  port map (d=>endc, clk => clk1, r=>res, q=>reachedend);
-----------------------------------------------------------------------------
-- The output signals are set.
-----------------------------------------------------------------------------
   c1 <= tc1;
   c2 <= tc2;
   c4 <= reachedend;
end architecture;