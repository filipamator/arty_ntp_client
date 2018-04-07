 -------------------------------------------------------------------------------
 -- Title : NTP client
 -- Project : 
 -------------------------------------------------------------------------------
 -- File : axis_master.vhd
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

entity axis_master is
	generic (
		DELAY		: natural;
		BASE		: unsigned(7 downto 0)
	);
	port (
		clock_i	    : in std_logic;
		reset_n_i	: in std_logic;
		req_o		: out std_logic;
		grant_i		: in std_logic;
		M_AXIS_TVALID_o	    : out std_logic;
		M_AXIS_TDATA_o	    : out std_logic_vector(7 downto 0);
		M_AXIS_TLAST_o	    : out std_logic;
		M_AXIS_TREADY_i	    : in std_logic
	);
end axis_master;

architecture implementation of axis_master is
                                                                  
                           
	type state is ( IDLE, INIT_COUNTER, SEND_REQ, SEND_STREAM);                           
                                                                
	signal  mst_exec_state : state;       

	signal counter	: integer := 0;
	signal data_counter	: integer := 0;
	

begin

                                            
	process(clock_i)                                                                        
	begin                                                                                       
        if (reset_n_i='0') then
            counter <= 0;
            M_AXIS_TVALID_o <= '0';
            M_AXIS_TLAST_o <= '0';
            M_AXIS_TDATA_o <= (others => '0');
			data_counter <= 0;
			req_o <= '0';
            mst_exec_state <= IDLE;     
	    elsif (rising_edge (clock_i)) then                                                       
	                                                                                                                                            
	      case (mst_exec_state) is                                                              
	        when IDLE     =>
				M_AXIS_TLAST_o <= '0';
                M_AXIS_TVALID_o <= '0';                                                                                                      
	            mst_exec_state <= INIT_COUNTER;                                                                                                                                                                                         
	        when INIT_COUNTER =>                                                              
	            if (counter = DELAY) then
					counter <= 0;
					req_o <= '1';
	                mst_exec_state  <= SEND_REQ;                                               
	            else                                                                            
                    counter <= counter + 1;
	                mst_exec_state  <= INIT_COUNTER;                                              
	            end if;                                                                         

			when SEND_REQ =>


				if (grant_i='1') then
					M_AXIS_TVALID_o <= '1';
                    M_AXIS_TDATA_o <= std_logic_vector(to_unsigned(data_counter+3, 8)+BASE);
					data_counter <= 1;
					mst_exec_state <= SEND_STREAM;
				else 
					mst_exec_state <= SEND_REQ;
				end if;


	        when SEND_STREAM  =>      

		
				-- previous byte was send over bus
				if (M_AXIS_TREADY_i='1') then
					
					M_AXIS_TDATA_o <= std_logic_vector(to_unsigned(data_counter+3, 8)+BASE);
                    data_counter <= data_counter + 1;

					if (data_counter=7) then
						M_AXIS_TLAST_o <= '1';
					end if;

					if (data_counter=8) then
						M_AXIS_TDATA_o <= (others => '0');
						M_AXIS_TLAST_o <= '0';
						data_counter <= 0;
						M_AXIS_TVALID_o <= '0';
						req_o <= '0';
						mst_exec_state <= IDLE;
					end if;



				end if;


	                                                                                            
	        when others    =>                                                                   
	          mst_exec_state <= IDLE;                                                           
	                                                                                            
	      end case;                                                                             
                                                                             
	  end if;                                                                                   
	end process;                                                                                


end implementation;
