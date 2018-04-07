 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : axis_ntp.vhd
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ntp_pkg.all;


entity axis_ntp is
port (
        i_clock     : in std_logic;
        i_reset_n   : in std_logic;
        i_start     : in std_logic;

        i_dst_mac   : in std_logic_vector(47 downto 0);
        i_src_mac   : in std_logic_vector(47 downto 0);

        i_ip_src    : in std_logic_vector(31 downto 0);
        i_ip_dst    : in std_logic_vector(31 downto 0);

        req_o		: out std_logic;
	    grant_i		: in std_logic;
	    M_AXIS_TVALID_o	    : out std_logic;
	    M_AXIS_TDATA_o	    : out std_logic_vector(7 downto 0);
	    M_AXIS_TLAST_o	    : out std_logic;
	    M_AXIS_TREADY_i	    : in std_logic

);
end axis_ntp;

architecture rtl of axis_ntp is

signal packet       : t_packet;
type t_state is (ST_IDLE,ST_PKG,ST_IP4CHECKSUM,ST_UDPCHECKSUM,ST_STORE_CHKSM,ST_REQ,ST_RUN);
signal ST           : t_state  := ST_IDLE;
signal counter      : integer;
signal ipv4_sum     : unsigned(31 downto 0);
signal ipv4_checksum     : std_logic_vector(15 downto 0);
signal udp_sum     : unsigned(31 downto 0);
signal udp_checksum     : std_logic_vector(15 downto 0);


begin



main : process(i_clock,i_reset_n)
    variable temp : std_logic_vector(15 downto 0);
