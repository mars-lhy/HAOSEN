------------------------------------------------------------------------
-- epp_controller.vhd
------------------------------------------------------------------------
-- Author : Ulrich Zoltán
--          Copyright 2006 Digilent, Inc.
------------------------------------------------------------------------
-- Software version : Xilinx ISE 7.1.04i
--                    WebPack
-- Device	        : 3s200ft256-4
------------------------------------------------------------------------
-- This file contains the design for an EPP interface controller.
-- This configuration, in conjunction with a communication module,
-- (Digilent USB, Serial, Network, Parallel module or onboard usb
-- controller) allows the interfacing of the project with a PC
-- application program.
------------------------------------------------------------------------
--  Behavioral description
------------------------------------------------------------------------
-- All the Digilent communication modules above emulate an EPP interface
-- at the FPGA board connector pins, compatible to epp_controller.
--
-- For a description of the enhanced parallel port interface please
-- read the article on the following web page:
-- http://www.beyondlogic.org/epp/epp.htm
--
-- The controller performs the following functions:
--    - manages the EPP standard handshake
--    - implements the standard EPP Address Register
--    - provides the signals needed to write EPP Data Registers.
--    - provides the signals needed to make request to the host through
--      the polling mechanism. To host periodically poles the controller
--      for new requests provided by clients to this controller.
-- When performing an address write cycle, the sent address is stored
-- in the epp_adr register and is output on epp_adr_out port.
-- Address read cycle is not implemented, epp_bus is put in high-Z state
-- when such a cycle occurs.
-- When performing a data write cycle, received data (8 bits) is output
-- on epp_data_out and write_out is set active for one clock period.
-- When performing a data read cycle, the content of current_request
-- register is put on epp_bus. If no request has been set by another
-- module 0 will be output on the bus, meaning no request (NOP). If a 
-- request has been set, after reading the request byte, current_request
-- register will be clear in the next occurence of state sIdle, thus
-- containing the NOP request.
-- For implementing the epp interface a finite state machine is used.
-- It has 9 possible state, hand coded (each of 4 bits) with gray-like
-- values. Not all transitions follow the gray coding rule (only 1 bit
-- changes) due to the length of a cycle (odd number of states in a
-- cycle cannot be gray encoded). Transitions that break this rule
-- occur rarely or not at all, like sClearRequest -> sDone and
-- sReadAdr -> sDone. Although a read address cycle never occurs (using
-- provided software) it has implemented for protocol completion.
--
-- FSM states:
-- -> sIdle - wait for a new cycle to begin (when dstb or astb goes low)
--          - if astb goes low - transition to sAdrCycle
--          - if dstb goes low - transition to sDataCycle
--          - in case previous epp cycle has a read data cycle,
--          - when arriving in this state, current_request register
--          - is cleared.
-- -> sAdrCycle - this is an address cycle
--          - check epp_write to determine read or write cycle.
--          - if epp_write is low  - transition to sWriteAdr
--          - if epp_write is high - transition to sReadAdr
-- -> sDataCycle - this is a data cycle
--          - check epp_write to determine read or write cycle.
--          - if epp_write is low  - transition to sWriteAdr
--          - if epp_write is high - transition to sReadAdr
-- -> sWriteAdr - the address on epp_bus is read into epp_adr
--          - transition to sDone.
-- -> sReadAdr - epp_bus remains in high-impedance, since this
--          - epp cycle is not implemented. Should never reach state.
--          - transition to sDone.
-- -> sWriteData - data on epp_bus is output on epp_data_out and
--          - write_out goes high. Transition to sDone.
--          - Delaying cycle for the client to be able to write the data
--          - is not necessary for this design because client stores
--          - data in registers, which are loaded in one clock period.
--          - The controller can pe adapted for slower clients by
--          - providing an input pin (ex: hold_in) which should be
--          - checked in this state and the finite state machine should
--          - remain in sWriteData while this input signal is active.
-- -> sReadData - data from current_request is output on epp_bus.
--          - Transition to sClearRequest.
--          - As in sWriteData, delaying is not necessary because data
--          - is provided from local register.
--          - The controller can be adapted for the case when the data
--          - has a different, slower, source, by implementing an input
--          - pin (ex: hold_in), as explained above at sWriteData.
-- -> sClearRequest - flip flop clear_request is set to '1'. Means
--          - request register will be cleared next time in sIdle.
--          - Transition to sDone.
-- -> sDone - last state of an epp cycle. epp_ack is asserted and the
--          - finite state machine remains in this state until both
--          - astb and dstb are deasserted (go high) thus completing
--          - the handshake. Next follows a transition to sIdle.
------------------------------------------------------------------------
--  Port definitions
------------------------------------------------------------------------
-- clk         - global clock input with frequency of 100MHz
-- rst         - gloval reset input
------------------------
-- EPP INTERFACE PINS --
------------------------
-- epp_bus     - bidirectional pin
--             - the epp bus, of 8 bits width.
--             - placed in high-impedance(Z) when write cycles and
--             - carries the content of current_request register when
--             - when data read cycle.
-- epp_astb    - address strobe input pin
-- epp_dstb    - data strobe input pin
-- epp_write   - write input pin
--             - when '0' indicates write cycle
--             - when '1' indicates read cycle
-- epp_ack     - epp wait output pin
--             - when active indicates to host, cycle completion
---------------------------
-- CLIENT INTERFACE PINS --
---------------------------
-- epp_adr_out - output pin (8 bits)
--             - last written address (during an address write cycle)
-- epp_data_out - output pin (8 bits)
--             - data on the epp_bus during write cycles.
-- write_out   - output pin that indicates new data on epp_data_out.
-- request_value_in - input pin (8 bits)
--             - the byte to be send to host when read cycle occurs.
--             - this byte is temporarly stored in current_request
--             - register, which is cleared after the host has read it.
-- new_request_in - input pin, should be active for one clock period.
--             - when active indicates new request byte available on
--             - request_value_in.
------------------------------------------------------------------------
-- Revision History:
-- 09/18/2006(UlrichZ): created
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- simulation library
library UNISIM;
use UNISIM.VComponents.all;

