library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity display_top_tb is
end display_top_tb;



architecture Behavioral of display_top_tb is

component display_top is
    Port ( clk      : in  STD_LOGIC;
           d_clk    : out  STD_LOGIC;
           d_strobe : out  STD_LOGIC;
           d_data   : out  STD_LOGIC;
           refresh  : in std_logic;
        dig7 : in std_logic_vector(7 downto 0);
        dig6 : in std_logic_vector(7 downto 0);
        dig5 : in std_logic_vector(7 downto 0);
        dig4 : in std_logic_vector(7 downto 0);
        dig3 : in std_logic_vector(7 downto 0);
        dig2 : in std_logic_vector(7 downto 0);
        dig1 : in std_logic_vector(7 downto 0);
        dig0 : in std_logic_vector(7 downto 0));
end component display_top;

signal clock : std_logic := '0';
signal refresh : std_logic := '0';

begin

clock <= not clock after 10 ns;

process
begin
    wait for 200 us;
    wait until rising_edge(clock);
    refresh <= '1';
    wait until rising_edge(clock);
    refresh <= '0';
    wait;
end process;




display_top_i1 : display_top
    Port map ( clk   => clock,
           d_clk   => open,
           d_strobe  => open,
           d_data    => open,
        refresh => refresh,
        dig7 => x"01",
        dig6  => x"01",
        dig5  => x"01",
        dig4  => x"01",
        dig3 => x"01",
        dig2  => x"01",
        dig1 => x"01",
        dig0  => x"01"
        );



end Behavioral;
