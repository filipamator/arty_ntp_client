----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Module Name:    design_top - Behavioral 
-- Description: Top level for testing the DX display
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_top is
    generic (
            REFRESH_RATE : natural := 2_500_000        -- 0.05sec.
    );
    port (  clk      : in  STD_LOGIC;
            d_clk    : out  STD_LOGIC;
            d_strobe : out  STD_LOGIC;
            d_data   : out  STD_LOGIC;
            dig7 : in std_logic_vector(7 downto 0);
            dig6 : in std_logic_vector(7 downto 0);
            dig5 : in std_logic_vector(7 downto 0);
            dig4 : in std_logic_vector(7 downto 0);
            dig3 : in std_logic_vector(7 downto 0);
            dig2 : in std_logic_vector(7 downto 0);
            dig1 : in std_logic_vector(7 downto 0);
            dig0 : in std_logic_vector(7 downto 0);
            indicator0 : in std_logic_vector(1 downto 0);
            indicator1 : in std_logic_vector(1 downto 0)            
        );
end display_top;

architecture Behavioral of display_top is

    COMPONENT dx_display
        PORT(
            clk     : IN std_logic;
            reset   : IN std_logic;
            adv     : IN std_logic;          
            byte    : OUT std_logic_vector(7 downto 0);
            endCmd  : OUT std_logic;
            newData : OUT std_logic;
            refresh : in STD_LOGIC;
            dig7 : in std_logic_vector(7 downto 0);
            dig6 : in std_logic_vector(7 downto 0);
            dig5 : in std_logic_vector(7 downto 0);
            dig4 : in std_logic_vector(7 downto 0);
            dig3 : in std_logic_vector(7 downto 0);
            dig2 : in std_logic_vector(7 downto 0);
            dig1 : in std_logic_vector(7 downto 0);
            dig0 : in std_logic_vector(7 downto 0);
            indicator0 : in std_logic_vector(1 downto 0);
            indicator1 : in std_logic_vector(1 downto 0);
            indicator2 : in std_logic_vector(1 downto 0);
            indicator3 : in std_logic_vector(1 downto 0);
            indicator4 : in std_logic_vector(1 downto 0);
            indicator5 : in std_logic_vector(1 downto 0);
            indicator6 : in std_logic_vector(1 downto 0);
            indicator7 : in std_logic_vector(1 downto 0)
        );
    END COMPONENT;
   
    COMPONENT dx_display_xmit
        PORT(
            clk      : IN std_logic;
            reset    : IN std_logic;
            byte     : IN std_logic_vector(7 downto 0);
            endCmd   : IN std_logic;
            newData  : IN std_logic;
            d_strobe : OUT std_logic;
            d_clk    : OUT std_logic;
            d_data   : OUT std_logic;          
            adv      : OUT std_logic
        );
    END COMPONENT;

    signal byte     : std_logic_vector(7 downto 0);
    signal endCmd   : std_logic;
    signal newData  : std_logic;
    signal adv      : std_logic;
    signal reset    : std_logic;
    signal resetShift : std_logic_vector(15 downto 0) := (others =>'1');
    signal local_refresh : std_logic := '0';
    signal counter   : integer := 0;
   
begin

    process(clk,reset)
    begin
        if (reset='1') then
            counter <= 0;
            local_refresh <= '0';
        elsif (clk='1'and clk'event) then
            if (counter = REFRESH_RATE) then
                local_refresh <= '1';
                counter <= 0;
            else
                local_refresh <= '0';
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    
    

    Inst_dx_display: dx_display PORT MAP(
        clk     => clk,
        reset    => reset,
        byte    => byte,
        endCmd  => endCmd,
        newData => newData,
        refresh => local_refresh,
        adv      => adv,
        dig0     => dig0,
        dig1     => dig1,
        dig2     => dig2,
        dig3     => dig3,
        dig4     => dig4,
        dig5     => dig5,
        dig6     => dig6,
        dig7     => dig7,
        indicator0 => indicator0,
        indicator1 => indicator1,
        indicator2 => "00",
        indicator3 => "00",
        indicator4 => "00",
        indicator5 => "00",
        indicator6 => "00",
        indicator7 => "00"
    );

    Inst_dx_display_xmit: dx_display_xmit PORT MAP(
        clk       => clk,
        reset    => reset,
        byte       => byte,
        endCmd    => endCmd,
        newData    => newData,
        adv       => adv,
        d_strobe => d_strobe,
        d_clk    => d_clk,
        d_data    => d_data 
   );


reset <= resetShift(0);
	
reset_proc: process(clk)
    begin
        if rising_edge(clk) then
            resetShift <= '0' & resetShift(15 downto 1);
        end if;
    end process;
end Behavioral;