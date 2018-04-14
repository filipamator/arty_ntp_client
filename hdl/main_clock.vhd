 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : main_clock.vhd
 -- Author : Filip Ozimek
 -- Created : 2018/04/07
 -- Last modified : 2018/04/07
 -------------------------------------------------------------------------------
 -- Description:
 --
 -- 
 -------------------------------------------------------------------------------
 -- Modification history:
 -- 2018/04/07 : created
 -------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;


ENTITY main_clock IS
generic (
    REQ_TIMER   : natural := 100_000_000;
    TIMEOUT     : natural := 50_000_000;
    GMT_OFFSET  : integer := 3600
);
PORT (
    clock_i         : in std_logic;
    reset_n         : in std_logic;
    send_ntp_o      : out std_logic;
    new_time_i      : in std_logic_vector(63 downto 0);
    new_time_dv_i   : in std_logic;
    update_time_i   : in std_logic;
    phy_ready_i     : in std_logic;
    send_arp_anno_o : out std_logic;
    hour_a          : out std_logic_vector(7 downto 0);
    hour_b          : out std_logic_vector(7 downto 0);
    minute_a        : out std_logic_vector(7 downto 0);
    minute_b        : out std_logic_vector(7 downto 0);
    second_a        : out std_logic_vector(7 downto 0);
    second_b        : out std_logic_vector(7 downto 0);
    indicator0      : out std_logic_vector(1 downto 0);
    indicator1      : out std_logic_vector(1 downto 0)       
);
END ENTITY main_clock;

ARCHITECTURE rtl OF main_clock IS

type t_ST is (ST_IDLE, ST_SENDREQ, ST_CLOCK, ST_TIMEOUT);
signal ST : t_ST := ST_IDLE;

signal timestamp : std_logic_vector(63 downto 0);

signal hour : std_logic_vector(7 downto 0);
signal minute : std_logic_vector(7 downto 0);
signal second : std_logic_vector(7 downto 0);
signal unix : std_logic_vector(31 downto 0);
constant delta : unsigned(7 downto 0) := to_unsigned(86,8);

constant offset_from_1stJan1900 : unsigned(32 downto 0) := "010000011101010100111111010000000"; 
signal offset : unsigned(32 downto 0) :=  unsigned ( signed(offset_from_1stJan1900) - to_signed(GMT_OFFSET,16) );

signal phy_ready : std_logic;

signal req_counter      : integer := 0;
signal timeout_counter  : integer := 0;

BEGIN



process(clock_i)
begin
    if(rising_edge(clock_i)) then
        for i in 0 to 2 loop 
            case i is 
                when 0 => 
                    unix <= std_logic_vector ( resize ( unsigned(timestamp(63 downto 32))-offset,32));
                when 1 => 
                    hour <= std_logic_vector ( resize (  (unsigned(unix) mod to_unsigned(86400,17))/to_unsigned(3600,12),8));
                    minute <= std_logic_vector ( resize (  (unsigned(unix) mod to_unsigned(3600,17))/to_unsigned(60,12),8));
                    second <= std_logic_vector ( resize (  (unsigned(unix) mod to_unsigned(60,8)) ,8));
                when 2 => 
                    hour_a <= std_logic_vector ( unsigned(hour)/to_unsigned(10,8) );
                    hour_b <= std_logic_vector (resize( unsigned(hour) - to_unsigned(10,8) * (unsigned(hour)/to_unsigned(10,8)),8) );
                    minute_a <= std_logic_vector ( unsigned(minute)/to_unsigned(10,8) );
                    minute_b <= std_logic_vector (resize( unsigned(minute) - to_unsigned(10,8) * (unsigned(minute)/to_unsigned(10,8)),8) );
                    second_a <= std_logic_vector ( unsigned(second)/to_unsigned(10,8) );
                    second_b <= std_logic_vector (resize( unsigned(second) - to_unsigned(10,8) * (unsigned(second)/to_unsigned(10,8)),8) );
                when others => null;
            end case;
        end loop; 
    end if; 
end process;


clock : process(clock_i,reset_n)

begin
    if (reset_n='0') then
        req_counter <= REQ_TIMER - 256;
        timeout_counter <= 0;
        send_ntp_o <= '0';
        indicator1 <= "00";
        indicator0 <= "00";
        send_arp_anno_o <= '0';
        ST <= ST_IDLE;
    elsif (clock_i='1' and clock_i'event) then

        phy_ready <= phy_ready_i;

        case (ST) is

            when ST_IDLE =>

                send_arp_anno_o <= '0';

                if (phy_ready ='1') then

                    if (req_counter=REQ_TIMER) then
                        req_counter <= 0;
                        send_ntp_o <= '1';
                        timeout_counter <= 0;
                        if (update_time_i='1') then
                            ST <= ST_SENDREQ;
                        end if;
                    else

                        if (req_counter > 25_000_000) then
                            indicator1 <= "00";
                        end if;

                        if (req_counter = 1023) then
                            send_arp_anno_o <= '1';
                        end if;

                        req_counter <= req_counter + 1;
                        ST <= ST_IDLE;
                    end if;

                end if;



            when ST_SENDREQ =>
                send_ntp_o <= '0';
                if (new_time_dv_i='1') then
                    ST <= ST_CLOCK;
                else 
                    -- increase timeout counter
                    if (timeout_counter=TIMEOUT) then
                        timeout_counter <= 0;
                        ST <= ST_TIMEOUT;
                    else
                        timeout_counter <= timeout_counter + 1;
                        ST <= ST_SENDREQ;
                    end if;
                end if;          

            when ST_TIMEOUT =>
                indicator0 <= "10";        -- set indicator 0 (red colour)
                indicator1 <= "00";         -- clear indicator 1
                ST <= ST_IDLE;
            when ST_CLOCK =>
                indicator0 <= "00";         -- clear indicator 0
                indicator1 <= "01";         -- set indicator 1 (green)                
                ST <= ST_IDLE;
            when others =>
                ST <= ST_IDLE;
        end case;

    end if;
end process;


process(clock_i,reset_n)
begin
    if (reset_n='0') then
        timestamp <= (others => '0');
    elsif (clock_i='1' and clock_i'event) then
        if (new_time_dv_i='1') then
            timestamp <= new_time_i;
        else 
            timestamp <= std_logic_vector(  unsigned(timestamp) + delta  );
        end if;
    end if;
end process;


---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

END ARCHITECTURE rtl;
