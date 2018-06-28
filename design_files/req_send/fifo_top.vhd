

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity fifo_top is 
    port ( clk, rst : in std_logic;
            --write interface
              wdata : in std_logic_vector(63 downto 0);
              wreq : in std_logic; 
              wack : out std_logic;
           -- read interface
           rdata : out std_logic_vector(63 downto 0);
           rdreq : in std_logic;
           rdack : out std_logic;
           --counts
           wr_count_out, rd_count_out :out  integer range 0 to 9   
           );
end fifo_top;

architecture fifo_arch of fifo_top is

component fifo_read  
    port ( clk, rst : in std_logic;
            
           -- read interface
           rdata : out std_logic_vector(63 downto 0);
           rdreq : in std_logic;
           rdack : out std_logic;
           --counts
          rd_count_out :out  integer range 0 to 9   
           );
end component;


component fifo_write  
    port ( clk, rst : in std_logic;
            --write interface
              wdata : in std_logic_vector(63 downto 0);
              wreq : in std_logic; 
              wack : out std_logic;
           
           --counts
           wr_count_out :out  integer range 0 to 9   
           );
end component;

  begin
    dut1 : fifo_read port map(clk,rst, rdata,rdreq,rdack,rd_count_out);
    dut2 : fifo_write port map(clk,rst, wdata,wreq,wack,wr_count_out);
    end fifo_arch;                   
     


   
       











 

  





  


 
              
                    

 
                       
