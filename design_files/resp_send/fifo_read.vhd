library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity fifo_read is 
    port ( clk, rst : in std_logic;
            
           -- read interface
           rdata : out std_logic_vector(63 downto 0);
           rdreq : in std_logic;
           rdack : out std_logic;
           --counts
          rd_count_out :out  integer range 0 to 9   
           );
end fifo_read;


architecture fifo_arch of fifo_read is

type out_array is array(0 to 8)  of std_logic_vector(63 downto 0);
signal buf_data : out_array;
signal rd_count: integer range 0 to 9 := 9;

   begin
         rd_count_out <= rd_count;

       process(clk, rst)
          begin
               if (rst = '1') then
                  for i in 0 to 8 loop
                    buf_data(i) <= "0000000000000000000000000000000000000000000000000000000000000000";
                  end loop;
              else if (clk ='1' and clk 'event) then
                   if (rdreq = '1' and rd_count > 0) then 
                      rdack <= '1';
                      
                      rdata <= buf_data(rd_count - 1);
                      rd_count <= rd_count - 1; 
                  end if;
                   if (rdreq = '0' ) then
                        rdack <= '0';
                   end if;

               end if;
             end if;
         end process;
 end fifo_arch;

