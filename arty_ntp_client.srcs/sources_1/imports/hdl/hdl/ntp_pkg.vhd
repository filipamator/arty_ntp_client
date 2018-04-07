 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : ntp_pkg.vhd
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
use ieee.numeric_std.all;

package ntp_pkg is

    type t_packet is array (0 to 89) of std_logic_vector(7 downto 0);

    TYPE t_arr_byte IS ARRAY(natural RANGE <>) OF unsigned(7 DOWNTO 0);
    

    constant NTP_HEADER_LI      : std_logic_vector(1 downto 0) := "00";
    constant NTP_HEADER_VER     : std_logic_vector(2 downto 0) := "011";
    constant NTP_HEADER_MODE    : std_logic_vector(2 downto 0) := "011";    -- 3=client, 4=server
    constant NTP_HEADER_STRATUM : std_logic_vector(7 downto 0) := x"00";
    constant NTP_HEADER_POLLINT : std_logic_vector(7 downto 0) := x"00";
    constant NTP_HEADER_PREC    : std_logic_vector(7 downto 0) := x"00";

    constant NTP_HEADER         : std_logic_vector(31 downto 0) := NTP_HEADER_LI & NTP_HEADER_VER & NTP_HEADER_MODE & NTP_HEADER_STRATUM & NTP_HEADER_POLLINT & NTP_HEADER_PREC;

    procedure p_send_arp(
        signal clock        : in std_logic;
        constant dst_mac      : in std_logic_vector(47 downto 0);
        constant src_mac      : in std_logic_vector(47 downto 0);
        constant sender_mac   : in std_logic_vector(47 downto 0);
        constant target_mac   : in std_logic_vector(47 downto 0);        
        constant sender_ip    : in std_logic_vector(31 downto 0);
        constant target_ip    : in std_logic_vector(31 downto 0);
        constant opcode       : in std_logic_vector(15 downto 0);
        signal nibble       : out std_logic_vector(3 downto 0);
        signal nibble_dv    : out std_logic;
        signal eth_crc      : out std_logic_vector(31 downto 0)
    );


    procedure p_send_udp(
        signal clock        : in std_logic;
        signal nibble       : out std_logic_vector(3 downto 0);
        signal nibble_dv    : out std_logic;
        signal eth_crc      : out std_logic_vector(31 downto 0) 
    );

    procedure p_send_udp_packet(
        signal clock        : in std_logic;
        constant dst_mac    : in std_logic_vector(47 downto 0);
        constant src_mac    : in std_logic_vector(47 downto 0);    
        constant dst_ip     : in std_logic_vector(31 downto 0);
        constant src_ip     : in std_logic_vector(31 downto 0);
        constant dst_port   : in std_logic_vector(15 downto 0);
        constant src_port   : in std_logic_vector(15 downto 0); 
        constant id         : in std_logic_vector(15 downto 0);       
        constant payload      : t_arr_byte;
        signal nibble       : out std_logic_vector(3 downto 0);
        signal nibble_dv    : out std_logic;
        signal eth_crc      : out std_logic_vector(31 downto 0) 
    );



end;



