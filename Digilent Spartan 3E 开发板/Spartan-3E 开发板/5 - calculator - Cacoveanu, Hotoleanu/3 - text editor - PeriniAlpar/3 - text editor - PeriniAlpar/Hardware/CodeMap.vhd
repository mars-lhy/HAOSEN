
------------------------------------------------------------------------
-- CodeMap.vhd -- Converts the keyboard scan-code to ascii-like encoding
------------------------------------------------------------------------
-- Author:  Perini Alpar
--          Technical University of Cluj-Napoca, Computer Science
------------------------------------------------------------------------

--	Inputs:
--		keycode	: The scan-code of a key received from the keyboard
--	Outputs:
--		char_code: The encoding of the character belonging to the scancode
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity codeMap is
    Port ( keycode : in std_logic_vector(7 downto 0);
           char_code : out std_logic_vector(5 downto 0));
end codeMap;

architecture Behavioral of codeMap is

type code_array is array (0 to 255)
	of std_logic_vector(5 downto 0);

constant codes : code_array := 
 (
	28 => "000001",--A
	50 => "000010",--B
	33 => "000011",--C
	35 => "000100",--D
	36 => "000101",--E
	43 => "000110",--F
	52 => "000111",--G
	51 => "001000",--H
	67 => "001001",--I
	59 => "001010",--J
	66 => "001011",--K
	75 => "001100",--L
	58 => "001101",--M
	49 => "001110",--N
	68 => "001111",--O
	77 => "010000",--P
	21 => "010001",--Q
	45 => "010010",--R
	27 => "010011",--S
	44 => "010100",--T
	60 => "010101",--U
	42 => "010110",--V
	29 => "010111",--W
	34 => "011000",--X
	53 => "011001",--Y
	26 => "011010",--Z
	69 => "011011",--0
	22 => "011100",--1
	30 => "011101",--2
	38 => "011110",--3
	37 => "011111",--4
	46 => "100000",--5
	54 => "100001",--6
	61 => "100010",--7
	62 => "100011",--8
	70 => "100100",--9
	41 => "100101",--SPACE
	65 => "100110",--,
	73 => "100111",--.
	74 => "101000",--/
	76 => "101001",--;
	82 => "101010",--'
 	93 => "101011",--\
	84 => "101100",--[
	91 => "101101",--]
	78 => "101110",---
	85 => "101111",--=
	13 => "110000",--`
	102 => "000000",--empty for backspace
	
	others => "111111" --unknown
 );

begin

char_code <= codes(conv_integer(keycode));

end Behavioral;
