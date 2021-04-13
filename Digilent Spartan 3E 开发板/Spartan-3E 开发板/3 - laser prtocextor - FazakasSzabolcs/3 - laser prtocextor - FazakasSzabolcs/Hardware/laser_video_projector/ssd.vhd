--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    00:43:20 10/05/06
-- Design Name:    
-- Module Name:    ssg - Behavioral
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
------------------------------------------------------------------------
-- This component controls the seven segment display
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk             Input      Main clock input 
-- number(15:0)     Input      Data
-- an(15:0)         Output     anod
-- sevensg          Output     Sven segment display
--
------------------------------------------------------------------------
entity ssd is
Port(    clk    : in std_logic_vector(1 downto 0);
          number   : in std_logic_vector(15 downto 0);

        an           :out std_logic_vector(3 downto 0);
        sevensg : out std_logic_vector(6 downto 0)
        );
end ssd;

architecture Behavioral of ssd is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
      
------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
    signal Ssegcnt           : std_logic_vector(3 downto 0):="0000";
    signal dig  		    : std_logic_vector(6 downto 0);

begin
    an(3) <= not (not clk(0) and not clk(1));
	an(2) <= not (not clk(0) and     clk(1));
	an(1) <= not (    clk(0) and not clk(1));
	an(0) <= not (    clk(0) and     clk(1));

   Ssegcnt <= number(15 downto 12) when clk(1 downto 0)="00" else
	 number(11 downto 8) when clk(1 downto 0)="10" else
	 number(7 downto 4) when clk(1 downto 0)="01" else
	 number(3 downto 0) when clk(1 downto 0)="11" else
    "0000";


    dig <=  "0111111" when Ssegcnt = "0000" else
		   "0000110" when Ssegcnt = "0001" else
		   "1011011" when Ssegcnt = "0010" else
		   "1001111" when Ssegcnt = "0011" else
		   "1100110" when Ssegcnt = "0100" else
		   "1101101" when Ssegcnt = "0101" else
		   "1111101" when Ssegcnt = "0110" else
		   "0000111" when Ssegcnt = "0111" else
		   "1111111" when Ssegcnt = "1000" else
		   "1101111" when Ssegcnt = "1001" else
		   "1110111" when Ssegcnt = "1010" else
		   "1111100" when Ssegcnt = "1011" else
		   "0111001" when Ssegcnt = "1100" else
		   "1011110" when Ssegcnt = "1101" else
		   "1111001" when Ssegcnt = "1110" else
		   "1110001" when Ssegcnt = "1111" else
		   "0001000";
		   
    
	sevensg <= not dig;

    
	

end Behavioral;
