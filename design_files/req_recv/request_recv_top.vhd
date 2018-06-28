library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity req_recv_top is

port ( clk, rst: in std_logic;
       
         --ahir request interface
        ahir_request_req : in std_logic;
        ahir_request_ack : out std_logic;
        ahir_request_data: in std_logic_vector(63 downto 0);
       
        -- buffer interfaces 1 is for cmd_buf, 2 is for pend_buf
         wr_count1, wr_count2 : in integer range 0 to 9;
         wreq1, wreq2 : out std_logic;
         wack1, wack2 : in std_logic;
         wdata1, wdata2: out std_logic_vector(63 downto 0)
   
    );

end req_recv_top; 

architecture arch of req_recv_top is
 

--fifo 
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

--request receive 

component request_receive 
 port ( clk,rst: in std_logic;
        --ahir request interface
        ahir_request_req : in std_logic;
        ahir_request_ack : out std_logic;
        ahir_request_data: in std_logic_vector(63 downto 0);
       
      -- buffer interfaces 1 is for cmd_buf, 2 is for pend_buf
         wr_count1, wr_count2 : in integer range 0 to 9;
         wreq1, wreq2 : out std_logic;
         wack1, wack2 : in std_logic;
         wdata1, wdata2: out std_logic_vector(63 downto 0)
   
    );

end component;  

--buffer interface signals
signal wdata1_sig, wdata2_sig  : std_logic_vector(63 downto 0);
signal wreq1_sig, wreq2_sig, wack1_sig, wack2_sig: std_logic;
signal wr_count1_sig, wr_count2_sig :  integer range 0 to 9;

  begin
     dut_cmd_buf : fifo_write port map(clk, rst, wdata1_sig, wreq1_sig, wack1_sig, wr_count1_sig);
     dut_pend_buf: fifo_write port map(clk, rst, wdata2_sig, wreq2_sig, wack2_sig, wr_count2_sig);
     dut_req_recv: request_receive port map(clk,rst, ahir_request_req, ahir_request_ack, ahir_request_data,wr_count1_sig, wr_count2_sig, wreq1_sig, wreq2_sig, wack1_sig, wack2_sig, wdata1_sig, wdata2_sig);

end arch;
 






 

