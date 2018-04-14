 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : uartdump.vhd
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

ENTITY uartdump IS
PORT (
    clock_i     : in std_logic;
    reset_n     : in std_logic;
    data_i      : in std_logic_vector(7 downto 0);
    data_en_i   : in std_logic;
    uart_tx_o     : out std_logic
);
END ENTITY uartdump;


ARCHITECTURE rtl OF uartdump IS

    component fifo_2048x8 is
        port ( 
            rst : in STD_LOGIC;
            wr_clk : in STD_LOGIC;
            rd_clk : in STD_LOGIC;
            din : in STD_LOGIC_VECTOR ( 7 downto 0 );
            wr_en : in STD_LOGIC;
            rd_en : in STD_LOGIC;
            dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
            full : out STD_LOGIC;
            empty : out STD_LOGIC);
    end component fifo_2048x8;

    component UART_TX is
    generic (
        g_CLKS_PER_BIT : integer := 115     -- Needs to be set correctly
        );
    port (
        i_Clk       : in  std_logic;
        i_TX_DV     : in  std_logic;
        i_TX_Byte   : in  std_logic_vector(7 downto 0);
        o_TX_Active : out std_logic;
        o_TX_Serial : out std_logic;
        o_TX_Done   : out std_logic);
    end component UART_TX;


signal byte_counter : integer range 0 to 2047;

type t_ST is (ST_IDLE, ST_READ,ST_WAIT1,ST_WAIT2);
signal ST : t_ST := ST_IDLE;


signal rd_en            : std_logic := '0';
signal full,empty       : std_logic;
signal dout             : std_logic_vector(7 downto 0);
signal delay            : integer := 0;
signal TX_DV,TX_Done,TX_Active : std_logic;

BEGIN

process(clock_i,reset_n)

begin
    if (reset_n='0') then
        ST <= ST_IDLE;
        delay <= 0;
        TX_DV <= '0';


    elsif (clock_i='1' and clock_i'event) then
        
        if (delay /= 0) then
            delay <= delay - 1;
        else
        
            case (ST) is 
                
                when ST_IDLE =>

                    if (empty='0') then
                        rd_en <= '1';
                        ST <= ST_WAIT1;
                    end if;      

                when ST_WAIT1 =>
                    rd_en <= '0';
                    ST <= ST_READ;       
                    
                when ST_READ =>                 
                    
                    TX_DV <= '1';
                    ST <= ST_WAIT2;

                when ST_WAIT2 =>

                    TX_DV <= '0';
                    if (TX_Done='1') then
                        delay <= 800;
                        ST <= ST_IDLE;
                    else
                        ST <= ST_WAIT2;
                    end if;

            end case;

        end if;
    end if;
end process;





    fifo_2048x8_i1 : fifo_2048x8
        port map( 
            rst => not reset_n,
            wr_clk => clock_i,
            rd_clk => clock_i,
            din  => data_i,
            wr_en => data_en_i,
            rd_en => rd_en,
            dout  => dout,
            full => full,
            empty => empty);

    UART_TX_i1 : UART_TX
    generic map (
        g_CLKS_PER_BIT => 54 -- 434 = 115200 at 50 MHz
        )
    port map (
        i_Clk       => clock_i,
        i_TX_DV     => TX_DV,
        i_TX_Byte   => dout,
        o_TX_Active => TX_Active,
        o_TX_Serial => uart_tx_o,
        o_TX_Done   => TX_Done);

---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

END ARCHITECTURE rtl;
