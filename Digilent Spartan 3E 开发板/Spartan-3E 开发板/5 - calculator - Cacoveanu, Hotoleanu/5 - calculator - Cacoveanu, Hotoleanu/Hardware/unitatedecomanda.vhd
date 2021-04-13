----------------------------------------------------------------------------------
-- Create Date:    20:51:45 09/17/2006 
-- Module Name:    unitatedecomanda - arhunitatedecomanda
-- Project Name:   impartitor
-- Tool versions:  Xilinx 8.1 
-- Author:         Hotoleanu Dan 
-- Description:    This module is the command unit for the divider
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
--clk - clock
--ce - clock enable
--ct1reached - counter1 has reached the state 0
--ct2reached - counter2 has reached the state 1
--ct reached - counter_ct has reached the state 9 
--countreached - counter numere has reached the state 9
--aegalb - signals if a>=b
--endeimp - enables the register that receives the number a which will be divided
--resdeimp - resets the register that receives the number
--enimp - enables the register that receives the number b which will devide a
--resdeimp - resets the register that stores b
--enct1 - enables the counter1
--resct1 - resets the counter1
--enct2 - enables the counter2
--resct2 - resets the counter2
--encounter - enables the counter numere
--rescounter - resets the counter numere
--enct - enables the counter_ct
--resct - resets the counter_ct
--eninmultitor - enables the multiplier
--resinmultitor - resets the multiplier
--countdirection - sets the direction in which the counter numere counts
--enregistru - enables the register registru
--resregistru - resets the register registru
--enpl - enables the loading of the multiplier
--enrez - enables the register rezultat
--resrez - resets the register rezultat
--enregscad - enables the register registruscazator
--resregscad - resets the register registruscazator
--s - selection for the multiplexer
--enflag - output that signals if the divider has finished divideing the numbers
----------------------------------------------------------------------------------
entity unitatedecomanda is
	port (clk,ce,reset,ct1reached,ct2reached,ctreached,aegalb,
	      countreached:in std_logic;
	endeimp,resdeimp,enimp,resimp,enct1,resct1,enct2,resct2,
	encounter,rescounter,enct,resct,eninmultitor,resinmultitor,countdirection,
	enregistru,resregistru,enpl,enrez,resrez,enregscad,resregscad,s:out std_logic);
end unitatedecomanda;

architecture arhunitatedecomanda of unitatedecomanda is
type tip_stare is (a,b,c,d,e,f,g,h,i,j,k,l,aux1,aux2,stop);
signal stare_prez,stare_urm:tip_stare;
begin
	proc_comb: process (stare_prez, ct1reached, ct2reached, ctreached, aegalb)				
				begin
				if (reset='1') then endeimp<='1';
									resdeimp<='1';
									enimp<='1';
									resimp<='1';
									enct1<='1';
									resct1<='1';
									enct2<='1';
									resct2<='1';
									encounter<='1';
									rescounter<='1';
									enct<='1';
									resct<='1';
									enregistru<='1';
									resregistru<='1';
									eninmultitor<='1';
									resinmultitor<='1';
									enrez<='1';
									resrez<='1';
									countdirection<='0';
									enpl<='0';
									enregscad<='1';
									resregscad<='1';
									s<='1'; 
									stare_urm<=a;
					else 
					case stare_prez is 
						when a => 	endeimp<='1';
									resdeimp<='0';
									enimp<='1';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';
									countdirection<='0';
									enpl<='0'; 
									enregscad<='0';
									resregscad<='0';
									s<='1';
									stare_urm<=b;
						when b =>	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='1';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='1';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';                           
									stare_urm<=c;
						when c =>   endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='1';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='1';
									resinmultitor<='1';
									enrez<='0';
									resrez<='0';  
									countdirection<='1';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';
									stare_urm<=d;
						when d =>	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='1';
									resct<='1';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='1';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='1';	   
									enregscad<='0';
									resregscad<='0';
									s<='1';  
									stare_urm<=e;
						when e =>	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='1';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='1';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';                          
							if (ctreached = '1') then
												stare_urm <= f;
											else
												stare_urm <= e;
							end if;
					   when f =>  	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='1';
									resct<='1';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';                             
							if (aegalb = '1') then stare_urm<=aux1;
							else stare_urm<=g;
							end if;  
                  when aux1 =>endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';  									
                     if (countreached='1') then stare_urm<=aux2;
                     else stare_urm<=c;
                     end if;
						when g =>endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='1';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';                           
									stare_urm<=aux2;
                  when aux2 =>endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='1';
									resinmultitor<='1';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='1';                           
                           stare_urm<=h;
						when h => 	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='1';
									resinmultitor<='0';
									enrez<='1';
									resrez<='0';  
									countdirection<='0';
									enpl<='1';	  
									enregscad<='0';
									resregscad<='0'; 
									s<='1';                            
									stare_urm<=i;
						when i =>	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='1';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='1';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0'; 
									s<='1';                             
							if (ctreached='1') then stare_urm<=j;
							else stare_urm<=i;
							end if;								
						when j =>	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='1';
									resregistru<='1';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';	
									enpl<='0';	
									enregscad<='1';
									resregscad<='0'; 
									s<='0';                           
									stare_urm<=k;
						when k => 	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='1';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='1';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';
									enpl<='0';	  
									enregscad<='0';
									resregscad<='0';
									s<='0';                           
							if (ct2reached='1') then stare_urm<=l;
							else stare_urm<=k;
							end if;
						when l =>	endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='1';
									resct2<='1';
									encounter<='1';
									rescounter<='1';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';  
									countdirection<='0';	
									enpl<='0';	
									enregscad<='0';
									resregscad<='0';
									s<='0'; 
							if (ct1reached='1') then stare_urm<=stop;                                             
							else stare_urm<=b;
							end if;
				when stop =>   endeimp<='0';
									resdeimp<='0';
									enimp<='0';
									resimp<='0';
									enct1<='0';
									resct1<='0';
									enct2<='0';
									resct2<='0';
									encounter<='0';
									rescounter<='0';
									enct<='0';
									resct<='0';
									enregistru<='0';
									resregistru<='0';
									eninmultitor<='0';
									resinmultitor<='0';
									enrez<='0';
									resrez<='0';
									countdirection<='0';
									enpl<='0';
									enregscad<='0';
									resregscad<='0';
									s<='0';                            
				end case;
				end if;
	end process proc_comb;
	
	proc_secv: process(clk)
			begin
			if (rising_edge(clk)) and (ce='1') then 
				stare_prez<=stare_urm;
			end if;
	end process proc_secv;
end arhunitatedecomanda;		