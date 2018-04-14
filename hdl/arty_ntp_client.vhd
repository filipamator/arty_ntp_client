 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : arty_ntp_client.vhd
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

Library UNISIM;
use UNISIM.vcomponents.all;

entity arty_ntp_client is
    generic (
            g_SIMULATION    : boolean := false;

            -- NTP server
--            g_DST_MAC       : std_logic_vector(47 downto 0) := x"4CCC6A88F1F3";       -- Local NTP server
            g_DST_MAC       : std_logic_vector(47 downto 0) := x"9021061c8918";         -- Gateway ftom the local network to the Internet
            -- MAC address of the NTP client
            g_SRC_MAC       : std_logic_vector(47 downto 0) := x"00183e0238db";      
            -- IPv4 address of the NTP client
            g_IP_SRC        : std_logic_vector(31 downto 0) := x"C0A80065";     -- 192.168.0.101
            -- IPv4 address of the NTP server
--            g_IP_DST        : std_logic_vector(31 downto 0) := x"C0A80064"    -- 192.168.0.100
            g_IP_DST        : std_logic_vector(31 downto 0) := x"8B8F051E";      -- 139.143.5.30 / ntp1.npl.co.uk
            -- time zone; for GMT+1 would be "3600", for GMT+2 "7200" etc.
            GMT_OFFSET      : integer := 3600
    );
    port ( 
            CLK100MHZ   : in    STD_LOGIC;
           -- Switches
           switches    : in  STD_LOGIC_VECTOR(3 downto 0);
             
           -- control channel
           eth_mdio    : inout STD_LOGIC := '0';
           eth_mdc     : out   STD_LOGIC := '0';
           eth_rstn    : out   STD_LOGIC := '1';
           -- tx channel
           eth_tx_d    : out STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           eth_tx_en   : out STD_LOGIC  := '0';
           eth_tx_clk  : in  STD_LOGIC;
           -- rx channel
           eth_rx_d    : in  STD_LOGIC_VECTOR(3 downto 0);
           eth_rx_err  : in  STD_LOGIC;
           eth_rx_dv   : in  STD_LOGIC;
           eth_rx_clk  : in  STD_LOGIC; 
           -- link status
           eth_col     : in  STD_LOGIC;
           eth_crs     : in  STD_LOGIC;
           -- reference clock
           eth_ref_clk : out STD_LOGIC;
           -- leds
           led4        : out STD_LOGIC;
           led5        : out STD_LOGIC;
           led6        : out STD_LOGIC;
           led7        : out STD_LOGIC;
           -- PMOD A interface
           PMODA_1      : out std_logic;
           PMODA_2      : out std_logic;
           PMODA_3      : out std_logic;
           PMODA_4      : out std_logic;
           PMODA_7      : out std_logic;
           PMODA_8      : out std_logic;
           PMODA_9      : out std_logic;
           PMODA_10      : out std_logic;
            -- UART
           UART_TXD     : in std_logic;
           UART_RXD     : out std_logic

           );
           
end arty_ntp_client;

architecture Behavioral of arty_ntp_client is
 
component resetgen IS
PORT (
    clock_i         : in std_logic;
    reset_n_o       : out std_logic := '0'
);
END component resetgen;

component packet_decoder IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    -- rx channel
    eth_rx_d    : in  STD_LOGIC_VECTOR(3 downto 0);
    eth_rx_err  : in  STD_LOGIC;
    eth_rx_dv   : in  STD_LOGIC;
    eth_rx_clk  : in  STD_LOGIC;
        
    local_mac_i   : in std_logic_vector(47 downto 0);     -- Our MAC address
    local_ip_i    : in std_logic_vector(31 downto 0);     -- Our IP address

    arp_d_o     : out std_logic_vector(7 downto 0);
    arp_dv_o    : out std_logic;

    ipv4_d_o     : out std_logic_vector(7 downto 0);
    ipv4_dv_o    : out std_logic;
    debug_d     : out std_logic_vector(7 downto 0);
    debug_dv    : out std_logic
);
END component packet_decoder;


