------------------------------------------------------------------------
-- vga_main.vhd  VGA & keyboard & DPIM controller and Text editor module
------------------------------------------------------------------------
-- 	Author: Perini Alpar
--            Technical University of Cluj-Napoca, Computer Science
------------------------------------------------------------------------
--
-- Inputs: 
--		mclk   	- 25 MHz divided or System Clock
--		swt		- 4 switches for communication and RGB colors
--   Keyboard module:
--		kd			- keyboard data in
--		kc			- keyboard clock in 
--   DPIM module:
--		pdb		- EPP data bus
--		astb		- EPP address strobe
--		dstb		- EPP data strobe
--		pwr		- EPP write (high=read, low=write)
--
-- Outputs:
--   DPIM module
--		pwait		- EPP wait synchronization signal 
--   VGA module
--		hs			- Horizontal Sync
--		vs			- Vertical Sync
--		red		- Red Output
--		grn		- Green Output
--		blu		- Blue Output
--
-- This module shows a way how a basic text editor can be done on a 
-- Nexys board. It also supports communication with an application 
-- program on a PC. It was developed using the Xilinx WebPack 7.1 ise
-- tools. 
-- The VGA module creates a 30 line x 80 column editor area on a display
-- having a vertical refresh rate of 60Hz and a resolution of 640x480.  
-- The 25 MHz pixel clock drives the vertical sync when the horizontal 
-- sync has reached its reset point. It uses a Video RAM to store
-- character codes that are later on converted to pixel patterns. 
-- It also has to store characters from the keyboard and the DPIM module
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity vgaEditor is
    Port 
	 	( 
			mclk	: in std_logic;
			swt	: in std_logic_vector(3 downto 0);  
			kd,kc	: in std_logic;
			pdb	: inout std_logic_vector(7 downto 0);
         astb 	: in std_logic;
         dstb 	: in std_logic;
         pwr	: in std_logic;
         pwait	: out std_logic;
			hs		: out std_logic;
         vs		: out std_logic;
         red 	: out std_logic;
         grn 	: out std_logic;
         blu 	: out std_logic			
		);
		
end vgaEditor;

