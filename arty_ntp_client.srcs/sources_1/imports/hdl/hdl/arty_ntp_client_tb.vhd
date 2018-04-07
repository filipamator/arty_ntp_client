library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity arty_ntp_client_tb  is
end arty_ntp_client_tb;

architecture Behavioral of arty_ntp_client_tb is

component arty_ntp_client is
    generic (
            g_SIMULATION : boolean := false
    );
    Port ( CLK100MHZ   : in    STD_LOGIC;
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
            
           PMODA_1      : out std_logic;
           PMODA_2      : out std_logic;
           PMODA_3      : out std_logic;
           PMODA_4      : out std_logic;
           PMODA_7      : out std_logic;
           PMODA_8      : out std_logic;
           PMODA_9      : out std_logic;
           PMODA_10      : out std_logic;

           UART_TXD     : in std_logic;
           UART_RXD     : out std_logic      
        
           );
           
end component arty_ntp_client;


component mii_terminal IS
PORT (
    eth_ref_clk : in std_logic;
    reset_n     : in std_logic;
    -- rx channel
    eth_in_d    : in STD_LOGIC_VECTOR (3 downto 0);
    eth_in_en   : in STD_LOGIC;
    eth_in_clk  : out STD_LOGIC;
    -- tx channel
    eth_out_d    : out  STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    eth_out_err  : out  STD_LOGIC;
    eth_out_dv   : out  STD_LOGIC := '0';
    eth_out_clk  : out  STD_LOGIC
);
END component mii_terminal;


component UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 115     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component UART_RX;


signal clock : std_logic := '0';

signal eth_ref_clk  : std_logic;
signal eth_tx_en    : std_logic;
signal eth_tx_clk   : std_logic;
signal eth_rx_err   : std_logic;
signal eth_rx_dv    : std_logic;
signal eth_rx_clk   : std_logic;
signal eth_tx_d     : std_logic_vector(3 downto 0);
signal eth_rx_d     : std_logic_vector(3 downto 0);
signal UART_RTD     : std_logic;

begin


clock <= not clock after 5 ns;


mii_terminal_i1 : mii_terminal
port map(
    eth_ref_clk => eth_ref_clk,
    reset_n     => '1',
    -- tx channel
    eth_in_d    => eth_tx_d,
    eth_in_en   => eth_tx_en,
    eth_in_clk  => eth_tx_clk,
    -- rx channel
    eth_out_d    => eth_rx_d,
    eth_out_err  => eth_rx_err,
    eth_out_dv   => eth_rx_dv,
    eth_out_clk  => eth_rx_clk
);


arty_ntp_client_i1 : arty_ntp_client
    generic map (
        g_SIMULATION => true
    )
    port map ( 
           CLK100MHZ => clock,
           -- Switches
           switches  => "0001",
             
           -- control channel
           eth_mdio    => open,
           eth_mdc    => open,
           eth_rstn   => open,
           -- tx channel
           eth_tx_d   => eth_tx_d,
           eth_tx_en  => eth_tx_en,
           eth_tx_clk => eth_ref_clk,
           -- rx channel
           eth_rx_d    => eth_rx_d, 
           eth_rx_err  => eth_rx_err,
           eth_rx_dv   => eth_rx_dv,
           eth_rx_clk  =>eth_rx_clk, 
           -- link status
           eth_col     => '0',
           eth_crs     => '0',
           -- reference clock
           eth_ref_clk  => eth_ref_clk,
           -- leds
           led4        => open,
           led5        => open,
           led6        => open,
           led7        => open,
            PMODA_1      => open,
           PMODA_2      => open,
           PMODA_3      => open,
           PMODA_4     => open,
           PMODA_7      => open,
           PMODA_8      => open,
           PMODA_9      => open,
           PMODA_10     => open,
           UART_RXD => UART_RTD,
           UART_TXD => '0'
           );
           


UART_RX_i1 : UART_RX
  generic map(
    g_CLKS_PER_BIT => 20
    )
  port map(
    i_Clk     => clock,
    i_RX_Serial => UART_RTD,
    o_RX_DV   => open,
    o_RX_Byte => open
    );

end Behavioral;