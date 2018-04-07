 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : ipv4_decoder.vhd
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
--use work.genram_pkg.all;

-- SVN TEST

ENTITY ipv4_decoder IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    
    -- input stream of ipv4 packet
    ipv4_d_i     : in std_logic_vector(7 downto 0);
    ipv4_dv_i    : in std_logic;
    -- local address
    local_ip_i    : in std_logic_vector(31 downto 0);

    -- output stream of ntp packet
    ntp_d_o       : out std_logic_vector(7 downto 0);
    ntp_dv_o      : out std_logic
);
END ENTITY ipv4_decoder;

ARCHITECTURE rtl OF ipv4_decoder IS


signal byte_counter : integer range 0 to 2047;

type t_ST is (ST_IDLE, ST_READ,ST_FLUSH);
signal ST : t_ST := ST_IDLE;


BEGIN

decode_packet : process(clock_i,reset_n)

    variable src_ip : std_logic_vector(31 downto 0);
    variable dst_ip : std_logic_vector(31 downto 0);
    variable src_port : std_logic_vector(15 downto 0);
    variable dst_port : std_logic_vector(15 downto 0);
    
    variable ntp : std_logic;
    

begin
    if (reset_n='0') then
        ST <= ST_IDLE;
        byte_counter <= 0;
        ntp := '0';
        ntp_dv_o <= '0';
        ntp_d_o <= (others => '0');

    elsif (clock_i='1' and clock_i'event) then
        case (ST) is 
            
            when ST_IDLE =>                 
                
                ntp_dv_o <= '0';
                ntp := '0';
                if (ipv4_dv_i='1') then
                    if (ipv4_d_i/=x"45") then       -- we can handle only IPv4 and five 32bit words in the header
                        ST <= ST_FLUSH;
                    else
                        ST <= ST_READ;
                        byte_counter <= 1;
                    end if;
                end if;    
            
            when ST_READ =>                 
                
                if (ipv4_dv_i='0') then
                    ntp_dv_o <= '0';
                    ST <= ST_IDLE;
                else

                    if (byte_counter=12) then
                        src_ip(31 downto 24) :=  ipv4_d_i;
                    elsif (byte_counter=13) then
                        src_ip(23 downto 16) :=  ipv4_d_i;
                    elsif (byte_counter=14) then
                        src_ip(15 downto 8) :=  ipv4_d_i;
                    elsif (byte_counter=15) then
                        src_ip(7 downto 0) :=  ipv4_d_i;                        
                    elsif (byte_counter=16) then
                        dst_ip(31 downto 24) := ipv4_d_i;
                    elsif (byte_counter=17) then
                        dst_ip(23 downto 16) := ipv4_d_i;
                    elsif (byte_counter=18) then
                        dst_ip(15 downto 8) := ipv4_d_i;
                    elsif (byte_counter=19) then
                        dst_ip(7 downto 0) := ipv4_d_i;

                        if (dst_ip /= local_ip_i) then
                            ST <= ST_FLUSH;
                        end if;


                    elsif (byte_counter=20) then
                        src_port(15 downto 8) := ipv4_d_i;
                    elsif (byte_counter=21) then
                        src_port(7 downto 0) := ipv4_d_i;
                    elsif (byte_counter=22) then
                        dst_port(15 downto 8) := ipv4_d_i;
                    elsif (byte_counter=23) then
                        dst_port(7 downto 0) := ipv4_d_i;
                    elsif (byte_counter=24) then
                        -- lenght in bytes
                    elsif (byte_counter=25) then
                        -- lenght in bytes
                    elsif (byte_counter=26) then
                        -- checksum
                    elsif (byte_counter=27) then
                        -- checksum
                    elsif (byte_counter=28) then
                        if (src_port=x"007b") then
                            ntp_d_o <= ipv4_d_i;
                            ntp_dv_o <= '1';
                            ntp := '1';
                        end if;
                    else
                        if (ntp='1') then
                            ntp_d_o <= ipv4_d_i; 
                        end if;
                    end if;
                    


                    byte_counter <= byte_counter + 1;
                end if;
            
            when ST_FLUSH =>                             -- flush the fifo
                if (ipv4_dv_i='0') then
                    ST <= ST_IDLE;
                else 
                    ST <= ST_FLUSH;
                end if;

        end case;
    end if;
end process;

---------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------

END ARCHITECTURE rtl;