package body ntp_pkg is



    --------------------------------------------------------------------------
    -- This procedure takes arguments like IP and MAC address and generates --
    -- a stream of nibbles with data valid signal                           --
    --------------------------------------------------------------------------
    
    procedure p_send_udp(
        signal clock        : in std_logic;
        signal nibble       : out std_logic_vector(3 downto 0);
        signal nibble_dv    : out std_logic;
        signal eth_crc      : out std_logic_vector(31 downto 0) 
    ) is
        variable temp : std_logic_vector(7 downto 0);
        TYPE arr_byte IS ARRAY(natural RANGE <>) OF unsigned(7 DOWNTO 0);
        variable udp_packet : arr_byte(0 to 89) := 
        (x"00",x"18",x"3e",x"02",x"38",x"db",x"90",x"21",x"06",x"1c",x"89",x"18",x"08",x"00",x"45",x"00",
         x"00",x"4c",x"31",x"24",x"00",x"00",x"7a",x"11",x"22",x"7c",x"55",x"c7",x"d6",x"62",x"c0",x"a8",
         x"00",x"2f",x"00",x"7b",x"fe",x"89",x"00",x"38",x"d6",x"89",x"24",x"01",x"04",x"e7",x"00",x"00",
        x"00",x"00",x"00",x"00",x"00",x"00",x"47",x"50",x"53",x"00",x"de",x"51",x"71",x"65",x"00",x"00",
        x"00",x"00",x"de",x"51",x"71",x"65",x"a8",x"f5",x"c1",x"cc",x"de",x"51",x"71",x"65",x"ab",x"a7",
        x"0c",x"31",x"de",x"51",x"71",x"65",x"ab",x"a7",x"6c",x"95");
    begin


        wait until rising_edge(clock);
        nibble_dv <= '1';
        for I in 0 to 89 loop
            temp := std_logic_vector(udp_packet(I));
            nibble <= temp(3 downto 0);
            wait until rising_edge(clock);
            nibble <= temp(7 downto 4);
            wait until rising_edge(clock);
        end loop; 
        nibble_dv <= '0';

    end procedure p_send_udp;

