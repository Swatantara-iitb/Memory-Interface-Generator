 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity tb_top is
  end tb_top;


architecture test of tb_top is

   component top_read 
       port ( clk, rst : in std_logic;
               --user interface
              data_in : in std_logic_vector(63 downto 0);
             
             --mig interface 
             app_addr : out std_logic_vector(31 downto 0);
             app_cmd : out std_logic_vector(1 downto 0);
             app_en, app_wdf_data, app_wdf_end, app_wren : out std_logic;
             app_rd_data : in std_logic_vector(63 downto 0);
             phy_init_done : in std_logic_vector(0 downto 0);
             app_rdy, app_rd_data_end, app_rd_data_valid, app_wdf_full : in std_logic
           );
   end component;


   signal clk : std_logic :='0';
   signal rst, app_en, app_wdf_data, app_wdf_end, app_wren, app_rdy, app_rd_data_end, app_rd_data_valid, app_wdf_full :  std_logic;
   signal data_in, app_rd_data :  std_logic_vector(63 downto 0);
   signal app_addr :  std_logic_vector(31 downto 0); 
   signal app_cmd :  std_logic_vector(1 downto 0);
   signal phy_init_done : std_logic_vector(0 downto 0);

      begin
        dut : top_read port map(clk, rst, data_in, app_addr, app_cmd, app_en, app_wdf_data, app_wdf_end, app_wren, app_rd_data, phy_init_done,app_rdy, app_rd_data_end, app_rd_data_valid, app_wdf_full);

   clk <= not clk after 5 ns;
          process
             begin
                  rst <= '1'; data_in <= "0000000000001000000000000000000000000000000010000000000000000000";
                  wait for 10 ns;


                   rst <= '0'; 
                   app_rdy <= '1';
                  
                   app_rd_data_end <= '0';
                   app_rd_data_valid <= '0';
                   
                   wait for 35 ns;
                     app_rd_data_valid <= '1';
                  
                     app_rd_data <= "1100000000001000000000000000000000000000000011111111111111111111";
                 wait for 10 ns;

                  app_rd_data <= "0000000000001000000000000000000000000000000011111111111111111000";
                  wait for 10 ns;
   
              app_rd_data <= "0000000000001000000000000000000000000011000011111111111111111111";
              wait for 10 ns;

                app_rd_data <= "0110000000001000000000000000000000000000000011111111111111111111";
                 wait for 10 ns; 
                 
             app_rd_data <= "0001000100111000000000000000000000000000000011111111111111111111";
                   wait for 10 ns;

               app_rd_data <= "0001000000101110000000000000000000000000000011111111111111111111";
                   wait for 10 ns;
             
                app_rd_data <= "0001000100111110000000000000000000000000000011111111111111111111";
                   wait for 10 ns;

                 app_rd_data <= "0001000100111011000000000000000000000000000011111111111111111111";
                   wait for 10 ns;
                    app_rd_data_end <= '1'; phy_init_done <= "0";
                  wait for 20 ns;

                 
          wait;
  end process;
end test;
                  
                 
                   
                   

 







