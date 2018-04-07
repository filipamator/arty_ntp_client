library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
--use work.genram_pkg.all;
use work.ntp_pkg.all;

-- SVN TEST

ENTITY arp_decoder IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    
    arp_d_i     : in std_logic_vector(7 downto 0);
    arp_dv_i    : in std_logic;
    -- local address
    local_mac_i     : in std_logic_vector(47 downto 0);
    local_ip_i      : in std_logic_vector(31 downto 0);

    send_arp_an_i   : in std_logic;

    req_o		: out std_logic;
	grant_i		: in std_logic;
	M_AXIS_TVALID_o	    : out std_logic;
	M_AXIS_TDATA_o	    : out std_logic_vector(7 downto 0);
	M_AXIS_TLAST_o	    : out std_logic;
	M_AXIS_TREADY_i	    : in std_logic
);
END ENTITY arp_decoder;

ARCHITECTURE rtl OF arp_decoder IS


signal byte_counter : integer range 0 to 2047;
type t_ST is (ST_IDLE, ST_READ, ST_ARP, ST_FLUSH, ST_ANNO);
signal ST : t_ST := ST_IDLE;
signal arp_packet : t_arr_byte(0 to 59);
signal send_arp_resp : std_logic := '0';



type state is ( IDLE, INIT_COUNTER, SEND_REQ, SEND_STREAM);                                                                                           
signal  mst_exec_state : state;       
signal counter	: integer := 0;
signal data_counter	: integer := 0;

BEGIN

-- dest mac
--arp_packet(0) <= x"00";
--arp_packet(1) <= x"00";
--arp_packet(2) <= x"00";
--arp_packet(3) <= x"00";
--arp_packet(4) <= x"00";
--arp_packet(5) <= x"00";
-- src mac
arp_packet(6) <= unsigned ( local_mac_i(47 downto 40) );
arp_packet(7) <= unsigned ( local_mac_i(39 downto 32) );
arp_packet(8) <= unsigned ( local_mac_i(31 downto 24) );
arp_packet(9) <= unsigned ( local_mac_i(23 downto 16) );
arp_packet(10) <= unsigned ( local_mac_i(15 downto 8) );
arp_packet(11) <= unsigned ( local_mac_i(7 downto 0) );
-- arp protocol
arp_packet(12) <= x"08";
arp_packet(13) <= x"06";
-- ethertype 
arp_packet(14) <= x"00";
arp_packet(15) <= x"01";
-- ipv4
arp_packet(16) <= x"08";
arp_packet(17) <= x"00";
-- hardware addr size
arp_packet(18) <= x"06";
-- proto addr size
arp_packet(19) <= x"04";
-- opcode reply
--arp_packet(20) <= x"00";
--arp_packet(21) <= x"02";
-- sender MAC
arp_packet(22) <= unsigned ( local_mac_i(47 downto 40) );
arp_packet(23) <= unsigned ( local_mac_i(39 downto 32) );
arp_packet(24) <= unsigned ( local_mac_i(31 downto 24) );
arp_packet(25) <= unsigned ( local_mac_i(23 downto 16) );
arp_packet(26) <= unsigned ( local_mac_i(15 downto 8) );
arp_packet(27) <= unsigned ( local_mac_i(7 downto 0) );
-- sender IP
arp_packet(28) <= unsigned ( local_ip_i(31 downto 24) );
arp_packet(29) <= unsigned ( local_ip_i(23 downto 16) );
arp_packet(30) <= unsigned ( local_ip_i(15 downto 8) );
arp_packet(31) <= unsigned ( local_ip_i(7 downto 0) );
-- target MAC
--arp_packet(32) <= x"00";
--arp_packet(33) <= x"00";
--arp_packet(34) <= x"00";
--arp_packet(35) <= x"00";
--arp_packet(36) <= x"00";
--arp_packet(37) <= x"00";
-- target IP
--arp_packet(38) <= x"00";
--arp_packet(39) <= x"00";
--arp_packet(40) <= x"00";
--arp_packet(41) <= x"00";

arp_packet(42) <= x"00";
arp_packet(43) <= x"00";
arp_packet(44) <= x"00";
arp_packet(45) <= x"00";
arp_packet(46) <= x"00";
arp_packet(47) <= x"00";
arp_packet(48) <= x"00";
arp_packet(49) <= x"00";
arp_packet(50) <= x"00";
arp_packet(51) <= x"00";
arp_packet(52) <= x"00";
arp_packet(53) <= x"00";
arp_packet(54) <= x"00";
arp_packet(55) <= x"00";
arp_packet(56) <= x"00";
arp_packet(57) <= x"00";
arp_packet(58) <= x"00";
arp_packet(59) <= x"00";




decode_packet : process(clock_i,reset_n)

    variable src_ip     : std_logic_vector(31 downto 0);
    variable dst_ip     : std_logic_vector(31 downto 0);
    variable src_mac    :  std_logic_vector(47 downto 0);
    variable dst_mac    : std_logic_vector(47 downto 0);
    variable temp       : std_logic_vector(7 downto 0);
    variable arp_oper   : std_logic_vector(7 downto 0);

    

