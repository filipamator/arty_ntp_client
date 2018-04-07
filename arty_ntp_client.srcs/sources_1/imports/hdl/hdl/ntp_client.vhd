 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : ntp_client.vhd
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

ENTITY ntp_client IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    ntp_d_i       : in std_logic_vector(7 downto 0);
    ntp_dv_i      : in std_logic;
    new_value_v     : out std_logic;
    new_value       : out std_logic_vector(63 downto 0)
);
END ENTITY ntp_client;

ARCHITECTURE rtl OF ntp_client IS

type t_ST is (ST_IDLE, ST_READ,ST_CLOCK,ST_FLUSH);
signal ST : t_ST := ST_IDLE;
signal byte_counter : integer range 0 to 2047;

BEGIN

decode_packet : process(clock_i,reset_n)

    variable ntp_header : std_logic_vector(31 downto 0);
    variable root_delay : std_logic_vector(31 downto 0);
    variable root_disp  : std_logic_vector(31 downto 0);
    variable ref_id     : std_logic_vector(31 downto 0);
    variable ref_tmstp  : std_logic_vector(63 downto 0);
    variable ori_tmstp  : std_logic_vector(63 downto 0);
    variable rec_tmstp  : std_logic_vector(63 downto 0);
    variable tns_tmstp  : std_logic_vector(63 downto 0);
    



begin
    if (reset_n='0') then
        ST <= ST_IDLE;
        byte_counter <= 0;
        new_value_v <= '0';
        new_value <= (others => '0');
    elsif (clock_i='1' and clock_i'event) then
        case (ST) is 
            
            when ST_IDLE =>        

                new_value_v <= '0';
                if (ntp_dv_i='1') then
                    ntp_header(31 downto 24) := ntp_d_i;
                    byte_counter <= 1;
                    ST <= ST_READ;
                end if;    
            
            when ST_READ =>                 
                
                if (ntp_dv_i='0') then
                    ST <= ST_IDLE;
                else

                    if (byte_counter=1) then
                        ntp_header(23 downto 16) := ntp_d_i;                       
                    elsif (byte_counter=2) then
                        ntp_header(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=3) then
                        ntp_header(7 downto 0) := ntp_d_i;
                    elsif (byte_counter=4) then
                        root_delay(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=5) then
                        root_delay(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=6) then
                        root_delay(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=7) then
                        root_delay(7 downto 0) := ntp_d_i;
                    elsif (byte_counter=8) then
                        root_disp(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=9) then
                        root_disp(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=10) then
                        root_disp(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=11) then
                        root_disp(7 downto 0) := ntp_d_i;
                    elsif (byte_counter=12) then
                        ref_id(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=13) then
                        ref_id(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=14) then
                        ref_id(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=15) then
                        ref_id(7 downto 0) := ntp_d_i;
                    

                    elsif (byte_counter=16) then
                        ref_tmstp(63 downto 56) := ntp_d_i;
                    elsif (byte_counter=17) then
                        ref_tmstp(55 downto 48) := ntp_d_i;
                    elsif (byte_counter=18) then
                        ref_tmstp(47 downto 40) := ntp_d_i;
                    elsif (byte_counter=19) then
                        ref_tmstp(39 downto 32) := ntp_d_i;
                    elsif (byte_counter=20) then
                        ref_tmstp(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=21) then
                        ref_tmstp(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=22) then
                        ref_tmstp(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=23) then
                        ref_tmstp(7 downto 0) := ntp_d_i;



                    
                    elsif (byte_counter=24) then
                        ori_tmstp(63 downto 56) := ntp_d_i;
                    elsif (byte_counter=25) then
                        ori_tmstp(55 downto 48) := ntp_d_i;
                    elsif (byte_counter=26) then
                        ori_tmstp(47 downto 40) := ntp_d_i;
                    elsif (byte_counter=27) then
                        ori_tmstp(39 downto 32) := ntp_d_i;
                    elsif (byte_counter=28) then
                        ori_tmstp(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=29) then
                        ori_tmstp(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=30) then
                        ori_tmstp(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=31) then
                        ori_tmstp(7 downto 0) := ntp_d_i;                  
                    
                    
                    elsif (byte_counter=32) then
                        rec_tmstp(63 downto 56) := ntp_d_i;
                    elsif (byte_counter=33) then
                        rec_tmstp(55 downto 48) := ntp_d_i;
                    elsif (byte_counter=34) then
                        rec_tmstp(47 downto 40) := ntp_d_i;
                    elsif (byte_counter=35) then
                        rec_tmstp(39 downto 32) := ntp_d_i;
                    elsif (byte_counter=36) then
                        rec_tmstp(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=37) then
                        rec_tmstp(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=38) then
                        rec_tmstp(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=39) then
                        rec_tmstp(7 downto 0) := ntp_d_i;                    
                    
                    
                    elsif (byte_counter=40) then
                        tns_tmstp(63 downto 56) := ntp_d_i;
                    elsif (byte_counter=41) then
                        tns_tmstp(55 downto 48) := ntp_d_i;
                    elsif (byte_counter=42) then
                        tns_tmstp(47 downto 40) := ntp_d_i;
                    elsif (byte_counter=43) then
                        tns_tmstp(39 downto 32) := ntp_d_i;
                    elsif (byte_counter=44) then
                        tns_tmstp(31 downto 24) := ntp_d_i;
                    elsif (byte_counter=45) then
                        tns_tmstp(23 downto 16) := ntp_d_i;
                    elsif (byte_counter=46) then
                        tns_tmstp(15 downto 8) := ntp_d_i;
                    elsif (byte_counter=47) then
                        tns_tmstp(7 downto 0) := ntp_d_i;

                        if (ntp_header(26 downto 24) = "100") then      -- server mode
                            ST <= ST_CLOCK;
                        end if;

                    end if;                    

                    byte_counter <= byte_counter + 1;
                end if;

            when ST_CLOCK =>

                new_value_v <= '1';
                new_value <= tns_tmstp;
                ST <= ST_IDLE;

            when ST_FLUSH =>                             -- flush the fifo
                if (ntp_dv_i='0') then
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
