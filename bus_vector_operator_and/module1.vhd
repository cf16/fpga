----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    07:45:59 10/24/2013 
-- Module Name:    module1 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity entity1 is
      Port ( switches : in  STD_LOGIC_VECTOR(7 downto 0);
             LED     :  out STD_LOGIC_VECTOR(7 downto 0));
	   signal s : std_logic_vector(7 downto 0) := (1=>switches(3) AND switches(7), 2=> switches(2) AND switches(6),3=>switches(1) AND switches(5), 4=>switches(0) AND switches(4), others=>'1');
end entity1;

architecture Behavioral of entity1 is
begin
  s <= (3=>switches(3) AND switches(7), 2=> switches(2) AND switches(6),1=>switches(1) AND switches(5), 0=>switches(0) AND switches(4), others=>'1');
  -- LED <= s; or alternatively:
  LED <= (3=>switches(3) AND switches(7), 2=> switches(2) AND switches(6),
          1=>switches(1) AND switches(5), 0=>switches(0) AND switches(4),
          7=>switches(3) OR switches(7), 6=>switches(2) OR switches(6),
			 5=>switches(1) OR switches(5), 4=>switches(0) OR switches(4));
end Behavioral;