component ipv4_decoder IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;

    ipv4_d_i     : in std_logic_vector(7 downto 0);
    ipv4_dv_i    : in std_logic;
    -- local address
    local_ip_i    : in std_logic_vector(31 downto 0);
    ntp_d_o       : out std_logic_vector(7 downto 0);
    ntp_dv_o      : out std_logic
);
END component ipv4_decoder;

component mii_logger is
        generic (
            FILENAME    : string
        );
        port (
            clock       : in std_logic;
            reset_n     : in std_logic;
            eth_in_d    : in STD_LOGIC_VECTOR (3 downto 0);
            eth_in_en   : in STD_LOGIC
        );
end component mii_logger;

component arp_decoder IS
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
END component arp_decoder;

component display_top is
    generic (
            REFRESH_RATE : natural := 25_000_000        -- 0.5sec.
    );
    Port (  clk      : in  STD_LOGIC;
            d_clk    : out  STD_LOGIC;
            d_strobe : out  STD_LOGIC;
            d_data   : out  STD_LOGIC;
            dig7 : in std_logic_vector(7 downto 0);
            dig6 : in std_logic_vector(7 downto 0);
            dig5 : in std_logic_vector(7 downto 0);
            dig4 : in std_logic_vector(7 downto 0);
            dig3 : in std_logic_vector(7 downto 0);
            dig2 : in std_logic_vector(7 downto 0);
            dig1 : in std_logic_vector(7 downto 0);
            dig0 : in std_logic_vector(7 downto 0);
            indicator0 : in std_logic_vector(1 downto 0);
            indicator1 : in std_logic_vector(1 downto 0)
            
        );
end component display_top;


component uartdump IS
port  (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    data_i      : in std_logic_vector(7 downto 0);
    data_en_i   : in std_logic;
    uart_tx_o     : out std_logic
);
end component uartdump;


component uartdump_nbl IS
port (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
        -- rx channel from MII chip
    eth_rx_d    : in  STD_LOGIC_VECTOR(3 downto 0);
    eth_rx_err  : in  STD_LOGIC;
    eth_rx_dv   : in  STD_LOGIC;
    eth_rx_clk  : in  STD_LOGIC;
    uart_tx_o     : out std_logic
);
end component uartdump_nbl;
----------------------------------------------------------------------
---------------------- AXI4 stream -----------------------------------
----------------------------------------------------------------------

component axis_switch_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tready : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_req_suppress : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_decode_err : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end component axis_switch_0;

component axis_eth is
	port (
		clock_i						: in std_logic;
        eth_clock_i				: in std_logic;
		reset_n_i					: in std_logic;
		S_AXIS_TREADY_o		: out std_logic;
		S_AXIS_TDATA_i		: in std_logic_vector(7 downto 0);
		S_AXIS_TLAST_i		: in std_logic;
		S_AXIS_TVALID_i		: in std_logic;
        data_o						: out std_logic_vector(3 downto 0);
		data_en_o					: out std_logic
	);
end component axis_eth;


component axis_arbiter is
	port (
		clock_i	    		: in std_logic;
		reset_n_i			: in std_logic;
		req_i				: in std_logic_vector(3 downto 0);
		grant00_o			: out std_logic;
		grant01_o			: out std_logic;
		grant02_o			: out std_logic;
		grant03_o			: out std_logic	
	);
end component axis_arbiter;


component axis_ntp is
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
end component axis_ntp;

component ntp_client IS
port  (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    ntp_d_i       : in std_logic_vector(7 downto 0);
    ntp_dv_i      : in std_logic;
    new_value_v     : out std_logic;
    new_value       : out std_logic_vector(63 downto 0)
);
end component ntp_client;

