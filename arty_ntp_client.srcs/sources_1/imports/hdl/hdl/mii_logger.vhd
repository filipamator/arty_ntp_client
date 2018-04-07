 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : mii_logger.vhd
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

ENTITY mii_logger IS
GENERIC (
    FILENAME    : string
);
PORT (
    clock       : in std_logic;
    reset_n     : in std_logic;
    eth_in_d    : in STD_LOGIC_VECTOR (3 downto 0);
    eth_in_en   : in STD_LOGIC
);
END ENTITY mii_logger;

ARCHITECTURE rtl OF mii_logger IS


signal eth_in_en_prev   : std_logic;
signal nibble           : std_logic := '0';
signal timestamp        : time := 0 ns;
signal localclock       : std_logic := '1';

BEGIN


    
    -- local clock generator - it is used for timestamping incoming packets.
    -- resolution is 1 ns /1 GHz clock/
    localclockgen : process
    begin
        localclock <= not localclock;
        wait for 0.5 ns;
    end process;


    -- update timestamp counter 
    timestampgen : process (localclock)
    begin 
        if (localclock='1' and localclock'event) then
            timestamp <= timestamp + 1 ns;
        end if;
    end process;



    receiver : process (clock, reset_n)
        --constant  FILENAME : string := "mii_logger.txt";
        file      outfile  : text is out FILENAME;  --declare output file
        variable  outline  : line;   --line number declaration  
        variable  rx_byte  : std_logic_vector(7 downto 0) := (others => '0');
        variable  packet    : t_arr_byte(0 to 2047);
        variable  byte_counter : integer := 0;
        variable  starttime : time;
    BEGIN
        if (reset_n='0') then
        elsif (clock='1' and clock'event) then
            eth_in_en_prev <= eth_in_en;
            if (eth_in_en_prev='0' and eth_in_en='1') then
                --write(outline, string'("Beginning of the packet"));
                --writeline(outfile, outline);
                starttime := timestamp;
                rx_byte(3 downto 0) := eth_in_d;
                nibble <= '1';
                byte_counter := 0;
            elsif (eth_in_en_prev='1' and eth_in_en='0') then
                --write(outline, string'("End of the packet"));
                --writeline(outfile, outline);


                write(outline, string'("New packet at: "));
                write(outline,starttime);
                writeline(outfile, outline);
                write(outline, string'("-------------------------------------------------"));
                writeline(outfile, outline);


                for I in 1 to byte_counter loop

                    hwrite(outline, packet(I-1), right, 3);

                    if ((I mod 16 = 0) and (I > 1) ) then
                        writeline(outfile, outline);
                    end if;

                end loop;

                writeline(outfile, outline);
                write(outline, string'("-------------------------------------------------"));
                writeline(outfile, outline);

            elsif (eth_in_en_prev='1' and eth_in_en='1') then
                if (nibble='1') then
                    rx_byte(7 downto 4) := eth_in_d;
                    nibble <= '0';
                    --hwrite(outline, rx_byte, right, 6);
                    --writeline(outfile, outline);
                    packet(byte_counter) := unsigned ( rx_byte );
                    byte_counter := byte_counter + 1;
                else 
                    rx_byte(3 downto 0) := eth_in_d;
                    nibble <= '1';
                end if;
            end if;
        end if;
    end process receiver;

-------------------------------------------------------------------


END ARCHITECTURE rtl;
