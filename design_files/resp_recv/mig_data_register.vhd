library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
--mig data register
entity mdr is
 port ( clk , rst, mdr_en: in std_logic;
        mdr_in: in std_logic_vector(63 downto 0);
        mdr_out: out std_logic_vector(63 downto 0)
      );
end mdr;

architecture arch of mdr is
 
signal intermediate : std_logic_vector(63 downto 0);
  begin
    process(clk,rst)
       begin
          if (rst = '1') then
              mdr_out <= "0000000000000000000000000000000000000000000000000000000000000000";
          else if (clk ='1' and clk 'event) then
                 if (mdr_en = '1') then
                    intermediate <= mdr_in;
                    mdr_out <= intermediate;
                 end if; 
               end if;
          end if;
       end process;
  end arch;  
       
