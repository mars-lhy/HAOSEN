
--------------------------------------------------------------------------------
-- Company: 
--  Author : Fazakas Szabolcs
------------------------------------------------------------------------
--
-- Create Date:    17:43:14 09/27/06
-- Design Name:    
-- Module Name:    nexys - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
------------------------------------------------------------------------
-- This component analyses the fan speed by reading the fotosensor and 
-- controls the laser beam. It is also syncronizes the mirrors to each 
-- other. 
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk             Input      Main clock input 
-- din              Input      Digital input(JD ports)
-- swt(7:0)         Input      Switch inputs
-- led(7:0)         Output     Led
-- an(3:0)          Output     Anod
-- ssg(4:0)         Output     Seven segment
-- oc1              Output     Open collector output(JA ports)
--
------------------------------------------------------------------------
entity nexys is
   Port (   mclk       : in std_logic;
            din    : in std_logic_vector(3 downto 0);
                        
        	   swt    : in std_logic_vector(7 downto 0);

		      led	  : out std_logic_vector(7 downto 0);
        	   an     : out std_logic_vector(3 downto 0);
        	   ssg    : out std_logic_vector(6 downto 0);
	   	   
            oc1         : out std_logic
            );
end nexys;

architecture Behavioral of nexys is
  	------------------------------------------------------------------------
	-- Component Declarations
	------------------------------------------------------------------------
      -- contains 4 Block RAMs
       component video is
         Port(    mclk    : in std_logic;
                  frame   : in std_logic_vector(16 downto 0);

                  laser   :out std_logic
        );
      end component;
      -- for seven segment display
      component ssd is
         Port(    clk    : in std_logic_vector(1 downto 0);
                  number   : in std_logic_vector(15 downto 0);

                  an           :out std_logic_vector(3 downto 0);
                  sevensg    : out std_logic_vector(6 downto 0)
        );
      end component;
	------------------------------------------------------------------------
	-- Signal Declarations
	------------------------------------------------------------------------
    
 signal nr  		    : std_logic_vector(15 downto 0):="0000000000000000";
 signal cntClk : std_logic_vector(28 downto 0);
 signal x1,y1:std_logic:='0';
 signal f1,f2:std_logic_vector(7 downto 0);
 signal n1,n2:std_logic:='1';

 signal laser : std_logic;
 signal frame : std_logic_vector(2 downto 0);
 signal caracter : std_logic_vector(10 downto 0);
 signal addres : std_logic_vector(16 downto 0);
 signal time1 : std_logic_vector(25 downto 0):="00000000000000000000000000";
 signal time2,time0  : std_logic_vector(22 downto 0):="00000000000000000000000";
 signal vidon   : std_logic;
 signal line : std_logic_vector(2 downto 0):="000";
 signal col : std_logic_vector(5 downto 0):="000000";

 signal number  : std_logic_vector(15 downto 0);

 signal cc : std_logic_vector(2 downto 0);
 signal car : std_logic_vector(10 downto 0);
 --signal temp  : std_logic_vector(3 downto 0);
	------------------------------------------------------------------------
	-- Module Implementation
	------------------------------------------------------------------------
begin

memori: video Port map( mclk=>mclk,
               frame=>addres,
             laser=>laser);

sevenseg:ssd Port map(clk=> cntClk(18 downto 17),
                        number=>number,
                        an=>an,
                        sevensg=>ssg);




process (mclk,nr(0))							  
	begin	  					  
     if mclk = '1' and mclk'Event then 
         cntClk <= cntClk + 1;
         --time1 will count the clocks beetwen one rotation of the fan
         if n1 = nr(0) then
              n1<=not(n1);
              time1<="00000000000000000000000000";
              --time0 = time1 / 8
              time0<=time1(25 downto 3);
         else
              time1<=time1 + 1;
         end if;

         if    cntClk(25 downto 0) =  "10111110101111000010000000" then
         --x1 is changing his value in every second
         x1<=not x1;
         end if;
     end if;

end process;

