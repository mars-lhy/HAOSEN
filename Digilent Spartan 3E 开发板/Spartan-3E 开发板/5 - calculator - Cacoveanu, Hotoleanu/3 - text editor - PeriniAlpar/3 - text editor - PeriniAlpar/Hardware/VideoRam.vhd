
------------------------------------------------------------------------
--     VideoRAM.vhd -- Implements a dual-port single clock Block RAM
------------------------------------------------------------------------
-- Author:  Perini Alpar
--          Technical University of Cluj-Napoca, Computer Science
------------------------------------------------------------------------
--	 Inputs:
--			enA	: master enable of the block RAM
--			weA	: write enable for port A
--			addrA, addrB : address for port A and B
--			diA	: input data for port A
--  Outputs:
--			doA	: output data from port A
--			doB	: output data from port B
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity raminfr is
port (
			clk	: in std_logic;
			enA	: in std_logic;
			weA	: in std_logic;
			addrA, addrB : in std_logic_vector(11 downto 0);
			diA	: in std_logic_vector(8 downto 0);
			doA	: out std_logic_vector(8 downto 0);
			doB	: out std_logic_vector(8 downto 0)
		);
end entity raminfr;


architecture syn of raminfr is
type ram_type is array (2**12-1 downto 0) of 
												std_logic_vector (8 downto 0);
signal RAM : ram_type:=(
	 0 => "000000001", --blank
	 1 => "000001001", --A
	 2 => "000010001", --B
	 3 => "000011001", --C
	 4 => "000100001", --D
	 5 => "000101001", --E
	 6 => "000110001", --F
	 7 => "000111001", --G
	 8 => "001000001", --H
	 9 => "001001001", --I
	10 => "001010001", --J
	11 => "001011001", --K
	12 => "001100001", --L
	13 => "001101001", --M
	14 => "001110001", --N
	15 => "001111001", --O
	16 => "010000001", --P
	17 => "010001001", --R
	18 => "010010001", --S
	19 => "010011001", --T
	20 => "010100001", --U
	21 => "010101001", --V
	22 => "010110001", --W
	23 => "010111001", --X
	24 => "011000001", --Y
	25 => "011001001", --Z
	26 => "011010001", --0
	27 => "011011001", --1
	28 => "011100001", --2
	29 => "011101001", --3
	30 => "011110001", --4
	31 => "011111001", --5
	32 => "100000001", --6
	33 => "100001001", --7
	34 => "100010001", --8
	35 => "100011001", --9
	36 => "100100001", --space
	
	200 => "000000001", --blank
	201 => "000001001", --A
	202 => "000010001", --B
	203 => "000011001", --C
	204 => "000100001", --D
	205 => "000101001", --E
	206 => "000110001", --F
	207 => "000111001", --G
	208 => "001000001", --H
	209 => "001001001", --I
	210 => "001010001", --J
	211 => "001011001", --K
	212 => "001100001", --L
	213 => "001101001", --M
	214 => "001110001", --N
	215 => "001111001", --O
	216 => "010000001", --P
	217 => "010001001", --Q
	218 => "010010001", --R
	219 => "010011001", --S
	220 => "010100001", --T
	221 => "010101001", --U
	222 => "010110001", --V
	223 => "010111001", --W
	224 => "011000001", --X
	225 => "011001001", --Y
	226 => "011010001", --Z
	227 => "011011001", --0
	228 => "011100001", --1
	229 => "011101001", --2
	230 => "011110001", --3
	231 => "011111001", --4
	232 => "100000001", --5
	233 => "100001001", --6
	234 => "100010001", --7
	235 => "100011001", --8

	others => "000000010" -- default green color
	);

begin

	process (clk)
	begin
		if (clk'event and clk = '1') then
			if (enA = '1') then
				if (weA = '1') then
					RAM(conv_integer(addrA)) <= diA;
				end if;
				doA <= RAM(conv_integer(addrA));
				doB <= RAM(conv_integer(addrB));
			end if;
		end if;
	end process;

end syn;