begin
    if (reset_n='0') then
        ST <= ST_IDLE;
        byte_counter <= 0;  
        send_arp_resp <= '0';
    elsif (clock_i='1' and clock_i'event) then
        case (ST) is 
            
            when ST_IDLE =>                 
                
                send_arp_resp <= '0';
                
                if (arp_dv_i='1') then
                    temp := arp_d_i;
                    if (arp_d_i = x"00") then             -- HTYPE MSB
                        byte_counter <= 1;
                        ST <= ST_READ;
                    else
                        ST <= ST_FLUSH;
                    end if;
                elsif (send_arp_an_i='1') then
                    ST <= ST_ANNO;
                end if;    
            
            when ST_READ =>                 
                
                if (arp_dv_i='0') then
                    ST <= ST_IDLE;
                else
                    temp := arp_d_i;
                    if (byte_counter=1) then       
                        if (arp_d_i = x"01") then ST <= ST_READ; else ST <= ST_FLUSH; end if;   -- HTYPE LSB
                    elsif (byte_counter=2) then
                        if (arp_d_i = x"08") then ST <= ST_READ; else ST <= ST_FLUSH; end if;   -- PTYPE MSB
                    elsif (byte_counter=3) then
                        if (arp_d_i = x"00") then ST <= ST_READ; else ST <= ST_FLUSH; end if;   -- PTYPE LSB
                    elsif (byte_counter=4) then
                        if (arp_d_i = x"06") then ST <= ST_READ; else ST <= ST_FLUSH; end if;
                    elsif (byte_counter=5) then
                        if (arp_d_i = x"04") then ST <= ST_READ; else ST <= ST_FLUSH; end if;
                    elsif (byte_counter=6) then
                        if (arp_d_i = x"00") then ST <= ST_READ; else ST <= ST_FLUSH; end if;
                    elsif (byte_counter=7) then
                        
                        if (arp_d_i = x"01") then 
                            ST <= ST_READ; 
                            arp_oper := arp_d_i; 
                        elsif (arp_d_i = x"02") then
                            ST <= ST_READ;
                            arp_oper := arp_d_i;
                        else  
                            ST <= ST_FLUSH; 
                        end if;
                    
                    elsif (byte_counter=8) then src_mac(47 downto 40) := arp_d_i;
                    elsif (byte_counter=9) then src_mac(39 downto 32) := arp_d_i;
                    elsif (byte_counter=10) then src_mac(31 downto 24) := arp_d_i;
                    elsif (byte_counter=11) then src_mac(23 downto 16) := arp_d_i;
                    elsif (byte_counter=12) then src_mac(15 downto 8) := arp_d_i;
                    elsif (byte_counter=13) then src_mac(7 downto 0) := arp_d_i;
                    elsif (byte_counter=14) then src_ip(31 downto 24) := arp_d_i;
                    elsif (byte_counter=15) then src_ip(23 downto 16) := arp_d_i;
                    elsif (byte_counter=16) then src_ip(15 downto 8) := arp_d_i;
                    elsif (byte_counter=17) then src_ip(7 downto 0) := arp_d_i;
                    elsif (byte_counter=18) then dst_mac(47 downto 40) := arp_d_i;
                    elsif (byte_counter=19) then dst_mac(39 downto 32) := arp_d_i;
                    elsif (byte_counter=20) then dst_mac(31 downto 24) := arp_d_i;
                    elsif (byte_counter=21) then dst_mac(23 downto 16) := arp_d_i;
                    elsif (byte_counter=22) then dst_mac(15 downto 8) := arp_d_i;
                    elsif (byte_counter=23) then dst_mac(7 downto 0) := arp_d_i;
                    elsif (byte_counter=24) then dst_ip(31 downto 24) := arp_d_i;
                    elsif (byte_counter=25) then dst_ip(23 downto 16) := arp_d_i;
                    elsif (byte_counter=26) then dst_ip(15 downto 8) := arp_d_i;
                    elsif (byte_counter=27) then 
                                                dst_ip(7 downto 0) := arp_d_i; 
                                                ST <= ST_ARP;
                    end if;

                    byte_counter <= byte_counter + 1;
                end if;
            
            when ST_ARP =>

                if ((arp_oper = x"01") and (dst_ip=local_ip_i)) then
                    -- dest mac - ethernet frame level
                    arp_packet(0) <= unsigned ( src_mac(47 downto 40) );
                    arp_packet(1) <= unsigned ( src_mac(39 downto 32) );
                    arp_packet(2) <= unsigned ( src_mac(31 downto 24) );
                    arp_packet(3) <= unsigned ( src_mac(23 downto 16) );
                    arp_packet(4) <= unsigned ( src_mac(15 downto 8) );
                    arp_packet(5) <= unsigned ( src_mac(7 downto 0) );
                    -- opcode reply
                    arp_packet(20) <= x"00";
                    arp_packet(21) <= x"02";
                    -- target MAC - arp packet level
                    arp_packet(32) <= unsigned ( src_mac(47 downto 40) );
                    arp_packet(33) <= unsigned ( src_mac(39 downto 32) );
                    arp_packet(34) <= unsigned ( src_mac(31 downto 24) );
                    arp_packet(35) <= unsigned ( src_mac(23 downto 16) );
                    arp_packet(36) <= unsigned ( src_mac(15 downto 8) );
                    arp_packet(37) <= unsigned ( src_mac(7 downto 0) );
                    -- target IP
                    arp_packet(38) <= unsigned ( src_ip(31 downto 24) );
                    arp_packet(39) <= unsigned ( src_ip(23 downto 16) );
                    arp_packet(40) <= unsigned ( src_ip(15 downto 8) );
                    arp_packet(41) <= unsigned ( src_ip(7 downto 0) );

                    send_arp_resp <= '1';
                end if;
                    ST <= ST_IDLE;

            when ST_ANNO =>
                    -- dest mac - ethernet frame level
                    arp_packet(0) <= x"ff";
                    arp_packet(1) <= x"ff";
                    arp_packet(2) <= x"ff";
                    arp_packet(3) <= x"ff";
                    arp_packet(4) <= x"ff";
                    arp_packet(5) <= x"ff";
                    -- opcode request
                    arp_packet(20) <= x"00";
                    arp_packet(21) <= x"01";
                    -- target MAC - arp packet level
                    arp_packet(32) <= x"00";
                    arp_packet(33) <= x"00";
                    arp_packet(34) <= x"00";
                    arp_packet(35) <= x"00";
                    arp_packet(36) <= x"00";
                    arp_packet(37) <= x"00";
                    -- target IP
                    arp_packet(38) <= unsigned ( local_ip_i(31 downto 24) );
                    arp_packet(39) <= unsigned ( local_ip_i(23 downto 16) );
                    arp_packet(40) <= unsigned ( local_ip_i(15 downto 8) );
                    arp_packet(41) <= unsigned ( local_ip_i(7 downto 0) );

                    send_arp_resp <= '1';

                    ST <= ST_IDLE;

            when ST_FLUSH =>                             -- flush the fifo
                if (arp_dv_i='0') then
                    ST <= ST_IDLE;
                else 
                    ST <= ST_FLUSH;
                end if;

        end case;
    end if;
end process;


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

                                            
send_arp_pckt: process(clock_i,reset_n)                                                                        
	begin                                                                                       
        if (reset_n='0') then
            counter <= 0;
            M_AXIS_TVALID_o <= '0';
            M_AXIS_TLAST_o <= '0';
            M_AXIS_TDATA_o <= (others => '0');
			data_counter <= 0;
			req_o <= '0';
            mst_exec_state <= IDLE;     
	    elsif (rising_edge (clock_i)) then                                                       
	                                                                                                                                            
	      case (mst_exec_state) is                                                              
	        when IDLE     =>
				M_AXIS_TLAST_o <= '0';
                M_AXIS_TVALID_o <= '0';                                                                                                      
	            mst_exec_state <= IDLE;                                                                                                                                                                                         

                if (send_arp_resp='1') then
                    counter <= 0;
                    data_counter <= 0;
                    req_o <= '1';
                    mst_exec_state <= SEND_REQ;
                end if;                                                                       


			when SEND_REQ =>


				if (grant_i='1') then
					M_AXIS_TVALID_o <= '1';
                    M_AXIS_TDATA_o <= std_logic_vector(arp_packet(data_counter));
					data_counter <= 1;
					mst_exec_state <= SEND_STREAM;
				else 
					mst_exec_state <= SEND_REQ;
				end if;


	        when SEND_STREAM  =>      

		
				-- previous byte was send over bus
				if (M_AXIS_TREADY_i='1') then
					
					-- M_AXIS_TDATA_o <= std_logic_vector(arp_packet(data_counter));
                    -- data_counter <= data_counter + 1;

					-- if (data_counter=40) then
					-- 	M_AXIS_TLAST_o <= '1';
					-- end if;

					if (data_counter=60) then
						M_AXIS_TDATA_o <= (others => '0');
						M_AXIS_TLAST_o <= '0';
						data_counter <= 0;
						M_AXIS_TVALID_o <= '0';
						req_o <= '0';
						mst_exec_state <= IDLE;

					elsif (data_counter=59) then
                        M_AXIS_TLAST_o <= '1';
                        M_AXIS_TDATA_o <= std_logic_vector(arp_packet(data_counter));
                        data_counter <= data_counter + 1;
                    else 
					    M_AXIS_TDATA_o <= std_logic_vector(arp_packet(data_counter));
                        data_counter <= data_counter + 1;
                    end if;



				end if;


	                                                                                            
	        when others    =>                                                                   
	          mst_exec_state <= IDLE;                                                           
	                                                                                            
	      end case;                                                                             
                                                                             
	  end if;                                                                                   
	end process;                                                                                



---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

END ARCHITECTURE rtl;