----------------------------------------------------------------

    procedure p_send_udp_packet(
        signal clock        : in std_logic;
        constant dst_mac    : in std_logic_vector(47 downto 0);
        constant src_mac    : in std_logic_vector(47 downto 0);    
        constant dst_ip     : in std_logic_vector(31 downto 0);
        constant src_ip     : in std_logic_vector(31 downto 0);
        constant dst_port   : in std_logic_vector(15 downto 0);
        constant src_port   : in std_logic_vector(15 downto 0); 
        constant id         : in std_logic_vector(15 downto 0);
        constant payload      : t_arr_byte;
        signal nibble       : out std_logic_vector(3 downto 0);
        signal nibble_dv    : out std_logic;
        signal eth_crc      : out std_logic_vector(31 downto 0) 
    ) is
        variable udp_packet : t_arr_byte(0 to payload'length-1+42);
        variable temp       : std_logic_vector(7 downto 0) := (OTHERS => '0');
        variable temp_sum   : unsigned(15 downto 0) := (OTHERS => '0');
        variable ipv4_sum      : unsigned(31 downto 0) := (OTHERS => '0');
        variable ipv4_checksum : std_logic_vector(15 downto 0);

        variable udp_sum      : unsigned(31 downto 0) := (OTHERS => '0');
        variable payload_sum      : unsigned(31 downto 0) := (OTHERS => '0');
        
        variable udp_checksum : std_logic_vector(15 downto 0);


    begin

        -- UDP packet size:
        -- dst and src mac:     12 
        -- ethertype:           2
        -- IPv4 header:         20
        -- UDP header:          8
        -- UDP payload:         xxx
        -- ethernet CRC32       0   (added later)
        ------------------------------------------
        -- TOTAL:               42


        -- https://notes.shichao.io/tcpv1/ch10/

        udp_packet(0) := unsigned(dst_mac(47 downto 40));
        udp_packet(1) := unsigned(dst_mac(39 downto 32));
        udp_packet(2) := unsigned(dst_mac(31 downto 24));
        udp_packet(3) := unsigned(dst_mac(23 downto 16));
        udp_packet(4) := unsigned(dst_mac(15 downto 8));
        udp_packet(5) := unsigned(dst_mac(7 downto 0));
        -- source MAC
        udp_packet(6) := unsigned(src_mac(47 downto 40));
        udp_packet(7) := unsigned(src_mac(39 downto 32));
        udp_packet(8) := unsigned(src_mac(31 downto 24));
        udp_packet(9) := unsigned(src_mac(23 downto 16));
        udp_packet(10) := unsigned(src_mac(15 downto 8));
        udp_packet(11) := unsigned(src_mac(7 downto 0));
        -- -- Type: IPV4
        udp_packet(12) := x"08";
        udp_packet(13) := x"00";
        -- IPv4 header
        udp_packet(14) := x"45";        -- version and header length            -- <= covered by checksum
        udp_packet(15) := x"00";        -- DSCP and ECN                         -- <= covered by checksum
        udp_packet(16) := to_unsigned(payload'length + 8 + 20, 16)(15 downto 8); -- lenght   <= covered by checksum
        udp_packet(17) := to_unsigned(payload'length + 8 + 20, 16)(7 downto 0);  -- length   <= covered by checksum
        udp_packet(18) := unsigned ( id(15 downto 8) );                         -- <= covered by checksum
        udp_packet(19) := unsigned ( id(7 downto 0) );                          -- <= covered by checksum
        udp_packet(20) := x"40";        -- flags and fragment offset            -- <= covered by checksum
        udp_packet(21) := x"00";        -- flags and fragment offset            -- <= covered by checksum
        udp_packet(22) := x"40";        -- ttl                                  -- <= covered by checksum
        udp_packet(23) := x"11";        -- protocol number -- UDP               -- <= covered by checksum
        udp_packet(24) := x"00"; -- checksum 
        udp_packet(25) := x"00"; -- checksum
        udp_packet(26) := unsigned ( src_ip(31 downto 24) );                    -- <= covered by checksum
        udp_packet(27) := unsigned ( src_ip(23 downto 16) );                    -- <= covered by checksum
        udp_packet(28) := unsigned ( src_ip(15 downto 8) );                     -- <= covered by checksum
        udp_packet(29) := unsigned ( src_ip(7 downto 0) );                      -- <= covered by checksum   
        udp_packet(30) := unsigned ( dst_ip(31 downto 24) );                    -- <= covered by checksum
        udp_packet(31) := unsigned ( dst_ip(23 downto 16) );                    -- <= covered by checksum
        udp_packet(32) := unsigned ( dst_ip(15 downto 8) );                     -- <= covered by checksum
        udp_packet(33) := unsigned ( dst_ip(7 downto 0) );                      -- <= covered by checksum
        -- UDP header
        udp_packet(34) := unsigned ( src_port(15 downto 8) );    -- source port
        udp_packet(35) := unsigned ( src_port(7 downto 0) );     -- source port
        udp_packet(36) := unsigned ( dst_port(15 downto 8) );    -- dest port
        udp_packet(37) := unsigned ( dst_port(7 downto 0) );     -- dest port
        udp_packet(38) := to_unsigned(payload'length + 8, 16)(15 downto 8);  -- length in bytes of the UDP header
        udp_packet(39) := to_unsigned(payload'length + 8, 16)(7 downto 0);   -- and UDP payload
        udp_packet(40) := x"00";                                 -- checksum of the pseudoheader
        udp_packet(41) := x"00";                                 -- checksum of the pseudoheader


        -- to_unsigned(payload'length + 8, 16)(7 downto 0);

        -- fill udp_packet with UDP payload

        for I in 0 to payload'length-1 loop
            udp_packet(42+I) := payload(I);
        end loop;

        -- Calculate the IPv4 checksum

        for I in 0 to 9 loop
            -- exclude field with the checksum
            if (I /= 5) then
                temp_sum := udp_packet(14+2*I) & udp_packet(14+2*I+1);
                ipv4_sum := unsigned(ipv4_sum) +  unsigned(temp_sum);
            end if;
        end loop;


        ipv4_checksum := not( std_logic_vector(ipv4_sum(15 downto 0) + ipv4_sum(19 downto 16)) ); 
        -- store IPv4 checksum in the appropriate field
        udp_packet(24) := unsigned ( ipv4_checksum(15 downto 8) );
        udp_packet(25) := unsigned ( ipv4_checksum(7 downto 0) );


        -- calculate the sum over UDP header and UDP payload
        -- if number of bytes in the payload is odd then pad a packet with zero for checksum 
        -- calculation
        if ((payload'length mod 2) = 0) then

            for I in 0 to (payload'length-1)/2 + 4 loop
                if (I /= 3) then 
                    temp_sum := udp_packet(34 + I*2) & udp_packet(34 + I*2+1);
                    payload_sum := unsigned ( payload_sum ) + unsigned ( temp_sum );
                end if;
            end loop;

        else

            for I in 0 to (payload'length-1)/2 + 4 loop
                if ((I /= 3) and (I /= (payload'length-1)/2 + 4)) then 
                    temp_sum := udp_packet(34 + I*2) & udp_packet(34 + I*2+1);
                    payload_sum := unsigned ( payload_sum ) + unsigned ( temp_sum );
                elsif (I = (payload'length-1)/2 + 4) then
                    temp_sum := udp_packet(34 + I*2) & x"00";
                    payload_sum := unsigned ( payload_sum ) + unsigned ( temp_sum );                    
                end if;
            end loop;

        end if;

        -- add the sum from UDP pseudoheader
        udp_sum := payload_sum  + unsigned(src_ip(31 downto 16))          -- IP SRC
                                + unsigned(src_ip(15 downto 0)) 
                                + unsigned(dst_ip(31 downto 16))          -- IP DST
                                + unsigned(dst_ip(15 downto 0)) 
                                + to_unsigned(17, 16)                       -- Protocol type x"11"
                                + to_unsigned(payload'length + 8, 16);      -- udp payload length + udp header length

        udp_checksum := not( std_logic_vector(udp_sum(15 downto 0) + udp_sum(19 downto 16)) ); 

        -- store the checksum
        udp_packet(40) := unsigned ( udp_checksum(15 downto 8) );
        udp_packet(41) := unsigned ( udp_checksum(7 downto 0) ); 

        -- make a packet wrong with incorrect checksum:
        -- udp_packet(25) := udp_packet(25) + 1; 

        wait until rising_edge(clock);
        nibble_dv <= '1';
        for I in 0 to udp_packet'length-1 loop
            temp := std_logic_vector(udp_packet(I));
            nibble <= temp(3 downto 0);
            wait until rising_edge(clock);
            nibble <= temp(7 downto 4);
            wait until rising_edge(clock);
        end loop; 
        nibble_dv <= '0';
    
    end procedure p_send_udp_packet;


----------------------------------------------------------------

    procedure p_send_arp(
        signal clock        : in std_logic;
        constant dst_mac      : in std_logic_vector(47 downto 0);
        constant src_mac      : in std_logic_vector(47 downto 0);
        constant sender_mac   : in std_logic_vector(47 downto 0);
        constant target_mac   : in std_logic_vector(47 downto 0);        
        constant sender_ip    : in std_logic_vector(31 downto 0);
        constant target_ip    : in std_logic_vector(31 downto 0);
        constant opcode       : in std_logic_vector(15 downto 0);
        signal nibble       : out std_logic_vector(3 downto 0);
        signal nibble_dv    : out std_logic;
        signal eth_crc      : out std_logic_vector(31 downto 0)
    ) is 
    
        TYPE arr_byte IS ARRAY(natural RANGE <>) OF unsigned(7 DOWNTO 0);
        variable arp_packet : arr_byte(0 to 41);
        variable temp : std_logic_vector(7 downto 0);
        variable crc_chsum : arr_byte(0 to 3);
        CONSTANT CRC_POLY : unsigned(31 DOWNTO 0) := x"04C11DB7";

        -- ethernet 32bit CCR
        FUNCTION crc (data : arr_byte) RETURN std_logic_vector IS
            --VARIABLE r  : arr_byte(0 TO 3) := (x"00",x"00",x"00",x"00");
            VARIABLE r  : std_logic_vector(31 downto 0);
            VARIABLE c  : unsigned(31 DOWNTO 0) :=x"FFFFFFFF";
            VARIABLE mm : unsigned(31 DOWNTO 0);
        BEGIN
            FOR I IN data'range LOOP
                FOR J IN 0 TO 7 LOOP
                    mm:=(OTHERS => data(I)(J) XOR c(31));
                    c:=(c(30 DOWNTO 0) & '0') XOR (mm AND CRC_POLY);
                END LOOP;
            END LOOP;

            FOR I IN 0 TO 31 LOOP
                mm(I):=NOT c(31-I);
            END LOOP;
            r := std_logic_vector(mm(7 downto 0)) & std_logic_vector(mm(15 downto 8)) & std_logic_vector(mm(23 downto 16)) & std_logic_vector(mm(31 downto 24));
            return r;
        END;

    begin

        -- destination MAC, broadcast
        arp_packet(0) := unsigned(dst_mac(47 downto 40));
        arp_packet(1) := unsigned(dst_mac(39 downto 32));
        arp_packet(2) := unsigned(dst_mac(31 downto 24));
        arp_packet(3) := unsigned(dst_mac(23 downto 16));
        arp_packet(4) := unsigned(dst_mac(15 downto 8));
        arp_packet(5) := unsigned(dst_mac(7 downto 0));
        -- source MAC
        arp_packet(6) := unsigned(src_mac(47 downto 40));
        arp_packet(7) := unsigned(src_mac(39 downto 32));
        arp_packet(8) := unsigned(src_mac(31 downto 24));
        arp_packet(9) := unsigned(src_mac(23 downto 16));
        arp_packet(10) := unsigned(src_mac(15 downto 8));
        arp_packet(11) := unsigned(src_mac(7 downto 0));
        -- Type: ARP
        arp_packet(12) := x"08";
        arp_packet(13) := x"06";
        -- HW type Ethernet
        arp_packet(14) := x"00";
        arp_packet(15) := x"01";
        -- Protocol type: IPv4
        arp_packet(16) := x"08";
        arp_packet(17) := x"00";
        -- hwardware size: 6
        arp_packet(18) := x"06";
        -- protocol sie: 4
        arp_packet(19) := x"04";
        -- oprocde: 2 (reply)
        arp_packet(20) := unsigned(opcode(15 downto 8));
        arp_packet(21) := unsigned(opcode(7 downto 0));
        -- sender MAC address
        arp_packet(22) := unsigned(src_mac(47 downto 40));
        arp_packet(23) := unsigned(src_mac(39 downto 32));
        arp_packet(24) := unsigned(src_mac(31 downto 24));
        arp_packet(25) := unsigned(src_mac(23 downto 16));
        arp_packet(26) := unsigned(src_mac(15 downto 8));
        arp_packet(27) := unsigned(src_mac(7 downto 0));
        -- sender IP address
        arp_packet(28) := unsigned(sender_ip(31 downto 24));
        arp_packet(29) := unsigned(sender_ip(23 downto 16));
        arp_packet(30) := unsigned(sender_ip(15 downto 8));
        arp_packet(31) := unsigned(sender_ip(7 downto 0));
        -- target MAC address
        arp_packet(32) := unsigned(target_mac(47 downto 40));
        arp_packet(33) := unsigned(target_mac(39 downto 32));
        arp_packet(34) := unsigned(target_mac(31 downto 24));
        arp_packet(35) := unsigned(target_mac(23 downto 16));
        arp_packet(36) := unsigned(target_mac(15 downto 8));
        arp_packet(37) := unsigned(target_mac(7 downto 0));
        -- target IP address
        arp_packet(38) := unsigned(target_ip(31 downto 24));
        arp_packet(39) := unsigned(target_ip(23 downto 16));
        arp_packet(40) := unsigned(target_ip(15 downto 8));
        arp_packet(41) := unsigned(target_ip(7 downto 0));

        eth_crc <= crc(arp_packet);

        wait until rising_edge(clock);
        nibble_dv <= '1';
        for I in 0 to 41 loop
            temp := std_logic_vector(arp_packet(I));
            nibble <= temp(3 downto 0);
            wait until rising_edge(clock);
            nibble <= temp(7 downto 4);
            wait until rising_edge(clock);
        end loop; 
        nibble_dv <= '0';
        

    end procedure p_send_arp;

    ----------------------------------------------------------------------
    


end package body;
