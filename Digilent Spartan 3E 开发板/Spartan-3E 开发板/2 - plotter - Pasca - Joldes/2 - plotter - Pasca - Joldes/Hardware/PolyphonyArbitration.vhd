------------------------------------------------------------------------
--	PolyphonyArbitration.vhd
------------------------------------------------------------------------
--	Author:	Lucian Chetan
------------------------------------------------------------------------
--	Software version: Xilinx WebPack ISE 8.1i
------------------------------------------------------------------------
--	This module determines which key changed its status by applying a logical XOR
--	between consecutive values of "keyStatus" (the current and previous values are used).
--	Any change will appear as a '1' at the respective index in the resulting register.
--	If there is no difference at some indexes, the value will be '0'. The module
--	determines the index with the value '1' and tests the current state of the
--	key that triggered the event. It the status of the key is '1', that key has
--	been pressed. The design finds the first free slot and assigns the note to it.
--	If the status of the key is '0', that key has been released. The design determines
--	the slot that handled the note (if there is one) and frees it.
--	Each slot will have a value equal to the address of a note. This address is used
--	outside this module to read the period of the note (all periods are stored in a memory).
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PolyphonyArbitration is
	port (
		clk			: in STD_LOGIC; -- Master clock (50 MHz)
		rst			: in STD_LOGIC; -- Reset button (synchronous reset)
		keyStatus	: in STD_LOGIC_VECTOR(16 downto 0); -- The status of the 17 keys
		kbNote0		: out STD_LOGIC_VECTOR(4 downto 0); -- The address of the first slot note
		kbNote1		: out STD_LOGIC_VECTOR(4 downto 0); -- The address of the second slot note
		kbNote2		: out STD_LOGIC_VECTOR(4 downto 0); -- The address of the third slot note
		kbNote3		: out STD_LOGIC_VECTOR(4 downto 0); -- The address of the fourth slot note
		kbStatus		: out STD_LOGIC_VECTOR(3 downto 0) -- The status of the four slots
	);
end PolyphonyArbitration;

architecture Behavioral of PolyphonyArbitration is

	type slotContentMemory is array (0 to 3) of NATURAL range 0 to 31;
	signal slotContent: slotContentMemory := (31, 31, 31, 31); -- 4-word memory that stores the notes assigned to enabled slots. Disabled slots have a note value of 31.
	signal slotEventLocation: NATURAL range 0 to 4; -- The index of the slot that handles a key that will be released
	signal slotStatus_temp: STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- The status of the slots
	signal eventLocation: NATURAL range 0 to 31; -- The index in the "eventRegister" where there has been a change
	signal keyStatusDelayed1: STD_LOGIC_VECTOR(16 downto 0) := "00000000000000000"; -- Register used for determining the occurence of events
	signal keyStatusDelayed2: STD_LOGIC_VECTOR(16 downto 0) := "00000000000000000"; -- Register used for determining the occurence of events
	signal eventRegister: STD_LOGIC_VECTOR(16 downto 0) := "00000000000000000"; -- Register used for determining the occurence of events
	signal firstFreeSlot: NATURAL := 31; -- The index of the first free slot