component main_clock IS
generic (
    REQ_TIMER   : natural := 250_000_000;
    TIMEOUT     : natural := 50_000_000;
    GMT_OFFSET  : integer := 3600
);
port (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    new_time_i      : in std_logic_vector(63 downto 0);
    new_time_dv_i   : in std_logic;
    send_ntp_o      : out std_logic;
    update_time_i   : in std_logic;
    phy_ready_i     : in std_logic;
    hour_a      : out std_logic_vector(7 downto 0);
    hour_b      : out std_logic_vector(7 downto 0);
    minute_a      : out std_logic_vector(7 downto 0);
    minute_b      : out std_logic_vector(7 downto 0);
    second_a      : out std_logic_vector(7 downto 0);
    second_b      : out std_logic_vector(7 downto 0);
    indicator0    : out std_logic_vector(1 downto 0);
    indicator1    : out std_logic_vector(1 downto 0);
    send_arp_anno_o : out std_logic    
);
end component main_clock;

 component uart_mux is
    Port ( 
            clock_i     : in std_logic;
            select_i    : in std_logic_vector(1 downto 0);
            UART1_i     : in std_logic;
            UART2_i     : in std_logic;
            UART3_i     : in std_logic;
            UART4_i     : in std_logic;
            UART_o      : out std_logic
    );
 end component uart_mux;


component clk_wiz_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_out3 : out STD_LOGIC;
    resetn : in STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );
end component clk_wiz_0;


----------------------------------------------------------------------
----------------------------------------------------------------------

    signal phy_ready        : std_logic                     := '0';
    signal tx_ready_meta    : std_logic                     := '0';
    signal tx_ready         : std_logic                     := '0';
    signal ok_to_send       : std_logic                     := '0';


    signal ipv4_d           :  STD_LOGIC_VECTOR(7 downto 0);
    signal ipv4_dv          :  STD_LOGIC;
    signal arp_d            :  STD_LOGIC_VECTOR(7 downto 0);
    signal arp_dv           :  STD_LOGIC;

    signal send_arp_anno      : std_logic := '0';

    signal eth_rx_byte      :  STD_LOGIC_VECTOR(7 downto 0);
    signal eth_rx_byte_dv   :  STD_LOGIC;

    signal fullframe        : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal fullframe_dv     : std_logic; 

    signal ntp_d            : std_logic_vector(7 downto 0);
    signal ntp_dv           : std_logic;

    signal debug_d          : std_logic_vector(7 downto 0);
    signal debug_dv         : std_logic;


    signal send_ntp_req     : std_logic;

    signal new_time_dv     : std_logic;
    signal new_time        : std_logic_vector(63 downto 0);

    -- attribute mark_debug : string;
    -- attribute mark_debug of eth_rx_d : signal is "true";
    -- attribute mark_debug of eth_rx_clk : signal is "true";
    -- attribute mark_debug of eth_rx_dv : signal is "true";
    -- attribute mark_debug of debug_d : signal is "true";
    -- attribute mark_debug of debug_dv : signal is "true";


    



    -- signal between AIXS swiych and MII interface
    signal eth_axis_tdata       : STD_LOGIC_VECTOR(7 downto 0);
    signal eth_axis_tvalid      : std_logic_vector(0 downto 0);
    signal eth_axis_tlast       : std_logic_vector(0 downto 0);
    signal eth_axis_tready      : std_logic_vector(0 downto 0);


    -- clock to display signals

    signal hour_a      : std_logic_vector(7 DOWNTO 0);
    signal hour_b      : std_logic_vector(7 DOWNTO 0);
    signal minute_a    : std_logic_vector(7 DOWNTO 0);
    signal minute_b    : std_logic_vector(7 DOWNTO 0);
    signal second_a    : std_logic_vector(7 DOWNTO 0);
    signal second_b    : std_logic_vector(7 DOWNTO 0);
    signal indicator0  : std_logic_vector(1 DOWNTO 0);
    signal indicator1  : std_logic_vector(1 DOWNTO 0);


    signal UART_RXD_eth, UART_RXD_arp, UART_RXD_ipv4,UART_RXD_debug : std_logic;

    --------------------------------
    -- Bus signals                --
    --------------------------------
    
    -- switch to master signals

    signal  m00_axis_tvalid, m01_axis_tvalid, m02_axis_tvalid, m03_axis_tvalid  : std_logic := '0';
    signal  m00_axis_tready, m01_axis_tready, m02_axis_tready, m03_axis_tready  : std_logic := '0';
    signal  m00_axis_tdata, m01_axis_tdata, m02_axis_tdata, m03_axis_tdata      : std_logic_vector(7 downto 0) := (others => '0');
    signal  m00_axis_tlast, m01_axis_tlast, m02_axis_tlast, m03_axis_tlast      : std_logic := '0';
    signal m_axis_tready                        : std_logic_vector(3 downto 0);
    signal m00_req, m01_req, m02_req, m03_req   : std_logic := '0';
    signal m00_grant, m01_grant, m02_grant, m03_grant    : std_logic := '0';   
    
    -- switch to slave signals

    signal s_axis_tvalid    : STD_LOGIC;
    signal s_axis_tready    : STD_LOGIC;
    signal s_axis_tdata     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal s_axis_tlast     : STD_LOGIC;


    -- Clocking signals 
   
    signal reset_n  : std_logic;
    signal clk50MHz : std_logic;
    signal clk25MHz : std_logic;

