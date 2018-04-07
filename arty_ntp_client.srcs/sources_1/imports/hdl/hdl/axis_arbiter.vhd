 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : axis_arbiter.vhd
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

entity axis_arbiter is
	port (
		clock_i	    		: in std_logic;
		reset_n_i			: in std_logic;
		req_i				: in std_logic_vector(3 downto 0);
		grant00_o			: out std_logic;
		grant01_o			: out std_logic;
		grant02_o			: out std_logic;
		grant03_o			: out std_logic	
	);
end axis_arbiter;

architecture implementation of axis_arbiter is
                                                                  
                           
	type state is (IDLE, RUN);              
	                                                                  
	signal  ST : state;       

	signal counter		: integer := 0;
	signal data_counter	: integer := 0;
	signal busy			: std_logic;
	signal master		: integer range 0 to 3;

begin

                                            
	process(clock_i)                                                                        
	begin                                                                                       
        if (reset_n_i='0') then
			ST <= IDLE;
			master <= 0;
			busy <= '0';
			grant00_o <= '0';
			grant01_o <= '0';
			grant02_o <= '0';
			grant03_o <= '0';	
	    elsif (rising_edge (clock_i)) then                                                       	                                                                                                                                            
	      case (ST) is
		  	when IDLE =>
				if (req_i(0)='1') then
					master <= 0;
					grant00_o <= '1';
					ST <= RUN;
				elsif (req_i(1)='1') then
					master <= 1;
					grant01_o <= '1';
					ST <= RUN;				
				elsif (req_i(2)='1') then
					master <= 2;
					grant02_o <= '1';
					ST <= RUN;				
				elsif (req_i(3)='1') then
					master <= 3;
					grant03_o <= '1';
					ST <= RUN;				
				end if;
			
			when RUN =>
				if (req_i(master)='1') then
					ST <= RUN;
				else 
					grant00_o <= '0';
					grant01_o <= '0';
					grant02_o <= '0';
					grant03_o <= '0';					
					ST <= IDLE;
				end if; 
	                                                                                 
	      end case;                                                                                                                                      
	  end if;                                                                                   
	end process;                                                                                


end implementation;
