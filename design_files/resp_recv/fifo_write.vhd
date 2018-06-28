library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity fifo_write is 
    port ( clk, rst : in std_logic;
            --write interface
              wdata : in std_logic_vector(63 downto 0);
              wreq : in std_logic; 
              wack : out std_logic;
           
           --counts
           wr_count_out :out  integer range 0 to 9   
           );
end fifo_write;

architecture fifo_arch of fifo_write is

type out_array is array(0 to 8)  of std_logic_vector(63 downto 0);
signal buf_data : out_array;
signal wr_count: integer range 0 to 9 := 0;


   begin
        wr_count_out <= wr_count; 

       process(clk, rst)
          begin
               if (rst = '1') then
                  for i in 0 to 8 loop
                    buf_data(i) <= "0000000000000000000000000000000000000000000000000000000000000000";
                  end loop;
              else if (clk ='1' and clk 'event) then
                   if (wreq = '1' and wr_count < 9) then
                       wack <= '1';
                       buf_data(8 - wr_count) <= wdata; 
                       wr_count <= wr_count + 1;
                       
                    end if;
                   if (wreq ='0' ) then
                        wack <= '0';
                   end if;
                 

               end if;
             end if;
         end process;
 end fifo_arch;


                  
     