begin


 led5 <= eth_crs;

packet_decoder_i1  : packet_decoder
port map  (
    reset_n     => reset_n,       -- in
    clock_i     => clk50MHz,      -- in
    -- rx channel
    eth_rx_d    => eth_rx_d,        -- in
    local_mac_i   => g_SRC_MAC,
    local_ip_i    => g_IP_SRC,
    eth_rx_err  => eth_rx_err,      -- in
    eth_rx_dv   => eth_rx_dv,       -- in
    eth_rx_clk  => eth_rx_clk,       -- in
    arp_d_o     => arp_d,
    arp_dv_o    => arp_dv,
    ipv4_d_o     => ipv4_d,
    ipv4_dv_o    => ipv4_dv,
    debug_d      => debug_d,
    debug_dv     => debug_dv

);


-- uartdump_nbl_i1 : uartdump_nbl
-- port map(
--     clock_i     => clk50MHz,
--     reset_n     => reset_n,
--         -- rx channel from MII chip
--     eth_rx_d    => eth_rx_d,
--     eth_rx_err  => eth_rx_err, 
--     eth_rx_dv   => eth_rx_dv,
--     eth_rx_clk  => eth_rx_clk,
--     uart_tx_o   => UART_RXD_eth
-- );



uartdump_i1 : uartdump
port map(
    clock_i => clk50MHz,
    reset_n => reset_n,
    data_i  => arp_d,
    data_en_i => arp_dv,
    uart_tx_o  => UART_RXD_arp
);

uartdump_i2 : uartdump
port map(
    clock_i => clk50MHz,
    reset_n => reset_n,
    data_i  => ipv4_d,
    data_en_i => ipv4_dv,
    uart_tx_o  => UART_RXD_ipv4
);

uartdump_i3 : uartdump
port map(
    clock_i => clk50MHz,
    reset_n => reset_n,
    data_i  => ntp_d,
    data_en_i => ntp_dv,
    uart_tx_o  => UART_RXD_debug
);


uartdump_i4 : uartdump
port map(
    clock_i => clk50MHz,
    reset_n => reset_n,
    data_i  => m00_axis_tdata,
    data_en_i =>m00_axis_tready,
    uart_tx_o  => UART_RXD_eth
);


uart_mux_i1 : uart_mux
port map ( 
        clock_i     => Clk50MHz,
        select_i    => switches(2 downto 1),
        UART1_i     => UART_RXD_debug,     
        UART2_i     => UART_RXD_arp,   
        UART3_i     => UART_RXD_ipv4,
        UART4_i     => UART_RXD_eth,            -- ARP reply
        UART_o      => UART_RXD
    );

