library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity response_send is
  port ( clk,rst : in std_logic;
         
          --response buffer interface denoted by index 3
             rdreq3 : out std_logic;
             rdack3 : in std_logic;
             rdata3 : in std_logic_vector(63 downto 0);
             rd_count3: in integer range 0 to 9;
         
          --pending buffer denoted by index 2
            rdreq2 : out std_logic;
            rdack2 : in std_logic;
            rdata2 : in std_logic_vector(63 downto 0);
            rd_count2 : in integer range 0 to 9;
          
           --ahir response
              ahir_response_req : in std_logic;
              ahir_response_ack : out std_logic;
              ahir_response_data: out std_logic_vector(63 downto 0);

          -- mig module interface
              app_rd_data_end : in std_logic;

            --error interface
                 phy_init_done : in std_logic
     );
end response_send;


architecture arch of response_send is
type state_type is (main, resp_buf_read, wait_on_count);
signal state : state_type;

--command word parameters
signal cmd_check  : std_logic_vector(1 downto 0);
signal no_of_words  : integer range 0 to 8;
SIGNAL count_rd : INTEGER RANGE 0 TO 8 := 0;
signal rd_flag, wr_flag, admin_flag: integer range 0 to 1 := 0;

begin
    process(clk, rst)
       begin
          if (rst = '1') then
            ahir_response_data <= "0000000000000000000000000000000000000000000000000000000000000000";
            state <= main;

          else if (clk = '1' and clk 'event) then
                case state is
                  when main =>
                   
                       if (ahir_response_req = '1' and app_rd_data_end  = '1'  and rd_count2 > 0  ) then
                              rdreq2 <= '1';
                            
                       end if;
                        if (rdack2 = '1') then
                           -- form administrative word
                            ahir_response_data(63 downto 56) <= rdata2(63 downto 56); -- type of cmd
                            ahir_response_data(55 downto 53) <= rdata2(55 downto 53); -- no of words
                            ahir_response_data(52 downto 45) <= rdata2(52 downto 45); -- id
                            ahir_response_data(44) <= phy_init_done; -- error bits
                            ahir_response_data(43 downto 0) <= "00000000000000000000000000000000000000000000"; --unused bits

                              --count of words
                             no_of_words <= to_integer(unsigned (rdata2(55 downto 53))) ; 
                             cmd_check <= rdata2(63 downto 62);
                             ahir_response_ack <= '1'; admin_flag <= 1;
                          end if;

                            --read command
                             if (rdata2(63 downto 62) = "00") then
                                   rd_flag <= 1;
                             end if;
                           if (rd_flag = 1) then 
                                --wait on count
                                if ( (rd_count2 =0 or rd_count3=0) ) then
                                   state <= wait_on_count;
                                end if;
                            --request to read from response buffer
                              if (rd_count3 >0 and admin_flag = 1) then
                                 rdreq3 <= '1'; rdreq2 <= '0'; admin_flag <= 0; rd_flag <= 0;
                                 state <= resp_buf_read;
                              end if;
                             
                             -- if (rd_flag =1 and (rd_count2 =0 or rd_count3=0) ) then
                               --  state <= wait_on_count;
                              --end if;
                              --if (wr_flag =1 and rd_count2 =0 ) then
                                -- state <= wait_on_count;
                              --end if;
                          end if;
                          
                            --write command
                              if (rdata2(63 downto 62) = "01") then
                                   wr_flag <= 1; --
                             end if;
                              if (wr_flag = 1) then-- and rdack2 = '1') then
                                 if (rd_count2 = 0) then
                                    state <= wait_on_count;
                                 end if;
                                 if (rdack2 = '1' and rd_count2 >0) then
                                  ahir_response_ack <= '0'; wr_flag <= 0; admin_flag <= 0; rdreq2 <= '0';
                                 end if;  
                              end if; 
                  when resp_buf_read =>
                         if (rdack3 = '1' and rd_count3 > 0) then
                              if (count_rd <= (no_of_words + 1) ) then
                                  ahir_response_data <= rdata3;
                                  count_rd <= count_rd + 1;
                              else rdreq3 <= '0'; rd_flag <= 0; ahir_response_ack <='0'; state <= main; 
                              end if;
                         end if;
                  when wait_on_count =>
                        if (rd_flag = 1 and rd_count2 >0 and rd_count3 >0 ) then
                               state <= main;
                        end if; 
                        if (wr_flag = 1 and rd_count2 >0  ) then
                               state <= main;
                        end if; 

                 end case;
             end if;
           end if;
   end process;
end arch;   





                              




                           


  
 
                        
                  









 

















             
      

