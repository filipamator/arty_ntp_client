 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : axis_eth.vhd
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

entity axis_eth is
	port (
		clock_i						: in std_logic;
		eth_clock_i				: in std_logic;
		reset_n_i					: in std_logic;
		S_AXIS_TREADY_o		: out std_logic;
		S_AXIS_TDATA_i		: in std_logic_vector(7 downto 0);
--		S_AXIS_TSTRB_i		: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		S_AXIS_TLAST_i		: in std_logic;
		S_AXIS_TVALID_i		: in std_logic;
		data_o						: out std_logic_vector(3 downto 0);
		data_en_o					: out std_logic
	);
end axis_eth;

architecture arch_imp of axis_eth is



-- FIFO separates two clock domains - clock_i and eth_clock_i
	component fifo_2048x9 is
	PORT (
		rst 		: IN STD_LOGIC;
		wr_clk 	: IN STD_LOGIC;
		rd_clk 	: IN STD_LOGIC;
		din 		: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		wr_en 	: IN STD_LOGIC;
		rd_en 	: IN STD_LOGIC;
		dout 		: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		full 		: OUT STD_LOGIC;
		empty 	: OUT STD_LOGIC
	);
	end component fifo_2048x9;

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


	-- state machnine for processing packet stored in the fifo
	type state is (IDLE, READ_FIFO0, READ_FIFO1, READ_FIFO2,WS1); 
	signal e_state 	: state;  


	-- signals in clock_i domain
	signal packet_counter : integer := 0;
	signal counter_up, counter_down : std_logic := '0';
	signal cnt_down_prev, cnt_down,cnt_down_meta 		: std_logic := '0';
	signal fifo_din 								: std_logic_vector(8 downto 0);
	signal fifo_full  							: std_logic;	
	signal fifo_wren  							: std_logic;

-- signals in eth_clk_i domain
	signal e_fifo_rden  		: std_logic;
	signal e_dout_v					: std_logic;
	signal e_fifo_empty 		: std_logic;
	signal e_dout 					: std_logic_vector(8 downto 0);
	signal e_packet_counter : integer := 0;
	signal e_counter_down 	: std_logic;
	signal e_nibble					: std_logic_vector(3 downto 0);
	signal e_delay					: integer := 0;
	signal e_nibble_dv			: std_logic;
	signal e_done						: std_logic;
--	signal e_temp						: std_logic_vector(8 downto 0);

	signal e_fullframe		: std_logic_vector(3 downto 0);
	signal e_fullframe_dv	: std_logic;

	signal e_with_crc32		: std_logic_vector(3 downto 0);
	signal e_with_crc32_dv	: std_logic;
	

begin


data_o <= e_fullframe;
data_en_o <= e_fullframe_dv;

--counter_up <= S_AXIS_TVALID_i and S_AXIS_TLAST_i;	-- VERY BAD THING


