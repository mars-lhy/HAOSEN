--------------------------------------------------------------------------------
-- Company: 
-- Author: Fazakas Szabolcs
--
-- Create Date:    00:02:49 10/05/06
-- Design Name:    
-- Module Name:    video - Behavioral
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
------------------------------------------------------------------------
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
-- This component has 2 BlockRams which contains the text and the 
-- characters form.
--
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- mclk             Input      Main clock input 
-- frame(15:0)      Input      Address
-- laser            Output     Data output
--
------------------------------------------------------------------------
entity video is
 Port(    mclk    : in std_logic;
          frame   : in std_logic_vector(16 downto 0);

        laser           :out std_logic
        );
end video;

architecture Behavioral of video is
------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------

 signal form_addres  : std_logic_vector(13 downto 0);
 signal text_addres  : std_logic_vector(10 downto 0);
 signal text_dataout  : std_logic_vector(7 downto 0);
 signal parity: std_logic_vector(0 downto 0);
 signal pixel: std_logic_vector(0 downto 0);
 
------------------------------------------------------------------------
-- Module Implementation - 
------------------------------------------------------------------------

begin

    form_addres<=text_dataout & frame(5 downto 0);
    text_addres<=frame(16 downto 6);
    

    laser<=pixel(0);
  
 -- this BlockRAM contains the characters form 
  RAMB16_S1_inst1 : RAMB16_S1
   generic map (
      INIT => "0", --  Value of output RAM registers at startup
      SRVAL => "0", --  Ouput value upon SSR assertion
      WRITE_MODE => "WRITE_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
           --      03       0      02       0       01      0      00       0                  
INIT_00 => X"FF80808080808080FF0101010101010180808080808080FF0000000000000000",
           --      07       0      06       0       05      0      04       0    
INIT_01 => X"80808080808080800101010101010101FF0000000000000000000000000000FF",
           --      0B       0      0A       0       09      0      08       0 
INIT_02 => X"00000000000000000000000000000000000000000000000001010101010101FF",
           --      0F       0      0E       0       0D      0      0C       0 
INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      13       0      12       0       11      0      10       0 
INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      17       0      16       0       15      0      14       0
INIT_05 => X"0000000000000000003810101010301000344854444444380000000000000000",
           --      1B       0      1A       0       19      0      18       0
INIT_06 => X"007804043840403C007C40201008047C00000000000000000000000000000000",
           --      1F       0      1E       0       1D      0      1C       0
INIT_07 => X"0000000000000000003C20100804443800285454544444440044447C44444438",
           --      23       0      22       0       21      0      20       0
INIT_08 => X"0070484444444870004444281028444400384440404044380000000000000000",
           --      27       0      26       0       25      0      24       0
INIT_09 => X"0000000000000000003844040810083C0008087C48281808007C40407840407C",
           --      2B       0      2A       0       29      0      28       0
INIT_0A => X"004040407840407C001028444444444400000000000000000000000000000000",
           --      2F       0      2E       0       2D      0      2C       0
INIT_0B => X"0000000000000000003844040478407C0044485078444478001010101010107C",
           --      33       0      32       0       31      0      30       0
INIT_0C => X"004444447C44444400784444784444780000444C546444440000000000000000",
           --      37       0      36       0       35      0      34       0
INIT_0D => X"000000000000000000384444784020180010101028444444003844445C404438",
           --      3B       0      3A       0       39      0      38       0
INIT_0E => X"003028080808081C0044444444546C4400000000000000000000000000000000",
           --      3F       0      3E       0       3D      0      3C       0
INIT_0F => X"00000000000000000038444438444438002020201008047C0038444444444444",
           --      43       0      42       0       41      0      40       0                  
INIT_10 => X"0038101010101038004448506050484400000000000000000000000000000000",
           --      47       0      46       0       45      0      44       0
INIT_11 => X"0000000000000000003008043844443800384464544C44380038444444444438",
           --      4B       0      4A       0       49      0      48       0
INIT_12 => X"007C404040404040000000000000000000181800000000000000000000000000",
           --      4F       0      4E       0       4D      0      4C       0
INIT_13 => X"0000000000000000000000007C00000000404040784444780000000000000000",
           --      53       0      52       0       51      0      50       0
INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      57       0      56       0       55      0      54       0
INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      5B       0      5A       0       59      0      58       0
INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      5F       0      5E       0       5D      0      5C       0
INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      63       0      62       0       61      0      60       0
INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      67       0      66       0       65      0      64       0
INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      6B       0      6A       0       69      0      68       0
INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      6F       0      6E       0       6D      0      6C       0
INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      73       0      72       0       71      0      70       0
INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      77       0      76       0       75      0      74       0
INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      7B       0      7A       0       79      0      78       0
INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      7F       0      7E       0       7D      0      7C       0
INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      83       0      82       0       81      0      80       0                  
INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      87       0      86       0       85      0      84       0    
INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      8B       0      8A       0       89      0      88       0 
INIT_22 => X"00000000000000000000000000000000000000000000000001010101010101FF",
           --      8F       0      8E       0       8D      0      8C       0 
INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      93       0      92       0       91      0      90       0 
INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      97       0      96       0       95      0      94       0
INIT_25 => X"0000000000000000003810101010301000344854444444380000000000000000",
           --      9B       0      9A       0       99      0      98       0
INIT_26 => X"007804043840403C007C40201008047C00000000000000000000000000000000",
           --      9F       0      9E       0       9D      0      9C       0
INIT_27 => X"0000000000000000003C20100804443800285454544444440044447C44444438",
           --      A3       0      A2       0       A1      0      A0       0
INIT_28 => X"0070484444444870004444281028444400384440404044380000000000000000",
           --      A7       0      A6       0       A5      0      A4       0
INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      AB       0      AA       0       A9      0      A8       0
INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      AF       0      AE       0       AD      0      AC       0
INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      B3       0      B2       0       B1      0      B0       0
INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      B7       0      B6       0       B5      0      B4       0
INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      BB       0      BA       0       B9      0      B8       0
INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      BF       0      BE       0       BD      0      BC       0
INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      C3       0      C2       0       C1      0      C0       0                  
INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      C7       0      C6       0       C5      0      C4       0
INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      CB       0      CA       0       C9      0      C8       0
INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      CF       0      CE       0       CD      0      CC       0
INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      D3       0      D2       0       D1      0      D0       0
INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      D7       0      D6       0       D5      0      D4       0
INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      DB       0      DA       0       D9      0      D8       0
INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      DF       0      DE       0       DD      0      DC       0
INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      E3       0      E2       0       E1      0      E0       0
INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      E7       0      E6       0       E5      0      E4       0
INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      EB       0      EA       0       E9      0      E8       0
INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      EF       0      EE       0       ED      0      EC       0
INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      F3       0      F2       0       F1      0      F0       0
INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      F7       0      F6       0       F5      0      F4       0
INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      FB       0      FA       0       F9      0      F8       0
INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
           --      FF       0      FE       0       FD      0      FC       0
INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO => pixel,      -- 1-bit Data Output
      ADDR => form_addres,  -- 14-bit Address Input
      CLK => mclk,    -- Clock
      DI => "0",      -- 1-bit Data Input
      EN => '1',      -- RAM Enable Input
      SSR => '0',    -- Synchronous Set/Reset Input
      WE => '0'       -- Write Enable Input
   );  

