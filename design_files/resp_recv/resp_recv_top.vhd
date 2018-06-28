

       




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity response_recv is 
   port ( clk, rst : in std_logic;
          --mig interface
           app_rdy, app_rd_data_end,app_rd_data_valid, phy_init_done : in std_logic;
           app_rd_data : in std_logic_vector(63 downto 0);
           
           --response buffer interface denoted by index 3
             wreq3 : out std_logic;
             wack3 : in std_logic;
             wr_count3 : in integer range 0 to 9;
             wdata3 : out std_logic_vector(63 downto 0);
          --error interface 
             error_flag : out std_logic;
            --response end flag
               end_flag : out std_logic  
            
        );
end response_recv;

architecture arch of response_recv is
--mig data register
component mdr 
 port ( clk , rst, mdr_en: in std_logic;
        mdr_in: in std_logic_vector(63 downto 0);
        mdr_out: out std_logic_vector(63 downto 0)
      );
end component;

type state_type is (main, wait_on_count); 
signal state : state_type;

--mdr signals
signal mdr_in, mdr_out : std_logic_vector(63 downto 0);
signal mdr_en : std_logic;
signal valid_flag_down : std_logic :='0';

  begin

     dut_mdr : mdr port map(clk,rst, mdr_en, mdr_in,mdr_out);

       error_flag <= phy_init_done; end_flag <= app_rd_data_end;
       process(clk,rst)
         begin
             if (rst = '1') then
                 wdata3 <= "0000000000000000000000000000000000000000000000000000000000000000";
                 state <= main; wreq3 <= '0';
             else if (clk = '1' and clk 'event) then
                case state is
                 when main =>
                    if (app_rdy = '1' and app_rd_data_valid = '1' and wr_count3 < 9) then
                            wreq3 <= '1'; mdr_en <= '1'; mdr_in <= app_rd_data;
                      
                    end if; 
                     if (app_rd_data_valid = '0' ) then
                        --wreq3 <= '0'; 
                        --mdr_en <= '0';
                         valid_flag_down <= '1';
                     end if; 
                       if (valid_flag_down = '1') then
                           mdr_en <= '0';
                        end if;
                     if (mdr_en = '0') then
                       wreq3 <= '0';
                     end if; 

                    if (wack3 = '1' and wr_count3 <9 ) then
                        wdata3 <= mdr_out;

                    end if;

                    if (wr_count3 = 9) then
                        state <= wait_on_count;
                    end if;

                  when wait_on_count =>
                       if (wr_count3 < 9) then
                           state <= wait_on_count;
                       end if;

                  end case;
                end if;
              end if;
           end process;
  end arch; 
                   

               