-- this counter stores number of the packets in the FIFO
-- it is increased by one when TLAST_i='1' and TVALID='1'
-- and decreased when process processing packets on FIFO output will send counter_down='1'
load_fifo: process(clock_i,reset_n_i)
begin
	if (reset_n_i='0') then
		packet_counter <= 0;
	elsif (clock_i='1' and clock_i'event) then		
		if ((S_AXIS_TVALID_i='1' and S_AXIS_TLAST_i='1')) then
			packet_counter <= packet_counter + 1;
		elsif ((S_AXIS_TVALID_i='0' and S_AXIS_TLAST_i='0') and (cnt_down_prev='0' and cnt_down='1')) then
			packet_counter <= packet_counter - 1;
		end if;
	
	end if;
end process;


-- sync packet counter to eth_clk domain
sync_pkt_cnt: process(eth_clock_i)
begin
	if (eth_clock_i='1' and eth_clock_i'event) then
		e_packet_counter <= packet_counter; 
	end if;
end process;


-- edge detection
counter_down <= '1' when (cnt_down_prev='0' and cnt_down='1') else '0';

-- sync e_counter_down flag to clock_i domain
cnt_down_sync: process(clock_i)
begin
	if (clock_i='1' and clock_i'event) then
		cnt_down_meta <= e_counter_down;
		cnt_down <= cnt_down_meta;						-- cnt_down and cnt_down_p are used for the edge detection
		cnt_down_prev <= cnt_down;
	end if;
end process;



-- this process sends packed stored in the FIFO.
-- after sending last byte interpacket gap is generated (24 clock cycles)
send_pkt_from_fifo: process(eth_clock_i)
	variable e_temp : std_logic_vector(8 downto 0);
	variable first_flag : std_logic;
begin
	if (reset_n_i='0') then
		e_state <= IDLE;
		e_fifo_rden <= '0';
		e_counter_down <= '0';				
		e_dout_v <= '0';
		e_delay <= 0;
		e_nibble <= (others => '0');
		e_nibble_dv <= '0';		
		first_flag := '1';
	elsif (eth_clock_i='1' and eth_clock_i'event) then

		if (e_delay/=0) then
			e_delay <= e_delay - 1;
		else

			case (e_state) is
				
				when IDLE =>
					e_counter_down <= '0';
					if (e_packet_counter > 0) then
						e_delay <= 0;
						first_flag := '1';							-- flag to indicate first read from FIFO
						e_nibble_dv <= '0';
						e_state <= READ_FIFO0;
					end if;


				when READ_FIFO0 =>
					
					e_fifo_rden <= '1';	
					e_state <= READ_FIFO1;

					if (e_dout(8)='1' and first_flag='0') then		-- this is the last byte in the current packet
						e_fifo_rden <= '0';													-- no need to fetch next byte, which belongs to the next packet
					end if;

					if (first_flag='0') then
						e_temp := e_dout;
						e_nibble <= e_dout(3 downto 0);		-- LSB
						e_nibble_dv <= '1';
					end if;

				when READ_FIFO1 =>


					if (first_flag='1') then
						first_flag := '0';
						e_fifo_rden <= '0';
						e_state <= READ_FIFO0;
					else 
						e_nibble <= e_dout(7 downto 4);		-- MSB
						e_nibble_dv <= '1';
						e_fifo_rden <= '0';							
						e_state <= READ_FIFO0;

						if (e_dout(8)='1') then
							e_fifo_rden <= '0';
							e_counter_down <= '1';
							e_state <= WS1;
						end if;
					end if;
				

				when WS1 =>
					e_nibble_dv <= '0';
					e_counter_down <= '0';
					e_delay <= 24;						-- interpacket gap for fast ethernet is 960ns/40ns = 24 clock cycles
					e_state <= IDLE;

				when others =>
					e_state <= IDLE;
			
			end case;
		end if;
	end if;
end process;



fifo_din <= S_AXIS_TLAST_i & S_AXIS_TDATA_i;
fifo_wren <= S_AXIS_TVALID_i;
S_AXIS_TREADY_o <= not fifo_full;

-- flush fifo always
--s_fifo_rden <= not s_fifo_empty;

fifo_2048x9_i1 : fifo_2048x9
	port map (
    wr_clk 	=> clock_i, 			-- IN STD_LOGIC;
		rd_clk	=> eth_clock_i,
		rst => not reset_n_i,
    din 	=> fifo_din,							-- IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    wr_en => fifo_wren,						-- IN STD_LOGIC;
    rd_en => e_fifo_rden,							-- IN STD_LOGIC;
    dout 	=> e_dout,								-- OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
    full 	=> fifo_full,								-- OUT STD_LOGIC;
    empty => e_fifo_empty							-- OUT STD_LOGIC
  );


i_add_crc32: add_crc32 port map (
      clk             => eth_clock_i,
      data_in         => e_nibble,
      data_enable_in  => e_nibble_dv,
      data_out        => e_with_crc32,
      data_enable_out => e_with_crc32_dv);

i_add_preamble: add_preamble port map (
      clk             => eth_clock_i,
      data_in         => e_with_crc32,
      data_enable_in  => e_with_crc32_dv,
      data_out        => e_fullframe,
      data_enable_out => e_fullframe_dv);
      


end arch_imp;