-- this BlockRAM contains the text
RAMB16_S9_inst : RAMB16_S9
   generic map (
      INIT => X"000", --  Value of output RAM registers at startup
      SRVAL => X"000", --  Ouput value upon SSR assertion
      WRITE_MODE => "WRITE_FIRST", --  WRITE_FIRST, READ_FIRST or NO_CHANGE
      INIT_00 => X"442D4D002D241B1C4B000000003A4421492131432C31244B43344323491D1D1D",
      INIT_01 => X"00003A4421492131432C31244B43344323491D1D1D00000000002D442C21243B",
      INIT_02 => X"442D4D002D241B1C4B000000003A4421492131432C31244B43344323491D1D1D",
      INIT_03 => X"00003A4421492131432C31244B43344323491D1D1D00000000002D442C21243B",
      INIT_04 => X"442D4D002D241B1C4B000000003A4421492131432C31244B43344323491D1D1D",
      INIT_05 => X"00003A4421492131432C31244B43344323491D1D1D00000000002D442C21243B",
      INIT_06 => X"442D4D002D241B1C4B000000003A4421492131432C31244B43344323491D1D1D",
      INIT_07 => X"00003A4421492131432C31244B43344323491D1D1D00000000002D442C21243B",
      INIT_08 => X"442D4D002D241B1C4B000000003A4421492131432C31244B43344323491D1D1D",
      INIT_09 => X"00003A4421492131432C31244B43344323491D1D1D00000000002D442C21243B",
      INIT_0A => X"442D4D002D241B1C4B000000003A4421492131432C31244B43344323491D1D1D",
      INIT_0B => X"00003A4421492131432C31244B43344323491D1D1D00000000002D442C21243B",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
   port map (
      DO => text_dataout,      -- 8-bit Data Output
      DOP => parity,    -- 1-bit parity Output
      ADDR => text_addres,  -- 11-bit Address Input
      CLK => mclk,    -- Clock
      DI => "00000000",      -- 8-bit Data Input
      DIP => "0",    -- 1-bit parity Input
      EN => '1',      -- RAM Enable Input
      SSR => '0',    -- Synchronous Set/Reset Input
      WE => '0'       -- Write Enable Input
   );    
   


end Behavioral;
