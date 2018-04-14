 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : mii_terminal.vhd
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
use work.ntp_pkg.all;
-- SVN TEST

ENTITY mii_terminal IS
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
END ENTITY mii_terminal;

ARCHITECTURE rtl OF mii_terminal IS



    component add_crc32 is
        Port ( clk             : in  STD_LOGIC;
               data_in         : in  STD_LOGIC_VECTOR (3 downto 0);
               data_enable_in  : in  STD_LOGIC;
               data_out        : out STD_LOGIC_VECTOR (3 downto 0);
               data_enable_out : out STD_LOGIC);
    end component;

    
    component add_preamble is
        Port ( clk             : in  STD_LOGIC;
               data_in         : in  STD_LOGIC_VECTOR (3 downto 0);
               data_enable_in  : in  STD_LOGIC;
               data_out        : out STD_LOGIC_VECTOR (3 downto 0);
               data_enable_out : out STD_LOGIC);
    end component;


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


    signal eth_in_en_prev   : std_logic;
    signal nibble           : std_logic := '0';
    signal crc32            : std_logic_vector(31 downto 0) := (others => '0');

    signal to_crc_d         : std_logic_vector(3 downto 0)  := (others => '0');
    signal to_crc_dv        : std_logic := '0';

    signal to_preamb_d      : std_logic_vector(3 downto 0)  := (others => '0');
    signal to_preamb_dv     : std_logic := '0';



BEGIN

eth_in_clk <= transport eth_ref_clk after 7 ns;
eth_out_clk <= transport eth_ref_clk after 12 ns;

-------------------------------------------------------------------
-- This process generates a proper ethernet package.              -
-------------------------------------------------------------------
    transmitter : process 

    constant udp_payload : t_arr_byte := (
        x"dc", x"00", x"00", x"e9", x"00", x"00", x"00", x"00", x"00", x"01", x"00", x"00", x"00", x"00", x"00", x"00",
        x"de", x"5d", x"5a", x"31", x"29", x"0e", x"12", x"e8", x"de", x"54", x"29", x"42", x"30", x"62", x"4d", x"d2",
        x"de", x"6c", x"a3", x"fa", x"20", x"dc", x"db", x"37", x"de", x"6c", x"a3", x"fa", x"20", x"dc", x"f9", x"6a");
    variable temp : integer;

    begin 

        
        wait for 20 us;
        
        -- send NTP response
        temp := udp_payload'length;
        p_send_udp_packet(eth_out_clk,x"00183E0238DB",x"4CCC6A88F1F3",x"0A000002",x"0A000001",x"c36c",x"007b",x"c65c",udp_payload,to_crc_d,to_crc_dv,crc32);

        wait for 10 us;

        --  Who has 10.0.0.2? Tell 10.0.0.1 (PC ask for Artix’s MAC address)
        p_send_arp(eth_out_clk,x"ffffffffffff",x"4ccc6a88f1f3",x"4ccc6a88f1f3",x"000000000000",
                    x"0a000001",x"0a000002",x"0001",to_crc_d,to_crc_dv,crc32);
    


        wait for 5 us;
        
        assert false report "Simulation end." severity failure;


    end process;

    mii_logger_i1 : mii_logger
        generic map (
            FILENAME    => "mii_logger_tb_to_uut.txt"
        )
        port map (
            clock       => eth_out_clk,
            reset_n     => '1',
            eth_in_d    => to_crc_d,
            eth_in_en   => to_crc_dv
        );

    add_crc32_i1 : add_crc32
        port map (  
                clk             => eth_out_clk,
                data_in         => to_crc_d,
                data_enable_in  => to_crc_dv,
                data_out        => to_preamb_d,
                data_enable_out => to_preamb_dv
                );

    add_preamble_i1 : add_preamble
        port map ( 
                clk             => eth_out_clk,
                data_in         => to_preamb_d,
                data_enable_in  => to_preamb_dv,
                data_out        => eth_out_d,
                data_enable_out => eth_out_dv
                );

---------------------------------------------------------------------
-- In this process data received from MII are saved to the text file. 
---------------------------------------------------------------------


    receiver : process (eth_in_clk, reset_n)
        file      outfile  : text is out "mii_rx_log.txt";  --declare output file
        variable  outline  : line;   --line number declaration  
        variable  rx_byte  : std_logic_vector(7 downto 0) := (others => '0');
    BEGIN
        if (reset_n='0') then
        elsif (eth_in_clk='1' and eth_in_clk'event) then
            eth_in_en_prev <= eth_in_en;
            if (eth_in_en_prev='0' and eth_in_en='1') then
                write(outline, string'("Beginning of the packet"));
                writeline(outfile, outline);
                rx_byte(3 downto 0) := eth_in_d;
                nibble <= '1';
            elsif (eth_in_en_prev='1' and eth_in_en='0') then
                write(outline, string'("End of the packet"));
                writeline(outfile, outline);
            elsif (eth_in_en_prev='1' and eth_in_en='1') then
                if (nibble='1') then
                    rx_byte(7 downto 4) := eth_in_d;
                    nibble <= '0';
                    hwrite(outline, rx_byte, right, 6);
                    writeline(outfile, outline);
                else 
                    rx_byte(3 downto 0) := eth_in_d;
                    nibble <= '1';
                end if;
            end if;
        end if;
    end process receiver;

-------------------------------------------------------------------


END ARCHITECTURE rtl;