ipv4_decoder_i1 : ipv4_decoder 
port map (
    clock_i     => clk50MHz,
    reset_n     => reset_n,
    ipv4_d_i     => ipv4_d,
    ipv4_dv_i    => ipv4_dv,
    -- local address
    local_ip_i    => g_IP_SRC,
    ntp_d_o       => ntp_d,
    ntp_dv_o     => ntp_dv
);


ntp_client_i1 : ntp_client
port map(
    clock_i     => clk50MHz,
    reset_n     => reset_n,
    ntp_d_i     => ntp_d,
    ntp_dv_i    => ntp_dv,
    new_value_v => new_time_dv,
    new_value   => new_time
);


main_clock_i1 : main_clock
generic map (
    REQ_TIMER   => 100_000_000,
    TIMEOUT     => 50_000_000,
    GMT_OFFSET  => GMT_OFFSET
)
port map (
    clock_i     => clk50MHz,
    reset_n     => reset_n,
    new_time_i   => new_time,
    new_time_dv_i => new_time_dv,
    hour_a     => hour_a,
    hour_b     => hour_b,
    minute_a   => minute_a,
    minute_b   => minute_b,
    second_a   => second_a,
    second_b   => second_b,
    indicator0 => indicator0,
    indicator1 => indicator1,
    send_ntp_o => send_ntp_req,
    update_time_i => switches(0),
    phy_ready_i => phy_ready,
    send_arp_anno_o => send_arp_anno
);


arp_decoder_i1 : arp_decoder
port map (
    clock_i => clk50MHz,
    reset_n => reset_n,
    arp_d_i => arp_d,
    arp_dv_i => arp_dv,
    local_mac_i   => g_SRC_MAC,
    local_ip_i    => g_IP_SRC,
    send_arp_an_i => send_arp_anno,
    req_o	        => m00_req,            -- out std_logic;
	grant_i		    => m00_grant,        -- in std_logic;
	M_AXIS_TVALID_o	=> m00_axis_tvalid,        -- out std_logic;
	M_AXIS_TDATA_o  => m00_axis_tdata,        -- out std_logic_vector(7 downto 0);
	M_AXIS_TLAST_o	=> m00_axis_tlast,        -- out std_logic;
	M_AXIS_TREADY_i	=> m00_axis_tready         -- in std_logic
);

----------------------------------------------------------------------
---------------------- AXI4 stream -----------------------------------
----------------------------------------------------------------------
m00_axis_tready <= m_axis_tready(0);
m01_axis_tready <= m_axis_tready(1);
m02_axis_tready <= m_axis_tready(2);
m03_axis_tready <= m_axis_tready(3);


axis_arbiter_i1 : axis_arbiter
	port map (
		clock_i	  => clk50MHz,
		reset_n_i => reset_n,
		req_i       => m03_req & m02_req & m01_req & m00_req,
		grant00_o   => m00_grant,
		grant01_o   => m01_grant,
		grant02_o   => m02_grant,
		grant03_o   => m03_grant	
	);