begin

    if (i_reset_n='0') then
        counter <= 0; 
        ipv4_sum <= (others => '0');
        udp_sum <= (others => '0');
        req_o <= '0';
        M_AXIS_TDATA_o <= (others => '0');
        M_AXIS_TLAST_o <= '0';
        M_AXIS_TVALID_o <= '0';
        ST <= ST_IDLE;
    elsif (i_clock='1' and i_clock'event) then 
        case (ST) is
            
            -----------------------------------------
            -- Wait for start                      --
            -----------------------------------------
            
            when ST_IDLE =>
                if (i_start='1') then 
                    counter <= 0;
                    ipv4_sum <= (others => '0');
                    udp_sum <= (others => '0');
                    ST <= ST_PKG;
                end if;
            
            -----------------------------------------
            -- Build a packet                      --
            -----------------------------------------


            when ST_PKG => 
    
                packet(0) <= i_dst_mac(47 downto 40);
                packet(1) <= i_dst_mac(39 downto 32);
                packet(2) <= i_dst_mac(31 downto 24);
                packet(3) <= i_dst_mac(23 downto 16);
                packet(4) <= i_dst_mac(15 downto 8);
                packet(5) <= i_dst_mac(7 downto 0);
                
                packet(6) <= i_src_mac(47 downto 40);
                packet(7) <= i_src_mac(39 downto 32);
                packet(8) <= i_src_mac(31 downto 24);
                packet(9) <= i_src_mac(23 downto 16);
                packet(10) <= i_src_mac(15 downto 8);
                packet(11) <= i_src_mac(7 downto 0);

                -- Ethertype - IPv4 datagram
                packet(12) <= x"08";
                packet(13) <= x"00";

                -- IPv4 header#

                packet(14) <= x"45";        -- Version and header length                    <= checksum
                packet(15) <= x"00";        -- DSCP and ECN                                 <= checksum
                packet(16) <= x"00";        -- total length, 76 bytes                       <= checksum
                packet(17) <= x"4c";        -- total length                                 <= checksum
                packet(18) <= x"c6";        -- identification                               <= checksum
                packet(19) <= x"5c";        -- identification                               <= checksum
                packet(20) <= x"40";        -- flags and fragment offset                    <= checksum
                packet(21) <= x"00";        -- flags and fragment offset                    <= checksum
                packet(22) <= x"40";        -- time to live                                 <= checksum
                packet(23) <= x"11";        -- protocol number - UDP                        <= checksum
                packet(24) <= x"00"; -- x"f2";   -- calculated header checksum
                packet(25) <= x"00"; -- x"8c";   -- calculated header checksum
                packet(26) <= i_ip_src(31 downto 24);       -- IP source address            <= checksum
                packet(27) <= i_ip_src(23 downto 16);       -- IP source address            <= checksum
                packet(28) <= i_ip_src(15 downto 8);        -- IP source address            <= checksum
                packet(29) <= i_ip_src(7 downto 0);         -- IP source address            <= checksum
                packet(30) <= i_ip_dst(31 downto 24);       -- IP dest. address             <= checksum
                packet(31) <= i_ip_dst(23 downto 16);       -- IP dest. address             <= checksum
                packet(32) <= i_ip_dst(15 downto 8);        -- IP dest. address             <= checksum
                packet(33) <= i_ip_dst(7 downto 0);         -- IP dest. address             <= checksum

                -- UDP header

                packet(34) <= x"c3";        -- source port
                packet(35) <= x"6c";        -- source port
                packet(36) <= x"00";        -- dest. port
                packet(37) <= x"7b";        -- dest. port
                packet(38) <= x"00";        -- length of UDP header and UDP data
                packet(39) <= x"38";        -- length of UDP header and UDP data
                packet(40) <= x"00";  -- x"19";        -- optional checksum
                packet(41) <= x"00";   --x"13";        -- optional checksum
            
                -- NTP packet

                packet(42) <= NTP_HEADER(31 downto 24);          -- header
                packet(43) <= NTP_HEADER(23 downto 16);          
                packet(44) <= NTP_HEADER(15 downto 8); 
                packet(45) <= NTP_HEADER(7 downto 0); 

                packet(46) <= x"00";          -- root delay
                packet(47) <= x"00"; 
                packet(48) <= x"00"; 
                packet(49) <= x"00"; 

                packet(50) <= x"00";          -- root dispersion
                packet(51) <= x"00"; 
                packet(52) <= x"00"; 
                packet(53) <= x"00"; 

                packet(54) <= x"00";          -- reference identifier
                packet(55) <= x"00"; 
                packet(56) <= x"00"; 
                packet(57) <= x"00"; 


                packet(58) <= x"00";          -- reference timestamp
                packet(59) <= x"00"; 
                packet(60) <= x"00"; 
                packet(61) <= x"00"; 
                packet(62) <= x"00";         
                packet(63) <= x"00"; 
                packet(64) <= x"00"; 
                packet(65) <= x"00"; 

                packet(66) <= x"00";          -- originate timestamp
                packet(67) <= x"00"; 
                packet(68) <= x"00"; 
                packet(69) <= x"00"; 
                packet(70) <= x"00";         
                packet(71) <= x"00"; 
                packet(72) <= x"00"; 
                packet(73) <= x"00"; 

                packet(74) <= x"00";          -- receive timestamp
                packet(75) <= x"00"; 
                packet(76) <= x"00"; 
                packet(77) <= x"00"; 
                packet(78) <= x"00";         
                packet(79) <= x"00"; 
                packet(80) <= x"00"; 
                packet(81) <= x"00"; 

                packet(82) <= x"de";          -- transmit timestamp
                packet(83) <= x"54"; 
                packet(84) <= x"29"; 
                packet(85) <= x"42"; 
--                packet(86) <= x"7F";         
--                packet(87) <= x"FF"; 
--                packet(88) <= x"FF"; 
 --               packet(89) <= x"FF"; 

                 packet(86) <= x"30";         
                 packet(87) <= x"62"; 
                 packet(88) <= x"4d"; 
                 packet(89) <= x"d2"; 

                ST <= ST_IP4CHECKSUM;

            -----------------------------------------
            -- Calculate IPv4 checksum from header --
            -----------------------------------------
            when ST_IP4CHECKSUM =>

                if (counter=10) then
                    ipv4_checksum <= not( std_logic_vector(ipv4_sum(15 downto 0) + ipv4_sum(19 downto 16)) ); 
                    counter <= 0;
                    ST <= ST_UDPCHECKSUM;
                else
                    temp := packet(14+2*counter) & packet(14+2*counter+1);
                    ipv4_sum <= unsigned(ipv4_sum) +  unsigned(temp);
                    counter <= counter + 1;
                end if;
            

            -----------------------------------------
            -- Calculate UDP checksum from         --
            -- pseudoheader and whole UDP packet   --
            -----------------------------------------

            when ST_UDPCHECKSUM =>

                if (counter=28) then
                    counter <= counter + 1;
                                                                                    -- pseudoheader
                    udp_sum <= udp_sum  + unsigned(i_ip_src(31 downto 16))          -- IP SRC
                                        + unsigned(i_ip_src(15 downto 0)) 
                                        + unsigned(i_ip_dst(31 downto 16))          -- IP DST
                                        + unsigned(i_ip_dst(15 downto 0)) 
                                        + to_unsigned(17, 16)                       -- Protocol type x"11"
                                        + to_unsigned(56, 16);                      -- length
                elsif (counter=29) then
                    udp_checksum <= not( std_logic_vector(udp_sum(15 downto 0) + udp_sum(19 downto 16)) ); 
                    counter <= 0;
                    ST <= ST_STORE_CHKSM;
                else
                    temp := packet(34+2*counter) & packet(34+2*counter+1);
                    udp_sum <= unsigned(udp_sum) +  unsigned(temp);
                    counter <= counter + 1;
                end if;

            -----------------------------------------
            -- Update packet with checksums        --
            -----------------------------------------

            when ST_STORE_CHKSM =>

                -- UDP
                packet(40) <= udp_checksum(15 downto 8);
                packet(41) <= udp_checksum(7 downto 0);

                -- IP
                packet(24) <= ipv4_checksum(15 downto 8);
                packet(25) <= ipv4_checksum(7 downto 0);

                req_o <= '1';
                counter <= 0;
                ST <= ST_REQ;


            -----------------------------------------
            -- Request bus access                  --
            -----------------------------------------

            when ST_REQ =>

				if (grant_i='1') then
					M_AXIS_TVALID_o <= '1';
                    M_AXIS_TDATA_o <= std_logic_vector(packet(counter));
					counter <= 1;
					ST <= ST_RUN;
				else 
					ST <= ST_REQ;
				end if;


            -----------------------------------------
            -- Send packet                         --
            -----------------------------------------



            when ST_RUN => 

				-- previous byte was send over bus
				if (M_AXIS_TREADY_i='1') then
					

					if (counter=90) then
						M_AXIS_TDATA_o <= (others => '0');
						M_AXIS_TLAST_o <= '0';
						counter <= 0;
						M_AXIS_TVALID_o <= '0';
						req_o <= '0';
						ST <= ST_IDLE;

					elsif (counter=89) then
                        M_AXIS_TLAST_o <= '1';
                        M_AXIS_TDATA_o <= std_logic_vector(packet(counter));
                        counter <= counter + 1;
                    else 
					    M_AXIS_TDATA_o <= std_logic_vector(packet(counter));
                        counter <= counter + 1;
                    end if;

				end if;




        end case; 
    end if;

end process;


end rtl;