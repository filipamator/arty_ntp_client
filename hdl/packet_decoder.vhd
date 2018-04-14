 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : packet_decoder.vhd
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

ENTITY packet_decoder IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    -- rx channel from MII chip
    eth_rx_d    : in  STD_LOGIC_VECTOR(3 downto 0);
    eth_rx_err  : in  STD_LOGIC;
    eth_rx_dv   : in  STD_LOGIC;
    eth_rx_clk  : in  STD_LOGIC;
    -- local address
    local_mac_i   : in std_logic_vector(47 downto 0);     -- Our MAC address
    local_ip_i    : in std_logic_vector(31 downto 0);     -- Our IP address
    -- ARP packet
    arp_d_o     : out std_logic_vector(7 downto 0);
    arp_dv_o    : out std_logic;
    -- IP Packet
    ipv4_d_o     : out std_logic_vector(7 downto 0);
    ipv4_dv_o    : out std_logic;
    -- any other packet out
    debug_d     : out std_logic_vector(7 downto 0);
    debug_dv    : out std_logic

);
END ENTITY packet_decoder;

ARCHITECTURE rtl OF packet_decoder IS



component blk_mem_gen_3 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end component blk_mem_gen_3;

-- component fifo_2048x8 IS
--   PORT (
--     rst : IN STD_LOGIC;
--     wr_clk : IN STD_LOGIC;
--     rd_clk : IN STD_LOGIC;
--     din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--     wr_en : IN STD_LOGIC;
--     rd_en : IN STD_LOGIC;
--     dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
--     full : OUT STD_LOGIC;
--     empty : OUT STD_LOGIC;
--     wr_rst_busy : OUT STD_LOGIC;
--     rd_rst_busy : OUT STD_LOGIC
--   );
-- END component fifo_2048x8;

component fifo_2048x8 is
  Port ( 
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC
  );

end component fifo_2048x8;

component fifo_2048x9_dv is
    port ( 
        rst : in STD_LOGIC;
        wr_clk : in STD_LOGIC;
        rd_clk : in STD_LOGIC;
        din : in STD_LOGIC_VECTOR ( 8 downto 0 );
        wr_en : in STD_LOGIC;
        rd_en : in STD_LOGIC;
        dout : out STD_LOGIC_VECTOR ( 8 downto 0 );
        full : out STD_LOGIC;
        empty : out STD_LOGIC;
        valid : out STD_LOGIC
  );
end component fifo_2048x9_dv;


-- fifo input

signal eth_rx_dv_prev   : std_logic  := '0';
signal nibble           : std_logic := '0';
signal byte             : std_logic_vector(8 downto 0);
signal byte_dv          : std_logic  := '0';



-- packet counter

signal e_pcnt_inc       : std_logic  := '0'; -- eth_rx_clk

signal rx_pcnt_inc          : std_logic  := '0';
signal rx_pcnt_inc_meta     : std_logic  := '0';
signal rx_pcnt_inc_prev     : std_logic  := '0';
 
signal rx_pcnt      : integer := 0;     -- clock_i
signal rx_pcnt_dec  : std_logic := '0';





-- fifo output

signal rx_byte      : std_logic_vector(7 downto 0);
signal rx_byte_dv   : std_logic;
signal rx_fifo_dout      : std_logic_vector(8 downto 0);
signal fifo_rd_en   : std_logic := '0'; 
signal fifo_empty   : std_logic;
signal byte_counter : integer range 0 to 2047;
signal rd_valid     : std_logic;


signal s_arp_dv_o, s_ipv4_dv_o : std_logic;

signal rx_byte_s0,rx_byte_s1, rx_byte_s2, rx_byte_s3, rx_byte_s4 : std_logic_vector(8 downto 0);


type t_STRX is (ST_IDLE, ST_WRITE);
signal STRX : t_STRX := ST_IDLE;

type t_ST is (ST_IDLE, ST_DATA, ST_WAIT,ST_DUMP);
signal ST : t_ST := ST_IDLE;


-- packet decoding (arp, ipv4)
signal STdec : t_ST := ST_IDLE;
signal bcounter : integer := 0;


constant EOP : std_logic_vector(8 downto 0) := "100000000";
signal temp : std_logic_vector(7 downto 0);


BEGIN


arp_dv_o <= s_arp_dv_o;
ipv4_dv_o <= s_ipv4_dv_o;

-------------------------------------------
-- Incoming packet is stored in the fifo --
-------------------------------------------

