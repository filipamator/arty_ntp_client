library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package crc_pkg is
    CONSTANT CRC_POLY : unsigned(31 DOWNTO 0) := x"04C11DB7";
    TYPE t_arr_byte IS ARRAY(natural RANGE <>) OF unsigned(7 DOWNTO 0);
    FUNCTION crc (data : t_arr_byte) RETURN t_arr_byte;
end;

package body crc_pkg is
    -- -- Source: https://electronics.stackexchange.com/questions/170612/fcs-verification-of-ethernet-frame
    FUNCTION crc (data : t_arr_byte) RETURN t_arr_byte IS
        VARIABLE r  : t_arr_byte(0 TO 3) := (x"00",x"00",x"00",x"00");
        VARIABLE c  : unsigned(31 DOWNTO 0) :=x"FFFFFFFF";
        VARIABLE mm : unsigned(31 DOWNTO 0);
    BEGIN
        FOR I IN data'range LOOP
            FOR J IN 0 TO 7 LOOP
                mm:=(OTHERS => data(I)(J) XOR c(31));
                c:=(c(30 DOWNTO 0) & '0') XOR (mm AND CRC_POLY);
            END LOOP;
        END LOOP;

        FOR I IN 0 TO 31 LOOP
            mm(I):=NOT c(31-I);
        END LOOP;

        r(3):=mm(31 DOWNTO 24);
        r(2):=mm(23 DOWNTO 16);
        r(1):=mm(15 DOWNTO  8);
        r(0):=mm( 7 DOWNTO  0);
        RETURN r;
    END FUNCTION crc;
end package body;