architecture Behavioral of vgaEditor is

	component raminfr is
	port (
				clk	: in std_logic;
				enA	: in std_logic;
				weA	: in std_logic;
				addrA, addrB : in std_logic_vector(11 downto 0);
				diA	: in std_logic_vector(8 downto 0);
				doA	: out std_logic_vector(8 downto 0);
				doB	: out std_logic_vector(8 downto 0)
			);
	end component raminfr;

	component chmap is
    Port ( ascii	: in std_logic_vector(5 downto 0);
           line	: in std_logic_vector(2 downto 0);
           data	: out std_logic_vector(7 downto 0));
   end component chmap;
	
	component alu is
	port (line	: in std_logic_vector(5 downto 0);
			col 	: in std_logic_vector(6 downto 0);
			Res	: out std_logic_vector(11 downto 0)
		  );
	end component alu;

	component mux2to1 is
   generic ( N : integer := 12);
	port (a,b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o	: out std_logic_vector(N-1 downto 0)
		  );
	end component mux2to1;

	component codeMap is
    Port ( keycode 	: in std_logic_vector(7 downto 0);
           char_code : out std_logic_vector(5 downto 0));
	end component codeMap;

	------------------------------------------------------------------------
	-- Constant Declarations for display
	------------------------------------------------------------------------
	
	--800, Value of pixels in a horizontal line
	constant hpixels		: std_logic_vector(9 downto 0) := "1100100000";	
	--521, Number of horizontal lines in the display
	constant vlines		: std_logic_vector(9 downto 0) := "1000001001";	 
	--640, Number of Horizontal Visible pixels
	constant hvis			: std_logic_vector(9 downto 0) := "1010000000";  
	--480, Number of Vertical Visible Pixels
	constant vvis			: std_logic_vector(9 downto 0) := "0111100000";  
	--80 chars per line
	constant hchars		: std_logic_vector(6 downto 0) := "1001111";	 
	--30 lines of chars
	constant vchars		: std_logic_vector(4 downto 0) := "11101";	 
	--21, max line offset
	constant vbLimit		: std_logic_vector(4 downto 0) := "10101";	 
	--51*80-1, max video RAM addresses
	constant pAddrLimit	: std_logic_vector(11 downto 0):= "111111101111";

	------------------------------------------------------------------------
	-- Constant Declarations for DPIM
	------------------------------------------------------------------------
	constant	stEppReady	: std_logic_vector(7 downto 0) := "0000" & "0000";
	constant	stEppAwrA	: std_logic_vector(7 downto 0) := "0001" & "0100";
	constant	stEppAwrB	: std_logic_vector(7 downto 0) := "0010" & "0001";
	constant	stEppArdA	: std_logic_vector(7 downto 0) := "0011" & "0010";
	constant	stEppArdB	: std_logic_vector(7 downto 0) := "0100" & "0011";
	constant	stEppDwrA	: std_logic_vector(7 downto 0) := "0101" & "1000";
	constant	stEppDwrB	: std_logic_vector(7 downto 0) := "0110" & "0001";
	constant	stEppDrdA	: std_logic_vector(7 downto 0) := "0111" & "0010";
	constant	stEppDrdB	: std_logic_vector(7 downto 0) := "1000" & "0011";

  	------------------------------------------------------------------------
	-- Signal Declarations for display & editor
	------------------------------------------------------------------------

	-- Horizontal and vertical counters
	signal hc, vc			: std_logic_vector(9 downto 0):=(others => '0');
	-- Tells whether or not its ok to display data
	signal vidon			: std_logic;												 
	--Enable for the Vertical counter
	signal vsenable		: std_logic;												 
	--the current pixel on the display	
	signal pixel			: std_logic;													
	-- enables or disables the current pixel
	signal pixelEN		 	: std_logic;												
	-- a line of a character's 8x8 pixel pattern
	signal charLine		: std_logic_vector(7 downto 0);				

	--cursor counter for blinking
	signal cc				: std_logic_vector(4 downto 0):=(others =>'0');    
	--current and next horizontal cursor position
	signal hp, hp1			: std_logic_vector(6 downto 0):="0001000";			
	--current and next vertical cursor position
	signal vp, vp1			: std_logic_vector(4 downto 0):="01000";				
	--current and next vertical base for cursor
	signal vb, vb1			: std_logic_vector(4 downto 0):="00000";
	--final vertical counter for display and final vertical cursor for keyboard 
	signal fvc, fvp		: std_logic_vector(5 downto 0);
		
	
	--FF output of keyReleased
	signal keyRel0			: std_logic;								
	--FF output of keyRel0
	signal keyRel1			: std_logic;								
	--write enable signal for RAM, generated from keyRel0&1
	signal keyOn			: std_logic;								
	--register enable for the cursor positions, keyOn delayed by 1 clock
	signal keyOnBuff		: std_logic;								
	
	-- keyboard address obtained from horizontal and vertical cursor
	signal addr  			: std_logic_vector(11 downto 0);
	-- display address obtained from horizontal and vertical counters
	signal vgaAddr			: std_logic_vector(11 downto 0);
	-- video RAM address for port A
	signal addrA			: std_logic_vector(11 downto 0);
	-- final keyboard address
	signal kbAddr			: std_logic_vector(11 downto 0);	
	-- write enable and RAM enable signals for the video RAM
	signal kbWE, weA		: std_logic;
	signal enA				: std_logic;
	-- keyboard input data and RAM port A input data
	signal kbDataIn,diA		: std_logic_vector(8 downto 0);
	-- VGA display (port B) and RAM port A output data
	signal dataOut,doA	: std_logic_vector(8 downto 0);
	-- holds RGB colors from switches
	signal colors: std_logic_vector(2 downto 0);

	------------------------------------------------------------------------
	-- DPIM connection signals	to video RAM
	------------------------------------------------------------------------	
	
	-- communication module RAM address
	signal pAddr		:  std_logic_vector(11 downto 0);	
	-- incremented communication module RAM address	
	signal pAddrInc	:  std_logic_vector(11 downto 0);							
	-- communication module RAM write enable
	signal pwe			: std_logic;
	-- RAM input data from the communication module
	signal pdataIn		: std_logic_vector(8 downto 0); 
	-- RAM output data to the communication module
	signal pdataOut	: std_logic_vector(7 downto 0);
	-- activate or not the communication
	signal pcomm		: std_logic;
	-- RAM read signal inside the communcation module
	signal prd			: std_logic;
	-- enables the address register to latch the incremented address
	signal clkEnAddr		: std_logic;

	------------------------------------------------------------------------
	-- Signal Declarations for Keyboard
	------------------------------------------------------------------------
	
	-- clock divider counter	
	signal clkDiv3 : std_logic_vector (2 downto 0);
	-- divided clock (by 2**3) for the keyboard
	signal pclk : std_logic;
	-- internat keyboard data and clock
	signal KDI, KCI : std_logic;
	-- two flip-flops for kd and kc
	signal DFF1, DFF2 : std_logic;
	-- shift register for the first byte of the scan-code
	signal shiftRegSig1: std_logic_vector(10 downto 0);
	-- shift register for the second byte of the scan-code
	signal shiftRegSig2: std_logic_vector(10 downto 1);
	-- register that holds the new keyboard scan-code
	signal keyReg: std_logic_vector (7 downto 0);
	-- handshake signal active as long as key released
	signal keyReleased: std_logic; 
	
	------------------------------------------------------------------------
	-- Signal Declarations for DPIM
	------------------------------------------------------------------------

	-- DPIM State machine current state register
	signal	stEppCur	: std_logic_vector(7 downto 0) := stEppReady;

	signal	stEppNext	: std_logic_vector(7 downto 0);

	signal	clkMain		: std_logic;

	-- Internal control signales
	signal	ctlEppWait	: std_logic;
	signal	ctlEppAstb	: std_logic;
	signal	ctlEppDstb	: std_logic;
	signal	ctlEppDir	: std_logic;
	signal	ctlEppWr	: std_logic;
	signal	ctlEppAwr	: std_logic;
	signal	ctlEppDwr	: std_logic;
	signal	busEppOut	: std_logic_vector(7 downto 0);
	signal	busEppIn	: std_logic_vector(7 downto 0);
	signal	busEppData	: std_logic_vector(7 downto 0);

	-- Registers
	signal	regEppAdr	: std_logic_vector(3 downto 0);
	signal	regData0	: std_logic_vector(7 downto 0);
	signal	regData1	: std_logic_vector(7 downto 0);
   signal   regData2	: std_logic_vector(7 downto 0);
   signal   regData3	: std_logic_vector(7 downto 0);
   signal   regData4	: std_logic_vector(7 downto 0);
	signal	regData5	: std_logic_vector(7 downto 0);
	signal	regData6	: std_logic_vector(7 downto 0);
	signal	regData7	: std_logic_vector(7 downto 0);

	-- reduce signal skew by limiting the fanOut to 1	
	attribute MAX_FANOUT: string;
	attribute MAX_FANOUT of clkdiv3: signal is "1"; 
	attribute MAX_FANOUT of pAddr: signal is "1"; 
	attribute MAX_FANOUT of clkEnAddr: signal is "1"; 


	------------------------------------------------------------------------
	-- Module Implementation
	------------------------------------------------------------------------
	
