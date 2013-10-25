----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    05:09:07 10/25/2013 
-- Module Name:    vhdlmodule1 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vhdlmodule1 is
    Port ( CLKIN : in std_logic;
           AN3 : inout std_logic;
           AN2 : inout std_logic;
           AN1 : inout std_logic;
           AN0 : inout std_logic;
           LED : out std_logic_vector(6 downto 0));
end vhdlmodule1;

architecture Behavioral of vhdlmodule1 is

signal CTR : STD_LOGIC_VECTOR(12 downto 0);
begin
  Process (CLKIN)
  begin
    if CLKIN'event and CLKIN = '1' then
      if (CTR="0000000000000") then
        if (AN0='0') then 
          AN0 <= '1';	 
          LED <= "0101011";             -- the letter n
          AN1 <= '0';
        elsif (AN1='0') then 
          AN1 <= '1';	 	 
          LED <= "0101011";             -- the letter n
          AN2 <= '0';
        elsif (AN2='0') then 
          AN2 <= '1';	 
          LED <= "0001000";             -- the letter A
          AN3 <= '0';
        elsif (AN3='0') then 
          AN3 <= '1';
          LED <= "0000110";             -- the letter E
          AN0 <= '0';
        end if;
      end if;
      CTR<=CTR+"0000000000001";
      if (CTR > "1000000000000") then   -- counter reaches 2^13
        CTR<="0000000000000";
      end if;
    end if; -- CLK'event and CLK = '1' 
  End Process;

end Behavioral;

