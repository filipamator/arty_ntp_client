----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Module Name:    dx_display_xmit - Behavioral 
-- Description:    Drive the serial bus for the display
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dx_display_xmit is
    Port ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           byte     : in  STD_LOGIC_VECTOR (7 downto 0);
           endCmd   : in  STD_LOGIC;
           newData  : in  STD_LOGIC;
           adv      : out STD_LOGIC;
           d_strobe : out STD_LOGIC;
           d_clk    : out STD_LOGIC;
           d_data   : out STD_LOGIC);
end dx_display_xmit;

architecture Behavioral of dx_display_xmit is
   signal thisEndCmd     : std_logic;
   signal thisByte       : std_logic_vector(7 downto 0)  := (others => '0');
   signal bitsLeftToSend : std_logic_vector(6 downto 0)  := (others => '0');
   signal state          : std_logic_vector(2 downto 0)  := (others => '0');
   signal divider        : std_logic_vector(63 downto 0) := x"1000000000000000";
begin
   
clk_proc: process(clk)
   begin
      if rising_edge(clk) then
         divider <= divider(0) & divider(63 downto 1);
         adv      <= '0';
         
         if reset = '1'  then
            thisByte   <= (others => '0');
            thisEndCmd <= endCmd;
            state      <= (others => '0');
            d_strobe <= '1';
            d_clk    <= '1';
            d_data   <= '1';
            divider  <= x"1000000000000000";
         elsif divider(0) = '1' then
            d_strobe <= '1';
            d_clk    <= '1';
            d_data   <= '1';
            case state is 
               when "000" =>      -- Idle, without an open command
                  if newData = '1' then
                     state    <= std_logic_vector(unsigned(state)+1);
                     thisByte <= byte;
                     thisEndCmd <= endCmd;
                     adv       <= '1';

                     d_strobe <= '0';
                     d_clk    <= '1';
                     d_data   <= '1';
                  else
                     d_strobe <= '1';
                     d_clk    <= '1';
                     d_data   <= '1';
                  end if;
                  bitsLeftToSend <= (others => '1');
                  
               when "001" =>   -- transfer a bot
                  state    <= std_logic_vector(unsigned(state)+1);
                  d_strobe <= '0';
                  d_clk    <= '0';
                  d_data   <= thisByte(0);
               when "010" =>
                  if bitsLeftToSend(0) = '1' then -- Still got a bit to send?
                     state    <= std_logic_vector(unsigned(state)-1);
                  elsif thisEndCmd = '1' then
                     state    <= "011";   -- close off command
                  else
                     state    <= "100";   -- keep command open
                  end if;
                  d_strobe <= '0';
                  d_clk    <= '1';
                  d_data   <= thisByte(0);
                  thisByte <= '1' & thisByte(7 downto 1);
                  bitsLeftToSend <= '0' & bitsLeftToSend(6 downto 1);
                  
               when "011" => --- ending the command by rasing d_strobe, the going back to idle state
                  state    <= "000";
                  d_strobe <= '1';
                  d_clk    <= '1';
                  d_data   <= thisByte(0);
                  
               when "100" =>      -- Waiting for data, withan open command
                  d_strobe <= '0';
                  d_clk    <= '1';
                  d_data   <= '1';
                  if newData = '1' then
                     state      <= "001"; -- start transfering bits
                     thisByte   <= byte;
                     thisEndCmd <= endCmd;
                     adv       <= '1';
                     bitsLeftToSend <= (others => '1');
                  end if;
               
               when others =>      -- performa a reset
                  thisByte <= (others => '0');
                  state    <= (others => '0');
                  d_strobe <= '1';
                  d_clk    <= '1';
                  d_data   <= '1';
            end case;
         end if;
      end if;
   end process;
end Behavioral;