begin

	-- turns on(1) or off(0) data communication
	pcomm <= swt(0);

	-- get the RBG colors from the swithces
	colors <= swt(3 downto 1);


  	------------------------------------------------------------------------
	-- Keyboard Module Implementation
	------------------------------------------------------------------------
	
	--Divide the master clock down to a lower frequency
	CLKDivider: Process (mclk)
	begin
		if (mclk = '1' and mclk'Event) then 
			clkDiv3 <= clkDiv3 +1; 
		end if;	
	end Process;

	pclk <= clkDiv3(2);

	--Flip Flops used to condition siglans coming from PS2
	Process (pclk, KC, KD)
	begin
			if (pclk = '1' and pclk'Event) then				
				DFF1 <= KD; KDI <= DFF1; DFF2 <= KC; KCI <= DFF2;			
			end if;
	end process;

	--Shift Registers used to clock in scan codes from PS2
	Process(KDI, KCI) --DFF2 carries KD and DFF4, and DFF4 carries KC
	begin																					  
			if (KCI = '0' and KCI'Event) then
				ShiftRegSig1(10 downto 0) <= KDI & ShiftRegSig1(10 downto 1);
				ShiftRegSig2(10 downto 1) <= ShiftRegSig1(0) & 
																ShiftRegSig2(10 downto 2);
			end if;
	end process;
	
	--Key Register loaded when F0 key-up code received
	process(ShiftRegSig1, ShiftRegSig2, KCI)
	begin
			if(KCI'event and KCI = '1') then 
				if ShiftRegSig2(8 downto 1) = "11110000" then 
						keyReleased <= '1';
						keyReg <= ShiftRegSig1(8 downto 1);
			   else
						keyReleased <= '0';
			   end if;
			end if;			
	end Process;
 

	------------------------------------------------------------------------
	-- Display Module Implementation
	------------------------------------------------------------------------

	--Runs the horizontal counter
	process(mclk)
		begin
			if(mclk = '1' and mclk'EVENT) then
				--If the counter has reached the end of pixel count
				if hc = hpixels-1 then
					--reset the counter
					hc <= "0000000000";													 
					--Enable the vertical counter to increment
					vsenable <= '1';
				else
					--Increment the horizontal counter
					hc <= hc + 1;
					--Leave the vsenable off				
					vsenable <= '0';
				end if;
		end if;
	end process;

	--Horizontal Sync Pulse
	hs <= '0' when  (hc>="1010010000" and hc<"1011110000") else '1';
	-- if 656 < hc < 752	then 0

	--vertical counter
	process(mclk)
	begin
		--Increment when enabled
		if(mclk = '1' and mclk'EVENT and vsenable = '1') then	
			--Reset when the number of lines is reached
			if vc = vlines-1 then
				vc <= "0000000000";
				cc <= cc +1 ;
			--Increment the vertical counter
			else vc <= vc + 1;															 
			end if;
		end if;
	end process;

	--Vertical Sync Pulse
	vs <= '0' when (vc>="0111101010" and vc<"0111101100") else '1';
	-- if 490 < vc < 492	then 0
  	
	-- red, green, blue vga signals active when visible area, the pixel 
	-- is enabled and the corresponding bit read from RAM is set
	red <= '1' when (dataout(2) = '1' and pixelEN='1' and vidon ='1') else '0';			 --Red pixel on at a specific horizontal count
  	grn <= '1' when (dataout(1) = '1' and pixelEN='1' and vidon ='1') else '0';			 --Green pixel on at a specific horizontal count
  	blu <= '1' when (dataout(0) = '1' and pixelEN='1' and vidon ='1') else '0';			 --Blue pixel on at a specific vertical count
						
	-- Video RAM used mainly for displaying text
	-- it also receives input data from keyboard and communication module
	dVR: raminfr port map
			(				
				clk	=> mclk,
				enA	=> enA,
				weA	=> weA,
				addrA => AddrA,
				addrB => vgaAddr,
				diA	=> diA,
				doA 	=> doA,
				doB	=> dataout				
			);
	
	-- enables the video RAM all the time
	enA <= '1';

	-- address for port A is selected from keyboard address 
	-- and parallel interface address by the pcomm signal
	addrAMux: MUX2to1 
			generic map (N => 12) 
			port map 
				( 
					a => kbAddr,
					b => pAddr,					--vertical prompt address
					sel => pcomm,				--selection keyON
					o => addrA					--final VGA line address
				);

	-- based address for keyboard input data
	-- map the line and column address to continuous memory addresses
	fvp <= vp + ('0' & vb);
	addrAComp: ALU port map 
				( 
					Line => fvp,
					Col => hp,
					Res => Addr
				);

	-- if backspace was pressed, the character to the left has to be 
	-- erased (that's why decrement)
	kbAddr <= addr-1 when addr>0 and keyOn='1' and keyReg=x"66" else addr;

	-- display address for port B obtained from the horizontal and vertical 
	-- counters map the line and column address to continuous memory space

	-- final vertical counter by adding the vertical base to the offset
	fvc <= vc(8 downto 4) + ('0'& vb);
	addrBComp: ALU port map 
				( 
					Line => fvc,
					Col => hc(9 downto 3),
					Res => vgaAddr
				);

	--multiplexes the keyboard and DPIM data line to final RAM port A input data
	diMux: MUX2to1 
		generic map (N => 9) 
		port map 
			( 
				a => kbDataIn,
				b => pdatain,
				sel => pcomm,
				o => diA
			);
			
	--multiplexes the keyboard and DPIM write enable to port A input data
	weA <= kbWE when pComm = '0' else pWE;


	-- the shape of a character obtained as pixel lines from this character map 
	C: chmap port map 
			( 
				ascii => dataout (8 downto 3), 
				line => vc(2 downto 0), 
				data => charLine
			);
	
	-- obtains the current pixel from the character line (MSb should be last)
	-- using the least significant 8 bits from the horizontal counter
	-- in fact it implements an 8:1 MUX
	pixel <= charLine(7 - conv_integer(hc(2 downto 0)));
		
	-- enables a pixel when it is part of the blinking cursor
	-- or when the bit is a 1 in the pixel pattern
	pixelEN <= '1' when (hp = hc(9 downto 3) and vp = vc(8 downto 4) and 
					hc(2 downto 0)="000" and cc(4)='1') else pixel;												

	-- Enable video out when within the porches (visible area) and it is 
	-- an even char line
	vidon <= '1' when (hc < hvis and vc < vvis and vc(3)='0') else '0';
	
	-- Flip-flop to delay the keyReleased by 1 clock cycle
	DeFF0: process (mclk, keyReleased)
	begin
		if rising_edge(mclk) then  
			keyRel0 <= keyReleased;
		end if;		
	end process;
	
	--Flip-flop to delay the keyReleased by 2 clock cycle
	DeFF1: process (mclk, keyRel0)
	begin
		if rising_edge(mclk) then  
			keyRel1 <= keyRel0;			
		end if;		
	end process;

	--Flip-flop to obtain a single clock pulse at a 3 cyle delay
	DeFF2: process (mclk, keyRel0, keyRel1)
	begin
		if rising_edge(mclk) then
			if keyRel0 = '1' and keyRel1 = '0' then
				keyOn <= '1';
			else
				keyOn <= '0';
			end if;
		end if;
	end process;
	
	--Flip-flop to obtain a single clock pulse at a 4 cyle delay
	DeFF3: process (mclk, keyOn)
	begin
		if rising_edge(mclk) then
			if keyOn = '1' then
				keyOnBuff <= '1';
			else
				keyOnBuff <= '0';
			end if;
		end if;
	end process;

	-- Convert the keyboard scan-code to character code (ASCII-like)
	codeConv: codeMap port map
				(
					keyCode => keyReg,
					char_code => kbDataIn(8 downto 3)
				);
																						 
	-- the last three bits of the input data are the switches for the 
	-- basic three colors
	kbDataIn(2 downto 0) <= colors;

	-- the write enable for keyboard data is when a key was pressed 
	-- and it is a known key otherwise disabled
	kbWE <= '0' when kbDataIn(8 downto 3)="111111" else keyOn;
	
	-- moves the cursor according to the type of key the keyReg buffer contains
	moveCursor: process(keyReg, hp, vp, vb)
	begin

		  case keyReg is 
		  
			when x"5A" => 		--enter
							   if vp < vchars then
									hp1 <= (others => '0');
							  		vp1 <= vp + 1; 
									vb1 <= vb;
								elsif vb < vbLimit then
									 hp1 <= (others => '0');
									 vp1 <= vp;
									 vb1 <= vb + 1;
								else
									hp1 <= hp;
									vp1 <= vp;
									vb1 <= vb;
								end if;
								
			when x"66" =>  	--backspace
						 if hp = "0000000" 
						 	then if vp>"00000" 
									 then vp1 <= vp - 1;
								  			hp1 <= hchars;
											vb1 <= vb;
									 else 
											vp1 <= vp;
											hp1 <= hp;
											vb1 <= vb;
								  end if;
							else 
								hp1 <= hp - 1;
								vp1 <= vp;
								vb1 <= vb;
						 end if;
						
			when x"6C" => 		--home
						vp1 <= vp;
						hp1 <= (others => '0');
						vb1 <= vb;
						
			when x"69" => 		--end
						hp1 <= hchars;
						vp1 <= vp;
						vb1 <= vb;
						
			when x"75" =>		--up
						if vp > "00000" then
							vp1 <= vp-1;
							hp1 <= hp;							
							vb1 <= vb;
						elsif vb > "00000" then
							vp1 <= vp;
							hp1 <= hp;
							vb1 <= vb - 1;
						else
							vp1 <= vp;
							hp1 <= hp;
							vb1 <= vb;							
						end if;		
						
			when x"72" =>		--down
						if vp < vchars then
							vp1 <= vp+1;
							hp1 <= hp;
							vb1 <= vb;
						elsif vb < vbLimit then
							vp1 <= vp;
							hp1 <= hp;
							vb1 <= vb + 1;
						else
							vp1 <= vp;
							hp1 <= hp;
							vb1 <= vb;
						end if;
						
			when x"74" =>		--right
						if hp < hchars	then
							hp1 <= hp+1;
							vp1 <= vp;
							vb1 <= vb;
						else
							hp1 <= hp;
							vp1 <= vp;
							vb1 <= vb;
						end if;
						
			when x"6B" =>		--left
						if hp > "0000000" then
							hp1 <= hp-1;
							vp1 <= vp;
							vb1 <= vb;
						else
							hp1 <= hp;
							vp1 <= vp;
							vb1 <= vb;
						end if;
						
			when others =>	 	--just move to the right
						 if hp = hchars 						
							then 
					  			  if vp<vchars then
								  	  vp1 <= vp + 1;
									  hp1 <= (others => '0');
									  vb1 <= vb;
									elsif vb < vbLimit then
									  vp1 <= vp;
									  hp1 <= (others => '0');
									  vb1 <= vb + 1;
									else
									  vp1 <= vp;
									  hp1 <= hp;
									  vb1 <= vb;
								  end if;
							else hp1 <= hp + 1;
								  vp1 <= vp;
								  vb1 <= vb;
		   			 end if;
			end case;
	end process moveCursor;

	-- validate the position change on the clock's rising edge 
	-- when the keyOnBuff is high
	clkMoveCursor: process (mclk, hp1, vp1)
	begin
		if rising_edge(mclk) then
		  if keyOnBuff = '1' then
			hp <= hp1;
			vp <= vp1;
			vb <= vb1;
		  end if;
		end if;
	end process clkMoveCursor;
				
	-- Output data to the DPIM on 8 bits containing exclusively the 
	-- character code 
	pdataout <= "00" & doA(8 downto 3);
	
	------------------------------------------------------------------------
	-- The Digilent Parallel Interface Model (DPIM) Reference Design modified 
	-- and added not as component because that introduced a warning, causing 
	-- the keyboard not to work
	------------------------------------------------------------------------
	
	clkMain <= mclk;

	ctlEppAstb <= astb;
	ctlEppDstb <= dstb;
	ctlEppWr   <= pwr;
	pwait      <= ctlEppWait;	-- drive WAIT from state machine output

	-- Data bus direction control. The internal input data bus always
	-- gets the port data bus. The port data bus drives the internal
	-- output data bus onto the pins when the interface says we are doing
	-- a read cycle and we are in one of the read cycles states in the
	-- state machine.
	busEppIn <= pdb;
	pdb <= busEppOut when ctlEppWr = '1' and ctlEppDir = '1' else "ZZZZZZZZ";

	-- Select either address or data onto the internal output data bus.
	busEppOut <= "0000" & regEppAdr when ctlEppAstb = '0' else busEppData;

	-- Decode the address register and select the appropriate data register
	busEppData <=	regData0 when regEppAdr = "0000" else
					regData1 when regEppAdr = "0001" else
					regData2 when regEppAdr = "0010" else
					regData3 when regEppAdr = "0011" else
					regData4 when regEppAdr = "0100" else
					regData5 when regEppAdr = "0101" else
					regData6 when regEppAdr = "0110" else
					regData7 when regEppAdr = "0111" else
					pdataout when regEppAdr = "1001" else
					"00000000";

    ------------------------------------------------------------------------
	-- EPP Interface Control State Machine
    ------------------------------------------------------------------------

	-- Map control signals from the current state
	ctlEppWait <= stEppCur(0);
	ctlEppDir  <= stEppCur(1);
	ctlEppAwr  <= stEppCur(2);
	ctlEppDwr  <= stEppCur(3);

	-- This process moves the state machine to the next state
	-- on each clock cycle
	process (clkMain)
		begin
			if clkMain = '1' and clkMain'Event then
				if pcomm = '0' then
					stEppCur <= stEppReady;
				else
					stEppCur <= stEppNext;
				end if;
			end if;
		end process;

	-- This process determines the next state machine state based
	-- on the current state and the state machine inputs.
	process (stEppCur, stEppNext, ctlEppAstb, ctlEppDstb, ctlEppWr)
		begin
			case stEppCur is
				-- Idle state waiting for the beginning of an EPP cycle
				when stEppReady =>
					if ctlEppAstb = '0' then
						-- Address read or write cycle
						if ctlEppWr = '0' then
							stEppNext <= stEppAwrA;
						else
							stEppNext <= stEppArdA;
						end if;

					elsif ctlEppDstb = '0' then
						-- Data read or write cycle
						if ctlEppWr = '0' then
							stEppNext <= stEppDwrA;
						else
							stEppNext <= stEppDrdA;
						end if;

					else
						-- Remain in ready state
						stEppNext <= stEppReady;
					end if;											

				-- Write address register
				when stEppAwrA =>
					stEppNext <= stEppAwrB;

				when stEppAwrB =>
					if ctlEppAstb = '0' then
						stEppNext <= stEppAwrB;
					else
						stEppNext <= stEppReady;
					end if;		

				-- Read address register
				when stEppArdA =>
					stEppNext <= stEppArdB;

				when stEppArdB =>
					if ctlEppAstb = '0' then
						stEppNext <= stEppArdB;
					else
						stEppNext <= stEppReady;
					end if;

				-- Write data register
				when stEppDwrA =>
					stEppNext <= stEppDwrB;

				when stEppDwrB =>
					if ctlEppDstb = '0' then
						stEppNext <= stEppDwrB;
					else
 						stEppNext <= stEppReady;
					end if;

				-- Read data register
				when stEppDrdA =>
					stEppNext <= stEppDrdB;
										
				when stEppDrdB =>
					if ctlEppDstb = '0' then
						stEppNext <= stEppDrdB;
					else
				  		stEppNext <= stEppReady;
					end if;

				-- Some unknown state				
				when others =>
					stEppNext <= stEppReady;

			end case;
		end process;
		
    ------------------------------------------------------------------------
	-- EPP Address register
    ------------------------------------------------------------------------

	process (clkMain, ctlEppAwr)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppAwr = '1' then
					regEppAdr <= busEppIn(3 downto 0);
				end if;
			end if;
		end process;

    ------------------------------------------------------------------------
	-- EPP Data registers
    ------------------------------------------------------------------------
 	-- The following processes implement the interface registers. These
	-- registers just hold the value written so that it can be read back.
	-- In a real design, the contents of these registers would drive additional
	-- logic.
	-- The ctlEppDwr signal is an output from the state machine that says
	-- we are in a 'write data register' state. This is combined with the
	-- address in the address register to determine which register to write.

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0000" then
					regData0 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0001" then
					regData1 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0010" then
					regData2 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0011" then
					regData3 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0100" then
					regData4 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0101" then
					regData5 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0110" then
					regData6 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "0111" then
					regData7 <= busEppIn;
				end if;
			end if;
		end process;
		
	-- Register number 8 is for sending 8 bit character codes to the display
	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		variable temp: std_logic_vector(7 downto 0);
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "1000" then
					temp := busEppIn;
					-- Set Video RAM write enable when it was addressed
					pWe <= '1';
				else
					-- Reset write enable
					pWe <= '0';
				end if;
				-- Prepare the received data for the display
				pDatain <= temp(5 downto 0) & colors;
			end if;
		end process;
		
	-- Reading of register 9 is for sending 8 bit character codes to the PC
	process (clkMain, regEppAdr)
		begin
			if clkMain = '1' and clkMain'Event then
				if steppcur = StEppDRdA and regEppAdr = "1001" then
					-- generate a read signal to mark a read transfer
					pRd <= '1';
				else
					pRd <= '0';
				end if;
			end if;
		end process;

	-- the Video RAM address is incremented whenever there was a read or 
	-- write cycle this signal is used as a clock enable for that counter
	process(clkMain)
	begin
		if rising_edge(clkMain) then
			clkEnAddr <= pWe or pRd;
		end if;
	end process;

	-- the Address counter process
	process(clkMain)
	begin
		if rising_edge(clkMain) then
			if clkEnAddr = '1' then				
				if pAddr = pAddrLimit then
					-- reset if reached the max no of chars
					pAddr <= (others => '0');
				else
					-- latch the incremented address
					pAddr <= pAddrInc;
				end if;
			end if;
		end if;
	end process;

	-- incremented RAM address from communication module	
	pAddrInc <= pAddr + 1;

end Behavioral; 