-- the epp_controller entity declaration
-- read above for behavioral description and port definitions.
entity epp_controller is
port(
   clk               : in std_logic;
   rst               : in std_logic;

   epp_bus           : inout std_logic_vector(7 downto 0);
   epp_astb          : in std_logic;
   epp_dstb          : in std_logic;
   epp_write         : in std_logic;
   epp_ack           : out std_logic;

   epp_adr_out       : out std_logic_vector(7 downto 0);
   epp_data_out      : out std_logic_vector(7 downto 0);
   write_out         : out std_logic;

   request_value_in  : in std_logic_vector(2 downto 0);
   new_request_in    : in std_logic
);
end epp_controller;

architecture Behavioral of epp_controller is

------------------------------------------------------------------------
-- CONSTANTS DECLARATION
------------------------------------------------------------------------

-- declaration of the states for the FSM.
constant sIdle          : std_logic_vector(3 downto 0) := "0000";
constant sDataCycle     : std_logic_vector(3 downto 0) := "0010";
constant sAdrCycle      : std_logic_vector(3 downto 0) := "0001";
constant sReadData      : std_logic_vector(3 downto 0) := "0110";
constant sWriteData     : std_logic_vector(3 downto 0) := "1010";
constant sReadAdr       : std_logic_vector(3 downto 0) := "0011";
constant sWriteAdr      : std_logic_vector(3 downto 0) := "1001";
constant sClearRequest  : std_logic_vector(3 downto 0) := "1110";
constant sDone          : std_logic_vector(3 downto 0) := "1000";

------------------------------------------------------------------------
-- SIGNALS DECLARATION
------------------------------------------------------------------------

-- signal that holds current state of the FSM.
signal epp_state        : std_logic_vector(3 downto 0) := sIdle;
-- signal that holds the next state of the FSM.
signal epp_next_state   : std_logic_vector(3 downto 0) := sIdle;

-- The attribute lines below prevent the ISE compiler to extract and 
-- optimize the state machines.
-- WebPack 5.1 doesn't need them (the default value is NO)
-- WebPack 6.2 and above have the default value YES, so without these
-- lines, the synthesizer would "optimize" the state machines.
-- Although the overall circuit would be optimized, the particular goal 
-- of "glitch free output signals" may not be reached. 
-- That is the reason of implementing the state machine as described in  
-- the constant declarations above.
attribute fsm_extract : string;
attribute fsm_extract of epp_state: signal is "no";
attribute fsm_extract of epp_next_state: signal is "no";
attribute fsm_encoding : string;
attribute fsm_encoding of epp_state: signal is "user"; 
attribute fsm_encoding of epp_next_state: signal is "user";
attribute signal_encoding : string;
attribute signal_encoding of epp_state: signal is "user"; 
attribute signal_encoding of epp_next_state: signal is "user";

-- high when both astb and dstb are high
signal stb: std_logic := '0';
-- high when current cycle is a read cycle
-- used to control output on the epp_bus
signal read_cycle: std_logic := '0';
-- register that retains the last written address.
signal epp_adr: std_logic_vector(7 downto 0) := (others => '0');

-- the register that holds the current_request from another module
-- its contents are output on epp_bus during a read data cycle
-- in the next sIdle state, its content is cleared, 0 meaning a NOP.
-- request is only 3 bits, most significant 5 bits are 0 when placed
-- on epp_bus.
signal current_request: std_logic_vector(2 downto 0) := (others => '0');
-- flip flop set when in sClearRequest state indicating that the
-- current_request register should be cleared next time in sIdle.
signal clear_request: std_logic := '0';