axis_switch_0_i1 : axis_switch_0
    port map ( 
        aclk            => clk50MHz,                                                                    -- in STD_LOGIC;
        aresetn         => reset_n,                                                                     -- in STD_LOGIC;
        s_axis_tvalid   => m03_axis_tvalid & m02_axis_tvalid & m01_axis_tvalid & m00_axis_tvalid,       -- in STD_LOGIC_VECTOR ( 3 downto 0 );
        s_axis_tready => m_axis_tready,                                                                 -- out STD_LOGIC_VECTOR ( 3 downto 0 );
        s_axis_tdata  => m03_axis_tdata & m02_axis_tdata & m01_axis_tdata & m00_axis_tdata,             -- in STD_LOGIC_VECTOR ( 31 downto 0 );
        s_axis_tlast  => m03_axis_tlast & m02_axis_tlast & m01_axis_tlast & m00_axis_tlast,             -- in STD_LOGIC_VECTOR ( 3 downto 0 );
        s_axis_tdest  => (others => '0'),                                       -- in STD_LOGIC_VECTOR ( 7 downto 0 );
        m_axis_tvalid => eth_axis_tvalid,                                           -- out STD_LOGIC_VECTOR ( 0 to 0 );
        m_axis_tready => eth_axis_tready,                                           -- in STD_LOGIC_VECTOR ( 0 to 0 );
        m_axis_tdata  => eth_axis_tdata,                                            -- out STD_LOGIC_VECTOR ( 7 downto 0 );
        m_axis_tlast  => eth_axis_tlast,                                            -- out STD_LOGIC_VECTOR ( 0 to 0 );
        m_axis_tdest => open,                                                   -- out STD_LOGIC_VECTOR ( 1 downto 0 );
        s_req_suppress => (others => '0'),                                      -- in STD_LOGIC_VECTOR ( 3 downto 0 );
        s_decode_err => open                                                    -- out STD_LOGIC_VECTOR ( 3 downto 0 )
  );

axis_eth_i1 : axis_eth 
	port map (
		clock_i         => clk50MHz,                    -- in std_logic
        eth_clock_i     => eth_tx_clk,
		reset_n_i       => reset_n,                     -- in std_logic
		S_AXIS_TREADY_o => eth_axis_tready(0),          -- out std_logic  
		S_AXIS_TDATA_i => eth_axis_tdata,               -- in std_logic_vector
		S_AXIS_TLAST_i => eth_axis_tlast(0),            -- in std_logic
		S_AXIS_TVALID_i => eth_axis_tvalid(0),          -- in std_logic
        data_o => fullframe,						    -- out std_logic_vector(3 downto 0);
		data_en_o => fullframe_dv					-- out std_logic
	);


-- axis_master_i1 : axis_master
--     generic map (
--         BASE        => x"A0",
--         DELAY       => 512
--     )
--     port map (
-- 		clock_i     => clk50MHz,                -- in std_logic
-- 		reset_n_i   => reset_n,                 -- in std_logic
--         req_o		=> m00_req,
-- 		grant_i		=> '0', --m00_grant,
-- 		M_AXIS_TVALID_o => m00_axis_tvalid,         -- out std_logic
-- 		M_AXIS_TDATA_o => m00_axis_tdata,           -- out std_logic_vector(7 downto 0)
-- 		M_AXIS_TLAST_o => m00_axis_tlast,           -- out std_logic
-- 		M_AXIS_TREADY_i => m00_axis_tready          -- in std_logic
--     );

-- axis_master_i2 : axis_master
--     generic map (
--         Base        => x"00",
--         DELAY       => 570
--     )
--     port map (
-- 		clock_i     => clk50MHz,                -- in std_logic
-- 		reset_n_i   => reset_n,                 -- in std_logic
--         req_o		=> m01_req,
-- 		grant_i		=> m01_grant,
-- 		M_AXIS_TVALID_o => m01_axis_tvalid,         -- out std_logic
-- 		M_AXIS_TDATA_o => m01_axis_tdata,           -- out std_logic_vector(7 downto 0)
-- 		M_AXIS_TLAST_o => m01_axis_tlast,           -- out std_logic
-- 		M_AXIS_TREADY_i => m01_axis_tready          -- in std_logic
--     );



