------------------------------------------------------------------------
--     keyboard.vhd -- Demonstrate basic keyboard function
------------------------------------------------------------------------
-- Author:  Ken Nelson
--          Copyright 2004 Digilent, Inc.
--
-- Modified by: Cacoveanu Silviu & Hotoleanu Dan
------------------------------------------------------------------------
-- Software version: Xilinx ISE 7.1i 
--                   WebPack
------------------------------------------------------------------------
-- This source file contains the keyboard component
-- It returns the scancode of the released key
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyboard is
	port( CLK, KD, KC: in std_logic;
			RDY: buffer std_logic;
			scancode: out std_logic_vector (7 downto 0)
		 );
end keyboard;

architecture Behavioral of keyboard is

signal clkDiv : std_logic_vector (3 downto 0) := "0000";
signal pclk : std_logic;
signal KDI, KCI : std_logic;
signal DFF1, DFF2 : std_logic;
signal shiftRegSig1: std_logic_vector(10 downto 0);
signal shiftRegSig2: std_logic_vector(10 downto 1);
signal WaitReg: std_logic_vector (7 downto 0) := "00000000";
signal lastvalue : std_logic_vector(7 downto 0) := "00000000";
signal receivedChar : std_logic := '0';

begin
	
	--Divide the master clock down to a lower frequency--
	CLKDivider: Process (CLK)
	begin
		if (CLK = '1' and CLK'Event) then 
			clkDiv <= clkDiv +1; 
		end if;	
	end Process;

	pclk <= clkdiv(3);

	--Flip Flops used to condition signals coming from PS2--
	Process (pclk, KC, KD)
	begin
		if (pclk = '1' and pclk'Event) then
			DFF1 <= KD; KDI <= DFF1; DFF2 <= KC; KCI <= DFF2;
		end if;
	end process;

	--Shift Registers used to clock in scan codes from PS2--
	--DFF2 carries KD and DFF4, and DFF4 carries KC
	Process(KDI, KCI) 
	begin																					  
		if (KCI = '0' and KCI'Event) then
			ShiftRegSig1(10 downto 0) 
				<= KDI & ShiftRegSig1(10 downto 1);
			ShiftRegSig2(10 downto 1) 
				<= ShiftRegSig1(0) & ShiftRegSig2(10 downto 2);
		end if;
	end process;
	
	--Wait Register
	process(ShiftRegSig1, ShiftRegSig2,  RDY, KCI)
	begin
		--reset WaitReg and receivedchar flag after RDY='1' for 1 period
		if(RDY='1')then 
			WaitReg <= "00000000";
			receivedchar <= '0';
		else
			if(KCI'event and KCI = '1')then 
				if (ShiftRegSig2(8 downto 1) = "11110000") then
					WaitReg <= ShiftRegSig1(8 downto 1);
					receivedchar <= '1';
				end if;			
			end if;			
		end if;
	end Process;

	process(clk)
	begin
		if(clk'event and clk='1') then
			if (receivedchar='1') then
				lastvalue <= WaitReg;
				RDY <= '1';				
			else
				RDY <= '0';
			end if;
		end if;
	end process;

	scancode <= lastvalue;
				
end Behavioral;