-- fifo_2048x8_i1 : fifo_2048x8
--     port map (
--         rst     => not reset_n,
--         wr_clk  => eth_rx_clk,
--         rd_clk  => clock_i,
--         din     => byte,
--         wr_en   => byte_dv,

--         rd_en   => fifo_rd_en,
--         dout    => rx_byte,
--         full    => open,
--         empty   => fifo_empty
--     );
    
    
fifo_2048x9_dv_i1 : fifo_2048x9_dv
    port map ( 
        rst     => not reset_n,
        wr_clk  => eth_rx_clk,  
        rd_clk  => clock_i,
        din     => byte,
        wr_en   => byte_dv,
        rd_en   => fifo_rd_en,
        dout    => rx_fifo_dout,
        full    => open,
        empty   => fifo_empty,
        valid   => rd_valid
  );


packet_decoder: process (clock_i)
    variable got_arp    : std_logic;
    variable got_ipv4   : std_logic;
    variable temp1      : std_logic_vector(7 downto 0);
begin 

    if (reset_n='0') then
        bcounter <= 0;
        got_ipv4 := '0';
        got_arp := '0';
        s_arp_dv_o <= '0';
        arp_d_o <= (others => '0');
        ipv4_d_o <= (others => '0');
        s_ipv4_dv_o <= '0';
        STdec <= ST_WAIT;
        
    elsif (clock_i='1' and clock_i'event) then

        case (STdec) is 

            when ST_IDLE =>
                if (rx_byte_dv='1') then
                    if (rx_byte = x"08") then
                        bcounter <= 1;
                        STdec <= ST_DATA;
                    else
                        STdec <= ST_DUMP;
                    end if;
                end if;

            when ST_DATA =>
                if (rx_byte_dv='0') then
                    s_arp_dv_o <= '0';
                    s_ipv4_dv_o <= '0';
                    STdec <= ST_IDLE;
                else
                    if (bcounter=1) then                    -- ARP and IPv4 only
                        temp1 := rx_byte;
                        if (rx_byte=x"00") then
                            got_ipv4 := '1'; 
                        elsif (rx_byte = x"06") then
                            got_arp := '1'; 
                        else
                            STdec <= ST_DUMP;
                        end if;
                    elsif (bcounter=2) then
                        if (got_arp='1') then
                            arp_d_o <= rx_byte;
                            s_arp_dv_o <= '1';
                            got_arp := '0';
                        elsif (got_ipv4='1') then
                            ipv4_d_o <= rx_byte;
                            s_ipv4_dv_o <= '1';
                            got_ipv4 := '0';
                        end if;
                    end if;
                    if (s_arp_dv_o='1') then
                        arp_d_o <= rx_byte;
                    end if; 
                    if (s_ipv4_dv_o='1') then
                        ipv4_d_o <= rx_byte;
                    end if; 
                    bcounter <= bcounter + 1;
                end if;

            when ST_WAIT =>
                STdec <= ST_IDLE;
            when ST_DUMP =>
                if (rx_byte_dv='1') then
                    STdec <= ST_DUMP;
                else 
                    STdec <= ST_IDLE;
                end if;
        end case;



    end if;
end process;





---------------------------------------------------
-- synchronize packet counter increase flag from --
-- eth_rx_clk domain to clock_i domain           --
---------------------------------------------------

flag_sync: process (clock_i)
begin 
    if (clock_i='1' and clock_i'event) then
        rx_pcnt_inc_meta <= e_pcnt_inc;         --packet counter increase flag
        rx_pcnt_inc <= rx_pcnt_inc_meta;
        rx_pcnt_inc_prev <= rx_pcnt_inc;
    end if;
end process;

----------------------------------------------------
-- depending on flags rx_pcnt_inc and rx_pcnt_dec --
-- the packet counter rx_pcnt is                  --
-- increased/decreased                            --
----------------------------------------------------

packet_counter: process (clock_i,reset_n)
begin 
    if (reset_n='0') then
        rx_pcnt <= 0;
    elsif (clock_i='1' and clock_i'event) then
        if (rx_pcnt_dec='0') then
            if ((rx_pcnt_inc_prev='0') and (rx_pcnt_inc='1')) then
                rx_pcnt <= rx_pcnt + 1;
            end if;
        else
            if ((rx_pcnt_inc_prev='0') and (rx_pcnt_inc='1')) then
                rx_pcnt <= rx_pcnt;
            else 
                rx_pcnt <= rx_pcnt - 1;
            end if;
        end if;
    end if;
end process;


------------------------------------------------ 
--- Fetch bytes from fifo if packet counter  ---
--- rx_pcnt is greater than zero             ---
------------------------------------------------



-- dump every decoded packed
debug_d <= rx_byte;
debug_dv <= rx_byte_dv;


fetch_from_fifo: process(clock_i,reset_n)
variable dst_mac : std_logic_vector(47 downto 0);
begin
    if (reset_n='0') then
        fifo_rd_en <= '0';
        byte_counter <= 0;
        ST <= ST_IDLE;
        rx_pcnt_dec <= '0';
        rx_byte_dv <= '0';
    elsif (clock_i='1' and clock_i'event) then

        rx_byte <= rx_byte_s3(7 downto 0);
        rx_byte_s3 <= rx_byte_s2;
        rx_byte_s2 <= rx_byte_s1;
        rx_byte_s1 <= rx_byte_s0;


        case (ST) is 
        
            when ST_IDLE =>              
                
                if (rx_pcnt > 0) then
                    fifo_rd_en <= '1';
                    byte_counter <= 0;
                    ST <= ST_DATA;
                end if;    

            when ST_DATA =>                 
                
                if (rd_valid='1') then
                    if (rx_fifo_dout = EOP) then
                        fifo_rd_en <= '0';
                        rx_byte_dv <= '0';
                        rx_pcnt_dec <= '1';
                        ST <= ST_WAIT;
                    else

                        rx_byte_s0 <= rx_fifo_dout;

                        if (byte_counter=8) then                    -- get dst MAC address from the packet
                            dst_mac(47 downto 40) := rx_fifo_dout(7 downto 0);
                        elsif (byte_counter=9) then
                            dst_mac(39 downto 32) := rx_fifo_dout(7 downto 0);
                        elsif (byte_counter=10) then
                            dst_mac(31 downto 24) := rx_fifo_dout(7 downto 0);
                        elsif (byte_counter=11) then
                            dst_mac(23 downto 16) := rx_fifo_dout(7 downto 0);
                        elsif (byte_counter=12) then
                            dst_mac(15 downto 8) := rx_fifo_dout(7 downto 0);
                        elsif (byte_counter=13) then         
                            dst_mac(7 downto 0) := rx_fifo_dout(7 downto 0);
                            if (dst_mac=local_mac_i or dst_mac=x"ffffffffffff") then    -- we are interested only in 
                                ST <= ST_DATA;
                            else                                                        -- poackets addressed to broadcast or to our MAC address
                                ST <= ST_DUMP;
                            end if;
                        elsif (byte_counter=24) then
                            rx_byte_dv <= '1';
                        end if;    
                        byte_counter <= byte_counter + 1;
                    end if;
                end if;

            when ST_DUMP =>                             -- flush the fifo
                if (rd_valid='1') then
                    if (rx_fifo_dout=EOP) then
                        fifo_rd_en <= '0';
                        rx_pcnt_dec <= '1';
                        ST <= ST_WAIT;
                    end if;
                end if;

            when ST_WAIT =>
                rx_pcnt_dec <= '0';
                ST <= ST_IDLE;

        end case;
    end if;
end process;



------------------------------------------------ 
-- store nibble/half-bytes in the fifo      ----
-- and increase packet counter by rising
-- flag e_pcnt_inc for one clock cycyle     ----
------------------------------------------------

    store_in_fifo : process (eth_rx_clk, reset_n) 
        variable  rx_nibble  : std_logic_vector(3 downto 0) := (others => '0');
    BEGIN

        if (reset_n='0') then
            byte <= (others => '0');
            byte_dv <= '0';
            e_pcnt_inc <= '0';
            STRX <= ST_IDLE;
        elsif (eth_rx_clk='1' and eth_rx_clk'event) then
            
            eth_rx_dv_prev <= eth_rx_dv;
            case (STRX) is
                when ST_IDLE =>
                    e_pcnt_inc <= '0';
                    byte_dv <= '0';
                    if (eth_rx_dv_prev='0' and eth_rx_dv='1') then
                        rx_nibble := eth_rx_d;
                        nibble <= '1';
                        STRX <= ST_WRITE;
                    end if;
                when ST_WRITE =>
                    if (eth_rx_dv_prev='1' and eth_rx_dv='0') then
                        byte <= EOP;
                        e_pcnt_inc <= '1';
                        --packet_count <= packet_count + 1;                        
                        STRX <= ST_IDLE;
                    elsif (eth_rx_dv_prev='1' and eth_rx_dv='1') then
                        if (nibble='1') then
                            byte <= '0' & eth_rx_d & rx_nibble;
                            byte_dv <= '1';
                            nibble <= '0';
                        else 
                            rx_nibble := eth_rx_d;
                            byte_dv <= '0';
                            nibble <= '1';
                        end if;
                    end if;                    
            end case;
        end if;
    end process store_in_fifo;

-------------------------------------------------------------------------------------------

END ARCHITECTURE rtl;