begin

   ---------------------------------------------------------------------
   -- FLAGS, BUS AND REQUEST LOGIC
   ---------------------------------------------------------------------

   stb <= epp_astb and epp_dstb;
   
   -- assert epp_ack in sDone state to indicate to host data available
   -- or cycle completion.
   epp_ack <= '1' when epp_state = sDone else '0';
   
   -- place current_request on epp_bus when read data cycle,
   -- else put bus in high impendance
   epp_bus <= ("00000" & current_request) when read_cycle = '1' else
              (others => 'Z');

   epp_adr_out <= epp_adr;
   epp_data_out <= epp_bus;

   -- assert write_out in state sWriteData, meaning received new data
   -- from host.
   write_out <= '1' when epp_state = sWriteData else '0';

   -- set the clear_request flip flop when in state sClearRequest
   -- resets the clear_request flip flop when in state sIdle and
   -- set previously.
   do_clear_request: process(clk)
   begin
      if(rising_edge(clk)) then
         if(epp_state = sClearRequest) then
            clear_request <= '1';
         elsif(epp_state = sIdle and clear_request = '1') then
            clear_request <= '0';
         end if;
      end if;
   end process do_clear_request;

   -- clears the current_request register when in sIdle and
   -- clear_request flip flop is set or a reset occurs.
   do_request: process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            current_request <= (others => '0');
         elsif(new_request_in = '1') then
            current_request <= request_value_in;
         elsif(epp_state = sIdle and clear_request = '1') then
            current_request <= (others => '0');
         end if;
      end if;
   end process;

   -- sets the read_cycle ff if this is a read data cycle
   -- resets ff when in sIdle.
   do_read_cycle: process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            read_cycle <= '0';
         elsif(epp_state = sIdle) then
            read_cycle <= '0';
         elsif(epp_state = sDataCycle and epp_write = '1') then
            read_cycle <= '1';
         end if;
      end if;
   end process do_read_cycle; 

   -- reads epp_bus into epp_adr when in state sWriteAdr
   do_epp_adr: process(clk)
   begin
      if(rising_edge(clk)) then
         if(epp_state = sWriteAdr) then
            epp_adr <= epp_bus;
         end if;
      end if;           
   end process do_epp_adr;

   ---------------------------------------------------------------------
   -- EPP FSM LOGIC
   ---------------------------------------------------------------------

   -- this process advances the FSM by assinging epp_state
   -- the epp_next_state at every rising edge of the clock.
   -- when reset is active, the fsm is set in sIdle state.
   advance_epp_fsm: process(clk)
   begin
      if(rising_edge(clk)) then
         if(rst = '1') then
            epp_state <= sIdle;
         else
            epp_state <= epp_next_state;
         end if;
      end if;
   end process advance_epp_fsm;

   -- describes the transitions that are made from each state
   -- depending on the inputs.
   -- see Behavioral description above for explanations regarding
   -- each state.
   manage_epp_fsm: process(epp_state,epp_astb,epp_dstb,epp_write,stb)
   begin

      case epp_state is
         
         when sIdle =>
            if(epp_dstb = '0') then
               epp_next_state <= sDataCycle;
            elsif(epp_astb = '0') then
               epp_next_state <= sAdrCycle;
            else
               epp_next_state <= sIdle;
            end if;

         when sDataCycle =>
            -- test epp_write to determine read or write cycle
            if(epp_write = '0') then
               -- write cycle
               epp_next_state <= sWriteData;
            else
               -- read cycle
               epp_next_state <= sReadData;
            end if;

         when sAdrCycle =>
            -- test epp_write to determine read or write cycle
            if(epp_write = '0') then
               -- write cycle
               epp_next_state <= sWriteAdr;
            else
               -- read cycle
               epp_next_state <= sReadAdr;
            end if;

         -- in this state the data in current_request register
         -- is output on the epp bus.
         when sReadData =>
            epp_next_state <= sClearRequest;
   
         when sWriteData =>
            epp_next_state <= sDone;
      
         when sReadAdr =>
            epp_next_state <= sDone;

         when sWriteAdr =>
            epp_next_state <= sDone;

         -- set the clear_request ff
         when sClearRequest =>
            epp_next_state <= sDone;

         when sDone =>
            -- wait for both astb and dstb to be deasserted (go high)
            if(stb = '1') then
               epp_next_state <= sIdle;
            else
               epp_next_state <= sDone;
            end if;

         -- in case of transition to invalid states
         -- go back to sIdle
         when others =>
            epp_next_state <= sIdle;

      end case;
   end process manage_epp_fsm;

end Behavioral;