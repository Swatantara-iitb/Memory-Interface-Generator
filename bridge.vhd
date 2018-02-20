  library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
 

entity bridge_read is
   port ( clk, rst : in std_logic;
          -- ahir system interface
              -- bridge-request interface
           out_data_pipe_write_data : in std_logic_vector(63 downto 0);
           out_data_pipe_write_ack : out std_logic;
           out_data_pipe_write_req : in std_logic;

              --bridge-response interface
            in_data_pipe_read_req : in std_logic;
            in_data_pipe_read_ack : out std_logic;
            in_data_pipe_read_data : out std_logic_vector(63 downto 0);
              
                        
          --mig interface 
             app_addr : out std_logic_vector(31 downto 0);
             app_cmd : out std_logic_vector(1 downto 0);
             app_en, app_wdf_data, app_wdf_end, app_wren : out std_logic;
             app_rd_data : in std_logic_vector(63 downto 0);
             phy_init_done : in std_logic_vector(0 downto 0);
             app_rdy, app_rd_data_end, app_rd_data_valid, app_wdf_full : in std_logic
           );
    end bridge_read;


architecture arch of bridge_read is
      type state_type is (start, read_req,  read_data_state , done_state);
        signal state : state_type;
        signal done : std_logic :='0';
        SIGNAL count_words, count_rdy, count_valid : INTEGER RANGE 0 TO 8 := 0; 

        begin
           process(clk, rst, out_data_pipe_write_data, out_data_pipe_write_req, in_data_pipe_read_req, app_rdy, app_rd_data_end, app_rd_data_valid,app_wdf_full, phy_init_done)
               begin
                    if (clk 'event and clk='1') then
                       if (rst = '1') then 
                          state <= start;
                        else case state is
                           when start =>
                              if (out_data_pipe_write_req = '1') then
                                 state <= read_req;
                              end if;
                           when read_req =>
                            -- read command
                             if ( out_data_pipe_write_data(63 downto 56) = "00000000") then
                                 app_cmd <= "00";
                                 app_addr <= out_data_pipe_write_data(47 downto 16);
                                 app_en <= '1';
                                  if ( app_rdy = '1' ) then
                                      state <= read_data_state;
                                  else if (count_rdy < 4 ) then 
                                     count_rdy <= count_rdy +1 ;
                                       else state <= start; done <= 'X';  -- timeout case after 4 cycles
                                       end if;
                                   end if;
                               end if ;

                          when read_data_state =>
                             out_data_pipe_write_ack <= '1';
                                 if (app_rd_data_end = '0' and app_rd_data_valid = '1') then
                                         in_data_pipe_read_ack <= '1';
                                      if (count_words < to_integer( unsigned(out_data_pipe_write_data(55 downto 48)) ) ) then
                                        in_data_pipe_read_data <= app_rd_data;
                                         count_words <= count_words + 1; 
                                       end if;
                                  end if;

                                -- if (app_rd_data_valid = '0') then 
                                  --      if (count_valid < 3) then
                                    --       count_valid <= count_valid + 1;
                                    
                                      --  else state <= start; done <= 'U';  -- timeout case after 3 cycles
                                       -- end if;
                                 --end if;

                                if (app_rd_data_end = '1') then
                                          state <= done_state;
                                      
                               end if;
                         when done_state =>

                            in_data_pipe_read_data(63 downto 56) <= out_data_pipe_write_data (63 downto 56); --type of command
                            in_data_pipe_read_data(55 downto 48) <= out_data_pipe_write_data(15 downto 8); --id
                            in_data_pipe_read_data(47 downto 47) <= phy_init_done; --error bit from mig
                            in_data_pipe_read_data(46 downto 40) <= "0000000"; -- unused bits
                            in_data_pipe_read_data(39 downto 32) <= out_data_pipe_write_data(55 downto 48);
                            in_data_pipe_read_data(31 downto 0) <= "00000000000000000000000000000000";
                  
                               done <= '1';
                              state <= start;
                          
                       end case;
                      end if;
                     end if;
                   end process;
      end arch;
  



                                    










 
