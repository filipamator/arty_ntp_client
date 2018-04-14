 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : uart_mux.vhd
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
 use IEEE.numeric_std.all;
 
 entity uart_mux is
    Port ( 
            clock_i     : in std_logic;
            select_i    : in std_logic_vector(1 downto 0);
            UART1_i     : in std_logic;
            UART2_i     : in std_logic;
            UART3_i     : in std_logic;
            UART4_i     : in std_logic;
            UART_o      : out std_logic
    );
 end uart_mux;
 
 architecture rtl of uart_mux is

 begin

process(clock_i)
begin
    if (clock_i='1' and clock_i'event) then
        case (select_i) is
            when "00" =>
                UART_o <= UART1_i;
            when "01" =>
                UART_o <= UART2_i;
            when "10" =>
                UART_o <= UART3_i;
            when "11" =>
                UART_o <= UART4_i;
            when others =>
                UART_o <= '1';
        end case;
    end if;
end process;
end rtl;