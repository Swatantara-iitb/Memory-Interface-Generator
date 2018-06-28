library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;


entity adr is
  port (clk, rst, adr_en : in std_logic;
        adr_in : in std_logic_vector(63 downto 0);
        adr_out: out std_logic_vector(63 downto 0)
       );

end adr;

architecture adr_arch of adr is
 begin
    process(clk,rst)
     begin
       if (rst= '1') then
          adr_out <= "0000000000000000000000000000000000000000000000000000000000000000";
       else if (clk ='1' and clk 'event and adr_en = '1') then
                adr_out <= adr_in;
            end if;
       end if;
   end process;
end adr_arch;   
