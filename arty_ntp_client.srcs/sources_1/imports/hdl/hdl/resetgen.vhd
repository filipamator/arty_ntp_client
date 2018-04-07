 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : resetgen.vhd
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


ENTITY resetgen IS
GENERIC (
    RESET_COUNTER : natural := 10
);
PORT (
    clock_i         : in std_logic;
    reset_n_o       : out std_logic := '0'
);
END ENTITY resetgen;

ARCHITECTURE rtl OF resetgen IS

signal counter  : integer := 0;

BEGIN

process(clock_i)
BEGIN

    if (clock_i='1' and clock_i'event) then
        if (counter < RESET_COUNTER) then
            counter <= counter + 1;
        else 
            reset_n_o <= '1';
        end if; 
    end if;

END process;

END ARCHITECTURE rtl;