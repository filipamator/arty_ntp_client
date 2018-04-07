library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ntp_pkg.all;


entity ntp_packet_tb is
end ntp_packet_tb;

architecture rtl of ntp_packet_tb is

component ntp_packet is
port (
        i_clock     : in std_logic;
        i_reset_n   : in std_logic;
        i_start     : in std_logic;

        i_dst_mac   : in std_logic_vector(47 downto 0);
        i_src_mac   : in std_logic_vector(47 downto 0);

        i_ip_src    : in std_logic_vector(31 downto 0);
        i_ip_dst    : in std_logic_vector(31 downto 0);

        o_ntp_nibble    : out std_logic_vector(3 downto 0);
        o_ntp_valid     : out std_logic;
        o_ntp_ntpdata   : out std_logic;
        o_ntp_packet    : out t_packet
);
end component ntp_packet;

component mii_terminal IS
PORT (
    eth_ref_clk : in std_logic;
    reset_n     : in std_logic;
    -- tx channel
    eth_in_d    : in STD_LOGIC_VECTOR (3 downto 0);
    eth_in_en   : in STD_LOGIC;
    eth_in_clk  : out STD_LOGIC;
    -- rx channel
    eth_out_d    : out  STD_LOGIC_VECTOR(3 downto 0);
    eth_out_err  : out  STD_LOGIC;
    eth_out_dv   : out  STD_LOGIC;
    eth_out_clk  : out  STD_LOGIC
);
END component mii_terminal;

component mii_rx IS
PORT (
    reset_n     : in std_logic;
    clock_i     : in std_logic;
    -- rx channel
    eth_rx_d    : in  STD_LOGIC_VECTOR(3 downto 0);
    eth_rx_err  : in  STD_LOGIC;
    eth_rx_dv   : in  STD_LOGIC;
    eth_rx_clk  : in  STD_LOGIC;

    packet_o      : out std_logic_vector(7 downto 0);
    packet_dv_o   : out std_logic
);
END component mii_rx;


signal clock : std_logic := '0';
signal start : std_logic := '0';
signal reset_n : std_logic := '0';
signal eth_tx_clk : std_logic := '0';
signal ntp_valid : std_logic := '0';
signal ntp_nibble : std_logic_vector(3 downto 0);

signal timestamp : unsigned(63 downto 0);


signal eth_rx_d   : std_logic_vector(3 downto 0);
signal eth_rx_err : std_logic := '0';
signal eth_rx_dv  : std_logic := '0';

begin


clock <= not clock after 5 ns;

proc_start : process
begin
        reset_n <= '0';
        wait until rising_edge(clock);
        reset_n <= '1';
        wait for 100 ns;
        wait until rising_edge(clock);  
        start <= '1';
        wait until rising_edge(clock);  
        start <= '0'; 
        wait for 1 us;
        wait;
end process;


process(clock)
begin
if (reset_n='0') then
        timestamp <= (others => '0');
elsif (clock='1' and clock'event) then
        timestamp <= timestamp + 43;
end if;
end process;

ntp_packet_i1 : ntp_packet
port map (
        i_clock     => eth_tx_clk, 
        i_reset_n   => reset_n,
        i_start     => start,
        i_dst_mac   => x"4ccc6a88f1f3", -- PC MAC
        i_src_mac   => x"7c1c687f4ca2", -- Samsung MAC 
        i_ip_src    => x"c0a80038",     -- 192.168.0.56
        i_ip_dst    => x"c0a8002f",      -- 192.168.0.47        
        o_ntp_nibble => open, -- ntp_nibble,
        o_ntp_valid  => open -- ntp_valid

);

mii_terminal_i1 : mii_terminal
port map(
    eth_ref_clk => clock,
    reset_n     => reset_n,
    -- rx channel
    eth_in_d    => ntp_nibble,
    eth_in_en   => ntp_valid,
    eth_in_clk  => eth_tx_clk,
    -- tx channel
    eth_out_d    => ntp_nibble,
    eth_out_err  => open,
    eth_out_dv   => ntp_valid,
    eth_out_clk  => open
);



---------------------------------------------------------
-- mii_rx.vhd test                                      - 
---------------------------------------------------------


-- process 
-- begin 
-- wait for 200 ns;
--         wait until rising_edge(clock);
--         eth_rx_dv <= '1';
--         eth_rx_d <= x"E";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"D";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"D";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"A";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"E";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"B";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"F";
--         wait until rising_edge(clock);
--         eth_rx_d <= x"E";
--         wait until rising_edge(clock);
--         eth_rx_dv <= '0';
--         wait; 
-- end process;


-- mii_rx_i1 : mii_rx
-- PORT map (
--     reset_n    => reset_n,
--     clock_i    => clock,
--     -- rx channel
--     eth_rx_d   => eth_rx_d,
--     eth_rx_err => eth_rx_err,
--     eth_rx_dv  => eth_rx_dv,
--     eth_rx_clk => clock,
--     packet_o      => open,
--     packet_dv_o   => open
-- );

-- ntp_packet_i1 : ntp_packet
-- port map (
--         i_clock     => clock, 
--         i_reset_n   => '0',
--         i_dst_mac   => x"9021061c8918",
--         i_src_mac   => x"4ccc6a88f1f3", -- PC MAC, PC addr: 192.168.0.47 
--         i_ip_src    => x"c0a8002f",
--         i_ip_dst    => x"55c7d662"
-- );

end rtl;