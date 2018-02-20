library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
 

   entity top_read is
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
   end top_read;


architecture arch of top_read is
      component bridge_read 
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
               -- bridge-ahir system flags
                        
          --mig interface 
             app_addr : out std_logic_vector(31 downto 0);
             app_cmd : out std_logic_vector(1 downto 0);
             app_en, app_wdf_data, app_wdf_end, app_wren : out std_logic;
             app_rd_data : in std_logic_vector(63 downto 0);
             phy_init_done : in std_logic_vector(0 downto 0);
             app_rdy, app_rd_data_end, app_rd_data_valid, app_wdf_full : in std_logic
           );
    end component;


   component ahir_read 
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
    end component;
-- ahir interface signals
        signal   out_data_pipe_write_ack, in_data_pipe_read_ack, out_data_pipe_write_req, in_data_pipe_read_req : std_logic;
        signal out_data_pipe_write_data,in_data_pipe_read_data : std_logic_vector(63 downto 0);

       begin



            ahir_dut : ahir_read port map( clk, rst, data_in, out_data_pipe_write_data, out_data_pipe_write_ack,out_data_pipe_write_req,in_data_pipe_read_req,in_data_pipe_read_ack,in_data_pipe_read_data);


           bridge_dut : bridge_read port map ( clk, rst, out_data_pipe_write_data, out_data_pipe_write_ack,  out_data_pipe_write_req,  in_data_pipe_read_req, in_data_pipe_read_ack, in_data_pipe_read_data, app_addr, app_cmd , app_en, app_wdf_data, app_wdf_end, app_wren, app_rd_data, phy_init_done, app_rdy, app_rd_data_end, app_rd_data_valid, app_wdf_full);



          end arch;