axis_ntp_i1 : axis_ntp
port map (
        i_clock     => clk50MHz, 
        i_reset_n   => reset_n,
        i_start     => send_ntp_req,
        i_dst_mac   => g_DST_MAC, -- PC MAC
        i_src_mac   => g_SRC_MAC, -- Artix MAC 
        i_ip_src    => g_IP_SRC,     -- 10.0.0.0.2
        i_ip_dst    => g_IP_DST,     -- 10.0.0.0.1
        req_o		=> m01_req,
	    grant_i		=> m01_grant,
	    M_AXIS_TVALID_o => m01_axis_tvalid,
	    M_AXIS_TDATA_o	=> m01_axis_tdata,
	    M_AXIS_TLAST_o	=> m01_axis_tlast,
	    M_AXIS_TREADY_i	=> m01_axis_tready

);


display_top_i1 : display_top
generic map (
            REFRESH_RATE =>  2_500_000        -- 0.05sec.
    )
port map (  clk     => clk50MHz,
            d_clk   => PMODA_1,
            d_strobe=> PMODA_2,
            d_data  => PMODA_3,
            dig7 => hour_a,
            dig6 => hour_b,
            dig5 => x"ff",
            dig4 => minute_a,
            dig3 => minute_b,
            dig2 => x"ff",
            dig1 => second_a,
            dig0 => second_b,
            indicator0 => indicator0,
            indicator1 => indicator1
        );
        
----------------------------------------------------------------------
----------------------------------------------------------------------


simul2: if g_SIMULATION generate
begin
    mii_logger_i1 : mii_logger
        generic map (
            FILENAME    => "mii_logger_uut_to_tb.txt"
        )
        port map (
            clock       => eth_tx_clk,
            reset_n     => '1',
            eth_in_d    => fullframe,
            eth_in_en   => fullframe_dv
        );
end generate;

send_data_out: process(eth_tx_clk)
    begin
       if falling_edge(eth_tx_clk) then
           eth_tx_d    <= fullframe;
           eth_tx_en   <= fullframe_dv and ok_to_send;
       end if;
    end process;
    
monitor_reset_state: process(eth_tx_clk)
    begin
       if rising_edge(eth_tx_clk) then
          tx_ready      <= tx_ready_meta;
          tx_ready_meta <= phy_ready;
          if tx_ready = '1' and fullframe_dv = '0' then
             ok_to_send    <= '1';
          end if;
       end if;
    end process;


simul: if g_SIMULATION generate
signal reset_counter : unsigned(7 downto 0)         := (others => '0');
begin
control_reset: process(clk25MHz)
    begin
        if rising_edge(clk25MHz) then           
            if reset_counter(reset_counter'high) = '0' then
                reset_counter <= reset_counter + 1;
            end if; 
            eth_rstn  <= reset_counter(reset_counter'high) or reset_counter(reset_counter'high-1);
            phy_ready <= reset_counter(reset_counter'high);
        end if;
    end process;
end generate;

not_simul: if not(g_SIMULATION) generate
signal reset_counter : unsigned(24 downto 0)         := (others => '0');
begin
control_reset: process(clk25MHz)
    begin
        if rising_edge(clk25MHz) then           
            if reset_counter(reset_counter'high) = '0' then
                reset_counter <= reset_counter + 1;
            end if; 
            eth_rstn  <= reset_counter(reset_counter'high) or reset_counter(reset_counter'high-1);
            phy_ready <= reset_counter(reset_counter'high);
        end if;
    end process;
end generate;


clock_fwd_ddr : ODDR
    generic map(
        DDR_CLK_EDGE => "SAME_EDGE", 
        INIT         => '0',
        SRTYPE       => "SYNC")
    port map (
        Q  => eth_ref_clk,
        C  => clk25MHz,
        CE => '1', R  => '0', S  => '0',
        D1 => '0', D2 => '1'
   );


clk_wiz_0_i1 : clk_wiz_0
    port map ( 
        clk_out1 => CLK25MHz,
        clk_out2 => CLK50MHz,
        clk_out3 => open,
        resetn => reset_n,
        clk_in1 => CLK100MHz
);

   
resetgen_i1 : resetgen
    port map(
        clock_i     => CLK100MHz,
        reset_n_o   => reset_n
);

end Behavioral;