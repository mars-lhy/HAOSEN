-----------------------------------------------------------------------------
--FILENAME        : dataetry.vhd
--DESCRIPTION     : this component reads keyboard codes and fills a registry
--                  with the numbers and operations requested; it activates
--                  a flag when the numbers and operation codes are stored
--                  and the data is ready to be read
--AUTHOR          : Silviu Cacoveanu
--REVISION HISTORY: 30.09.2006 - created
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dataentry is
   port (
      clk, kd, kc, reset: in std_logic;
      nra10, nra9, nra8, nra7, nra6, nra5, nra4, nra3, nra2, nra1, nra0:
         out std_logic_vector(3 downto 0);
      nrb10, nrb9, nrb8, nrb7, nrb6, nrb5, nrb4, nrb3, nrb2, nrb1, nrb0:
         out std_logic_vector(3 downto 0);
      sgna, sgnb: out std_logic;
      optype: out std_logic_vector(1 downto 0);
      ready_flag: out std_logic
   );
end entity;

architecture dataentry_arh of dataentry is
-----------------------------------------------------------------------------
-- We use a kyboard, a keydecoder and a deregister component.
-----------------------------------------------------------------------------
   component keyboard is
   	port( CLK, KD, KC: in std_logic;
   			RDY: buffer std_logic;
   			scancode: out std_logic_vector (7 downto 0)
   		 );
   end component;
   component keycodedecoder is
      port (
         keycode: in std_logic_vector(7 downto 0);
         inflag: in std_logic;
         binarycode: out std_logic_vector(3 downto 0);
         outflag: out std_logic
      );
   end component;
   component deregister is
      port (
         datain: in std_logic_vector(3 downto 0);
         clk, reset: in std_logic;
         nra10, nra9, nra8, nra7, nra6, nra5, nra4, nra3, nra2, nra1, nra0:
            out std_logic_vector(3 downto 0);
         nrb10, nrb9, nrb8, nrb7, nrb6, nrb5, nrb4, nrb3, nrb2, nrb1, nrb0:
            out std_logic_vector(3 downto 0);
         sgna, sgnb: out std_logic;
         optype: out std_logic_vector(1 downto 0);
         ready_flag: out std_logic
      );
   end component;
-----------------------------------------------------------------------------
   signal keyread, keytransformed: std_logic;
   signal keycode: std_logic_vector(7 downto 0);
   signal binarycode: std_logic_vector(3 downto 0);
begin
   cmp0: keyboard port map (
      CLK => clk, KD => kd, KC => kc,
   	RDY => keyread,
   	scancode => keycode
   );
   cmp1: keycodedecoder port map (
      keycode => keycode,
      inflag => keyread,
      binarycode => binarycode,
      outflag => keytransformed
   );
   cmp2: deregister port map (
      datain => binarycode,
      clk => keytransformed, reset => reset,
      nra10 => nra10, nra9 => nra9, nra8 => nra8, nra7 => nra7,
      nra6  => nra6 , nra5 => nra5, nra4 => nra4, nra3 => nra3,
      nra2  => nra2 , nra1 => nra1, nra0 => nra0,
      nrb10 => nrb10, nrb9 => nrb9, nrb8 => nrb8, nrb7 => nrb7,
      nrb6  => nrb6 , nrb5 => nrb5, nrb4 => nrb4, nrb3 => nrb3,
      nrb2  => nrb2 , nrb1 => nrb1, nrb0 => nrb0,
      sgna => sgna, sgnb => sgnb,
      optype => optype,
      ready_flag => ready_flag
   );
end architecture;
