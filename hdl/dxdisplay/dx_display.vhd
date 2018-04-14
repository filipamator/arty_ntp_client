----------------------------------------------------------------------------------
-- Engineer: Mike Field   <hamster@snap.net.nz>
-- 
-- Description:  Driver for the DealExteme display board, 
--  8 x 7 segs
--  8 x bi-colour LED
--  8 x buttons
--
-- Dependencies: None
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 0.02 - Mods by FMO
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dx_display is
    Port (  clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            byte     : out STD_LOGIC_VECTOR(7 downto 0);
            endCmd  : out STD_LOGIC;
            newData : out STD_LOGIC;
            adv     : in  STD_LOGIC;

            refresh : in STD_LOGIC;
           
            dig7 : in std_logic_vector(7 downto 0);
            dig6 : in std_logic_vector(7 downto 0);
            dig5 : in std_logic_vector(7 downto 0);
            dig4 : in std_logic_vector(7 downto 0);
            dig3 : in std_logic_vector(7 downto 0);
            dig2 : in std_logic_vector(7 downto 0);
            dig1 : in std_logic_vector(7 downto 0);
            dig0 : in std_logic_vector(7 downto 0);
            indicator0 : in std_logic_vector(1 downto 0);
            indicator1 : in std_logic_vector(1 downto 0);
            indicator2 : in std_logic_vector(1 downto 0);
            indicator3 : in std_logic_vector(1 downto 0);
            indicator4 : in std_logic_vector(1 downto 0);
            indicator5 : in std_logic_vector(1 downto 0);
            indicator6 : in std_logic_vector(1 downto 0);
            indicator7 : in std_logic_vector(1 downto 0)
           );
end dx_display;

architecture Behavioral of dx_display is
    signal counter : std_logic_vector(4 downto 0) := (others => '0');
    signal nextcounter : unsigned(4 downto 0);

    signal seg7 : std_logic_vector(7 downto 0);
    signal seg6 : std_logic_vector(7 downto 0);
    signal seg5 : std_logic_vector(7 downto 0);
    signal seg4 : std_logic_vector(7 downto 0);
    signal seg3 : std_logic_vector(7 downto 0);
    signal seg2 : std_logic_vector(7 downto 0);
    signal seg1 : std_logic_vector(7 downto 0);
    signal seg0 : std_logic_vector(7 downto 0);

    signal s_newData : std_logic;

begin

newData <= s_newData;

with dig7 select seg7 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig6 select seg6 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig5 select seg5 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig4 select seg4 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig3 select seg3 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig2 select seg2 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig1 select seg1 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;
with dig0 select seg0 <= x"06" when x"01", x"5b" when x"02",x"4f" when x"03",x"66" when x"04",x"6d" when x"05",
                         x"7c" when x"06",x"07" when x"07",x"7f" when x"08",x"67" when x"09",x"3f" when x"00",
                         x"00" when others;




   nextcounter <= unsigned(counter) + 1;
   
data_proc: process(counter)
   begin
      case counter is
         when  "00000" => byte <= x"40"; endCmd <= '1'; s_newData <= '1';	-- Set address mode - auto inc          (‭0100_0000‬)
         when  "00001" => byte <= x"8C"; endCmd <= '1'; s_newData <= '1';	-- Turn display on, brightness 4 of 7   (‭1000_1100‬)
         when  "00010" => byte <= x"C0"; endCmd <= '0'; s_newData <= '1';	-- Write at the left display            (‭1100_0000‬)
			
         when  "00011" => byte <= seg7; endCmd <= '0'; s_newData <= '1'; -- 7seg1 - Top center Segment           (‭0000_0001‬)
         when  "00100" => byte <= "000000" & indicator7; endCmd <= '0'; s_newData <= '1'; -- LED1 red                             (x"01")
         when  "00101" => byte <= seg6; endCmd <= '0'; s_newData <= '1';	-- 7seg2 - Top right segment            (0000_0010)
         when  "00110" => byte <= "000000" & indicator6; endCmd <= '0'; s_newData <= '1';	-- LED2 green                           (x"02")
			
         when  "00111" => byte <= seg5; endCmd <= '0'; s_newData <= '1';	-- 7seg3 - Bottom right segment         (0000_0100)
         when  "01000" => byte <= "000000" & indicator5; endCmd <= '0'; s_newData <= '1';	-- LED3 red
         when  "01001" => byte <= seg4; endCmd <= '0'; s_newData <= '1';	-- 7seg4 - Bottom center segment        (0000_1000)
         when  "01010" => byte <= "000000" & indicator4; endCmd <= '0'; s_newData <= '1';	-- LED4 green
			
         when  "01011" => byte <= seg3; endCmd <= '0'; s_newData <= '1'; -- 7seg5 - Bottom left segment          (0001_000)
         when  "01100" => byte <= "000000" & indicator3; endCmd <= '0'; s_newData <= '1'; -- LED5 red
         when  "01101" => byte <= seg2; endCmd <= '0'; s_newData <= '1';	-- 7seg6 - Top left segment             (0010_0000)
         when  "01110" => byte <= "000000" & indicator2; endCmd <= '0'; s_newData <= '1';	-- LED6 green
			
         when  "01111" => byte <= seg1; endCmd <= '0'; s_newData <= '1';	-- 7seg7 - Center segment               (0100_0000)
         when  "10000" => byte <= "000000" & indicator1; endCmd <= '0'; s_newData <= '1';	-- LED7 red
         when  "10001" => byte <= seg0; endCmd <= '0'; s_newData <= '1';	-- 7seg8 - Dot                         (1000_0000)
         when  "10010" => byte <= "000000" & indicator0; endCmd <= '1'; s_newData <= '1';	-- LED8 green
			
         when  others => byte <= x"FF"; endCmd <= '1'; s_newData <= '0';  -- End of data / idle
      end case;
   end process;
   
clk_proc: process(clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then 
            counter <= (others => '0');
         elsif adv = '1' and counter /= "11111" then
            counter <= std_logic_vector(nextcounter);
         elsif ((refresh='1') and (s_newData='0')) then
            counter <= (others => '0');
         end if;
      end if;
   end process;
end Behavioral;