process (din(0))							  
	begin	  					  
         --din(0) is the fotosensor value
        if din(0) = '0' and din(0)'Event then 
            nr <=nr +1;
            if nr(0)='1' then
               --frame is used as address in BlockRAM
               frame<=frame+1;
               if frame="111" then
                  caracter<=caracter+1;
               end if;
            end if;
            --f2 is the fan's frequency
            if y1 = x1 then
                f2<=f1+1;
                f1<="00000000";
                y1<=not y1;
            else
                f1<=f1+1;
            end if;
        end if;

end process;

sync:process (mclk,n1)							  
begin	  					  
  if mclk = '1' and mclk'Event then 
   
   if n2 = n1 then
      n2<=not(n2);
      time2<=time0;
      line<="000";
   else
      --controlling the lines and coloumns
      if time2="00000000000000000000000" then
            time2<=time0;
            line<=line + 1;
      elsif line="000" and time2(21 downto 12)<(time0(22 downto 13)+ 35)
       and time2(21 downto 12)>(time0(22 downto 13)- 30) then
            col<=(time0(18 downto 13)+ 34)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;
      elsif line="001" and time2(21 downto 12)<(time0(22 downto 13)+ 34)
       and time2(21 downto 12)>(time0(22 downto 13)- 31) then
            col<=(time0(18 downto 13)+ 33)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;   
      elsif line="010" and time2(21 downto 12)<(time0(22 downto 13)+ 36)
       and time2(21 downto 12)>(time0(22 downto 13)- 29) then
            col<=(time0(18 downto 13)+ 35)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;
      elsif line="011" and time2(21 downto 12)<(time0(22 downto 13)+ 36)
       and time2(21 downto 12)>(time0(22 downto 13)- 29) then
            col<=(time0(18 downto 13)+ 35)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;
      elsif line="100" and time2(21 downto 12)<(time0(22 downto 13)+ 36)
       and time2(21 downto 12)>(time0(22 downto 13)- 29) then
            col<=(time0(18 downto 13)+ 35)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;
      elsif line="101" and time2(21 downto 12)<(time0(22 downto 13)+ 33)
       and time2(21 downto 12)>(time0(22 downto 13)- 32) then
            col<=(time0(18 downto 13)+ 32)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1; 
      elsif line="110" and time2(21 downto 12)<(time0(22 downto 13)+ 34)
       and time2(21 downto 12)>(time0(22 downto 13)- 31) then
            col<=(time0(18 downto 13)+ 33)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;
      elsif line="111" and time2(21 downto 12)<(time0(22 downto 13)+ 34)
       and time2(21 downto 12)>(time0(22 downto 13)- 31) then
            col<=(time0(18 downto 13)+ 33)-time2(17 downto 12);
            vidon<='1';
            time2<=time2 - 1;  
                                    
      else   
            vidon<='0';                       
            time2<=time2 - 1;           
      end if;
   end if;
  end if;

end process;

number<="00000000"&f2;

--selecting the right memori address
cc<=col(2 downto 0) - frame;
car<=caracter + 7 - col(5 downto 3)  when col(2 downto 0)>=frame else
     caracter + 8 - col(5 downto 3);

addres<=car&line&cc;



led(3 downto 0)<=din;
led(7 downto 4)<="0000";

--using the switches we can select different frequencies for the 
--laser beam
oc1 <= laser when (vidon='1' and swt="00000000") else
      cntClk(17) when swt="00000001" else
      cntClk(16) when swt="00000010" else
      cntClk(15) when swt="00000100" else
      cntClk(14) when swt="00001000" else
      cntClk(13) when swt="00010000" else
      cntClk(12) when swt="00100000" else
      cntClk(11) when swt="01000000" else
      cntClk(10) when swt="10000000" else
      cntClk(9) when swt="10000001" else
      cntClk(8) when swt="10000010" else
      cntClk(7) when swt="10000100" else
      cntClk(6) when swt="10001000" else
      cntClk(5) when swt="10010000" else
      cntClk(4) when swt="10100000" else
      cntClk(3) when swt="11000000" else
      cntClk(2) when swt="11000001" else
      cntClk(1) when swt="11000010" else
      cntClk(0) when swt="11000100" else
   '0';


end Behavioral;
