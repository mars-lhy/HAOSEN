------------------------------------------------------------------------
--	NoteMemory.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module outputs the periods of the four notes, according to the
--	addresses received from the "NoteSelector".
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity NoteMemory is
	port (
		noteAddress0	: in STD_LOGIC_VECTOR(4 downto 0); -- The noteAddress of the first note
		noteAddress1	: in STD_LOGIC_VECTOR(4 downto 0); -- The noteAddress of the second note
		noteAddress2	: in STD_LOGIC_VECTOR(4 downto 0); -- The noteAddress of the third note
		noteAddress3	: in STD_LOGIC_VECTOR(4 downto 0); -- The noteAddress of the fourth note
		notePeriod0		: out STD_LOGIC_VECTOR(10 downto 0); -- The period of the first note
		notePeriod1		: out STD_LOGIC_VECTOR(10 downto 0); -- The period of the second note
		notePeriod2		: out STD_LOGIC_VECTOR(10 downto 0); -- The period of the third note
		notePeriod3		: out STD_LOGIC_VECTOR(10 downto 0) -- The period of the fourth note
	);
end NoteMemory;

architecture Behavioral of NoteMemory is

	type noteMemoryROM is array(0 to 31) of STD_LOGIC_VECTOR(10 downto 0);
	constant notes: noteMemoryROM := (
		"10001011100", -- F3 (175 Hz)
		"10000011111", -- F#3 (185 Hz)
		"01111100100", -- G3 (196 Hz)
		"01110101011", -- G#3 (208 Hz)
		"01101110111", -- A3 (220 Hz)
		"01101000110", -- A#3 (233 Hz)
		"01100011101", -- B3 (245 Hz)
	
		"01011101001", -- C4 (262 Hz)
		"01011000001", -- C#4 (277 Hz)
		"01010011000", -- D4 (294 Hz)
		"01001110100", -- D#4 (311 Hz)
		"01001001111", -- E4 (330 Hz)
		"01000101111", -- F4 (349 Hz)
		"01000001111", -- F#4 (370 Hz)
		"00111110010", -- G4 (392 Hz)
		"00111010110", -- G#4 (415 Hz)
		"00110111011", -- A4 (440 Hz)
		"00110100011", -- A#4 (466 Hz)
		"00110001011", -- B4 (494 Hz)
		"00101110101", -- C5 (523 Hz)
		"00101100000", -- C#5 (554 Hz)
		"00101001100", -- D5 (587 Hz)
		"00100111010", -- D#5 (622 Hz)
		"00100101000", -- E5 (659 Hz)
		
		"00100010111", -- F5 (698 Hz)
		"00100000111", -- F#5 (740 Hz)
		"00011111001", -- G5 (784 Hz)
		"00011101011", -- G#5 (831 Hz)
		"00011011101", -- A5 (880 Hz)
		"00011010001", -- A#5 (932 Hz)
		"00011000101", -- B5 (988 Hz)
		"00000000000");

begin

	notePeriod0 <= notes(conv_integer(noteAddress0));
	notePeriod1 <= notes(conv_integer(noteAddress1));
	notePeriod2 <= notes(conv_integer(noteAddress2));
	notePeriod3 <= notes(conv_integer(noteAddress3));

end Behavioral;