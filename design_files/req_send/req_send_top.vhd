library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity request_send is
  port ( clk,rst : in std_logic;
         -- cmd buffer interface
           rdreq : out std_logic;
           rdack : in std_logic;
           rdata : in std_logic_vector(63 downto 0);
           rd_count: in integer range 0 to 9;
           
            --mig interface
            app_cmd : out std_logic_vector(1 downto 0);
            app_en: out std_logic;
            app_addr: out std_logic_vector(31 downto 0);
            app_wdf_data : out std_logic_vector(63 downto 0);
            app_sz : out std_logic_vector(2 downto 0);
            app_wdf_rdy : in std_logic;
            app_wdf_end, app_wdf_wren : out std_logic
     );
end request_send;

architecture arch of request_send is
  type state_type is (main, wait_on_count);
   signal state: state_type;
   
-- command word parameters
signal cmd_check  : std_logic_vector(1 downto 0);
signal no_of_words  : integer range 0 to 8;
SIGNAL count_wr : INTEGER RANGE 0 TO 8 := 0;
signal rd_flag, wr_flag: integer range 0 to 1 := 0;


    begin
      process(clk,rst)
       begin
        if (rst='1') then
           app_cmd <= "11";
           app_en <= '0';
           app_wdf_wren <= '0';
           state <= main;
        else if ( clk = '1' and clk 'event) then
              case state is 
                when main =>
                  rdreq <= '1'; app_en <= '0'; app_wdf_wren <= '0'; app_cmd <= "11";
                  
                  if ( rd_count > 0 and rdack = '1' ) then
                      cmd_check <= rdata(63 downto 62);   
                      no_of_words <= to_integer(unsigned (rdata(55 downto 53))) ;
                      app_sz <= rdata(55 downto 53);
                      -- read command 
                       if ( rdata(63 downto 62) = "00") then
                              rd_flag <= 1;
                       end if;
 
                       if ( rd_flag = 1) then
                          
                          app_cmd <= "00";
                          app_en <= '1';
                          app_addr <= rdata(44 downto 13); 
                          rdreq <= '0'; 
                       end if;
                    
                       -- write command
                       if ( rdata(63 downto 62) = "01") then
                              wr_flag <= 1;
                       end if;
                       
                       if (wr_flag = 1 and app_wdf_rdy <= '0') then
                           app_cmd <= "01"; app_en <= '1'; app_wdf_wren <= '1';  app_addr <= rdata(44 downto 13);
                           if ( rd_count > 0 and rdack = '1' and count_wr <= (no_of_words + 1) ) then
                               app_wdf_data <= rdata;
                               count_wr <= count_wr + 1;
                            end if;   
                                if ( count_wr > (no_of_words + 1 ) ) then
                                   app_wdf_end <= '1'; rdreq <= '0';
                                end if;
                           
                        end if;
                       
                       end if;
                     if (rd_count = 0) then
                         state <= wait_on_count;
                     end if;

                     when wait_on_count =>
                         if (rd_count > 0)  then
                            state <= main;
                         end if;
                    end case;
                  end if;
                end if;
           end process;
end arch; 
 

            
                                




   