begin

	-- This process creates the vector that will indicate a change in the status of the keyboard.
	-- The "eventRegister" is obtained from the 'exclusive OR (XOR)' between two different configurations of the keyboard.
	-- Example: old configuration:	1000
	--				new configuration:	1001
	--											----
	--				event						0001 (there has been a change on the rightmost bit)
	-- Due to the high frequency of operation of the entire design, only one bit changes
	-- from one configuration to another. The 'eventRegister' can have at most one '1' value.
	determine_event: process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				eventRegister <= (others => '0');						-- On reset, the register is cleared.
			else
				if (keyStatusDelayed1 /= keyStatus) then					-- If the keyboard status has changed (only one bit can chage)...
					keyStatusDelayed1 <= keyStatus;							-- store the new configuration of the keys
					eventRegister <= keyStatus xor keyStatusDelayed1;	-- and update the "eventRegister".
				end if;
			end if;
		end if;
	end process;


	-- This process delays by one clock tick the "keyStatusDelayed1" register. "keyStatusDelayed2" register
	-- is used in the remainig operations, allowing other signals needed to receive their correct values.
	delay_once: process (clk)
	begin
		if rising_edge(clk) then
			keyStatusDelayed2 <= keyStatusDelayed1;
		end if;
	end process;


	-- "eventRegister" can have only one '1' value, and "eventLocation" stores the index of that value.
	-- The value of the indexes will represent the note address. For the first key (Q), the note address is 7.
	-- For the last key (P), the note address is 23. Notes 0 - 6 and 24 - 30 are not available to the keyboard.
	eventLocation <=
		7 when eventRegister(0) = '1' else		-- Q
		8 when eventRegister(1) = '1' else		-- 2
		9 when eventRegister(2) = '1' else		-- W
		10 when eventRegister(3) = '1' else		-- 3
		11 when eventRegister(4) = '1' else		-- E
		12 when eventRegister(5) = '1' else		-- R
		13 when eventRegister(6) = '1' else		-- 5
		14 when eventRegister(7) = '1' else		-- T
		15 when eventRegister(8) = '1' else		-- 6
		16 when eventRegister(9) = '1' else		-- Y
		17 when eventRegister(10) = '1' else	-- 7
		18 when eventRegister(11) = '1' else	-- U
		19 when eventRegister(12) = '1' else	-- I
		20 when eventRegister(13) = '1' else	-- 9
		21 when eventRegister(14) = '1' else	-- O
		22 when eventRegister(15) = '1' else	-- 0
		23 when eventRegister(16) = '1' else	-- P
		31;												-- This value corresponds to "no events found".


	-- This process assigns the polyphony slots.
	assign_slots: process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				slotStatus_temp <= "0000"; -- On reset, the slot status is cleared.
				slotContent <= (0, 0, 0, 0);
			else
				if (keyStatusDelayed2 /= keyStatusDelayed1) then			-- If the keyboard configuration changed,
					if (eventLocation < 31) then
						if (keyStatus(eventLocation - 7) = '1') then			-- if the change means a new key pressed,
							if (firstFreeSlot < 4) then
								slotContent(firstFreeSlot) <= eventLocation;	-- the first free slot will be handling the new note.
								slotStatus_temp(firstFreeSlot) <= '1';			-- That slot is now busy.
							end if;
						else																-- if the change means a key released,
							if (slotEventLocation < 4) then						-- if a key that was handled by a slot has been released,
								slotContent(slotEventLocation) <= 31;			-- the slot that used to handle the pressed key is now freed
								slotStatus_temp(slotEventLocation) <= '0';	-- and marked as free
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;


	-- The first free slot is the first slot whose status is set to '0'.
	-- Example: The first free slot in the configuration "1001" is the one with the index 2.
	-- If the configuration is "1111", there are no free slots and the value of "firstFreeSlot" will be 4.
	firstFreeSlot <=
		0 when (slotStatus_temp(0) = '0') else
		1 when (slotStatus_temp(1) = '0') else
		2 when (slotStatus_temp(2) = '0') else
		3 when (slotStatus_temp(3) = '0') else
		4;


	-- "slotEventLocation" stores the slot value equal to the index of a configuration change.
	-- Example: The "eventLocation" is 15 and the slot configuration is (10, 12, 15, 21).
	-- "slotEventLocation" will be equal to 1. Its value is used only for released keys.
	-- It is possible to release a key that hasn't been handled by any slots. In this case,
	-- "slotEventLocation" will be equal to 4.
	slotEventLocation <=
		0 when (slotContent(0) = eventLocation) else
		1 when (slotContent(1) = eventLocation) else
		2 when (slotContent(2) = eventLocation) else
		3 when (slotContent(3) = eventLocation) else
		4;


	kbNote0 <= conv_std_logic_vector(slotContent(0), 5); -- "kbNote0" outputs the address of the first note.
	kbNote1 <= conv_std_logic_vector(slotContent(1), 5); -- "kbNote1" outputs the address of the second note.
	kbNote2 <= conv_std_logic_vector(slotContent(2), 5); -- "kbNote2" outputs the address of the third note.
	kbNote3 <= conv_std_logic_vector(slotContent(3), 5); -- "kbNote3" outputs the address of the fourth note.
	kbStatus <= slotStatus_temp; -- "kbStatus" outputs the status of the 4 polyphony slots. It enables/disables the 4 oscillators.

end Behavioral;