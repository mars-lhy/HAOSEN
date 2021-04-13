------------------------------------------------------------------------
-- dcm_25MHz.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the design for a dcm that generates a 25MHz clock
-- from a 100MHz one.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- A DCM device primitive is instantiated to generate a 25MHz clock
-- from a 100MHz clock input. The output clock is not buffered.
-- The entity provides an output pin RESET_OUT used to cascade multiple
-- DCM's. The RESET_OUT from the entity is connected to RST_IN of the
-- next DCM. The first RST_IN is the reset signal provided from an I/O
-- pin or internal logic. The last RESET_OUT is the global reset the 
-- fpga should use. This way, the logic will be in a reset state until
-- all the DCM's provide stable clock outputs.
--
-- The 25MHz output clock will be used as pixel clock
-- for the 640x480@60Hz resolution.
--
-- Note: The reset output is unbuffered.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- CLK_IN      - global clock input with frequency of 100MHz
-- RST_IN      - reset input provided from internal logic, I/O pin, or
--             - from the RESET_OUT pin of another such entity as this.
-- CLKFX_OUT   - output clock of 25MHz provided by the DCM
-- RESET_OUT   - reset output used to cascade multiple such entities
--             - or to drive the global reset signal.
--             - This output is the inversion of the LOCKED_OUT output
--             - of the DCM.
------------------------------------------------------------------------
-- Revision History:
-- 09/18/2006(UlrichZ): created
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

-- simulation library.
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on

-- dcm that generates 25MHz clock from 100MHz
-- output clock (CLKFX_OUT) is not buffered
-- RESET_OUT is active while LOCKED signal from dcm is not active
-- RESET_OUT is used to cascade dcm's and provide global reset
-- RESET_OUT from one dcm goes into RST_IN of the next dcm
-- Global reset button is connected to RST_IN of the first dcm
-- RESET_OUT of the last dcm is the global reset used throughout
-- the fpga
entity dcm_25MHz is
port(
   CLKIN_IN   : in    std_logic; 
   RST_IN     : in    std_logic; 
   CLKFX_OUT  : out   std_logic; 
   RESET_OUT  : out   std_logic
);
end dcm_25MHz;

-- architecture of dcm_25MHz entity
architecture structural of dcm_25MHz is

   -- LOCKED signal from the DCM output
   -- indicating whether output clock is valid or not.
   signal LOCKED     : std_logic;
   -- tied to '0'
   signal GND        : std_logic;

   -- Declaration of DCM device primitive
   -- Period Jitter (unit interval) for block DCM_INST = 0.03 UI
   -- Period Jitter (Peak-to-Peak) for block DCM_INST = 1.23 ns
   component DCM
      generic( CLK_FEEDBACK : string :=  "1X";
               CLKDV_DIVIDE : real :=  2.000000;
               CLKFX_DIVIDE : integer :=  1;
               CLKFX_MULTIPLY : integer :=  4;
               CLKIN_DIVIDE_BY_2 : boolean :=  FALSE;
               CLKIN_PERIOD : real :=  0.000000;
               CLKOUT_PHASE_SHIFT : string :=  "NONE";
               DESKEW_ADJUST : string :=  "SYSTEM_SYNCHRONOUS";
               DFS_FREQUENCY_MODE : string :=  "LOW";
               DLL_FREQUENCY_MODE : string :=  "LOW";
               DUTY_CYCLE_CORRECTION : boolean :=  TRUE;
               FACTORY_JF : bit_vector :=  x"C080";
               PHASE_SHIFT : integer :=  0;
               STARTUP_WAIT : boolean :=  FALSE;
               DSS_MODE : string :=  "NONE");
      port ( CLKIN    : in    std_logic; 
             CLKFB    : in    std_logic; 
             RST      : in    std_logic; 
             PSEN     : in    std_logic; 
             PSINCDEC : in    std_logic; 
             PSCLK    : in    std_logic; 
             DSSEN    : in    std_logic; 
             CLK0     : out   std_logic; 
             CLK90    : out   std_logic; 
             CLK180   : out   std_logic; 
             CLK270   : out   std_logic; 
             CLKDV    : out   std_logic; 
             CLK2X    : out   std_logic; 
             CLK2X180 : out   std_logic; 
             CLKFX    : out   std_logic; 
             CLKFX180 : out   std_logic; 
             STATUS   : out   std_logic_vector (7 downto 0); 
             LOCKED   : out   std_logic; 
             PSDONE   : out   std_logic);
   end component;

   -- Sets the black_box attribute of component DCM
   -- Explicitly tells the synthesizer
   -- to treat the component as a black box.
   -- As a result the synthetizer will not generate a warning for
   -- inferring a black box.
   attribute box_type : string; 
   attribute box_type of DCM: component is "black_box";

   -- Manually specify the location of the DCM on the fpga.
   -- Necessary because automatic placement of DCM's might
   -- position them in such a way that routing delays would
   -- make the logic not function properly.
   -- X0Y1 means Top-Left corner of the FPGA on a XC3S200 device
   attribute loc : string;
   attribute loc of DCM: component is "DCM_X0Y1";
   
begin

   RESET_OUT <= not LOCKED;
   GND <= '0';
   
   -- Instantiation of the DCM device primitive.
   -- Feedback is not used.
   -- Clock multiplier is 2 (allowed range 2-32)
   -- Clock divider is 8
   -- 100MHz * 2/8 = 25MHz
   DCM_INST : DCM
   generic map( CLK_FEEDBACK => "NONE",
            CLKDV_DIVIDE => 2.000000,
            CLKFX_DIVIDE => 8,
            CLKFX_MULTIPLY => 2,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 10.000000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>GND,
                CLKIN=>CLKIN_IN,
                DSSEN=>GND,
                PSCLK=>GND,
                PSEN=>GND,
                PSINCDEC=>GND,
                RST=>RST_IN,
                CLKDV=>open,
                CLKFX=>CLKFX_OUT,
                CLKFX180=>open,
                CLK0=>open,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>LOCKED,
                PSDONE=>open,
                STATUS=>open);
   
end structural;