

  library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
 
entity ahir_read is
    port ( clk, rst : in std_logic;
            --user interface
              data_in : in std_logic_vector(63 downto 0);
              --done : out std_logic; 
           -- bridge-request interface
           out_data_pipe_write_data : out std_logic_vector(63 downto 0);
           out_data_pipe_write_ack : in std_logic;
           out_data_pipe_write_req : out std_logic;
         
           --bridge-response interface
            in_data_pipe_read_req : out std_logic;
            in_data_pipe_read_ack : in std_logic;
            in_data_pipe_read_data : in std_logic_vector(63 downto 0)
                                              );
    end ahir_read;
 
architecture Behavioral of ahir_read is
        type state_type is (start, write_req,  wait_for_response, response_received);
        signal state : state_type;
        signal done : std_logic :='0';
        SIGNAL count : INTEGER RANGE 0 TO 8 := 0;
    begin
 
         process(state, clk, rst, data_in, out_data_pipe_write_ack, in_data_pipe_read_ack, in_data_pipe_read_data )
            begin
                  if (clk 'event and clk='1') then
                     if (rst = '1') then
                        state <= start;
                     else case state is
                        when start => 
                           
                           state <=  write_req;

                        when write_req =>
                            out_data_pipe_write_data <= data_in;
                            out_data_pipe_write_req <= '1';
                            in_data_pipe_read_req <= '1';
                            state <= wait_for_response; 
                          
                      when wait_for_response =>
                           if (out_data_pipe_write_ack = '1') then
                                out_data_pipe_write_req <= '0';
                           end if;
                           if ( in_data_pipe_read_ack = '1') then
                                 in_data_pipe_read_req <= '0';  
                               state <= response_received;
                           end if;
                      when response_received =>
                             if (count < to_integer( unsigned(data_in(55 downto 48)) ) ) then
                                 count <= count + 1;
                             else done <= '1';
                                  state <= start;
                             end if;
                          end case;
                         end if;
                        end if;
                     end process;
           end  Behavioral;
                                     
                              
                            


 


                      

                           
                   
               
 

