----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    21:09:23 10/27/2013 
-- Module Name:    module1 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity module1 is
    Port(switches : in  std_logic_vector(7 downto 0);
	      LED     : out std_logic_vector(7 downto 0)
			);
end module1;

architecture Behavioral of module1 is
    signal x      : STD_LOGIC_VECTOR(3 downto 0);
	 signal y      : STD_LOGIC_VECTOR(3 downto 0);
	 signal carry  : STD_LOGIC_VECTOR(4 downto 0);
	 signal result : STD_LOGIC_VECTOR(4 downto 0);
begin
    LED <= "000" & result;
    x <= switches(3 downto 0);
	 y <= switches(7 downto 4);
	 
	 result(0) <= x(0) xor y(0);
	 carry(0) <= x(0) and y(0);
	 
	 result(1) <= x(1) xor y(1) xor carry(0);
	 carry(1) <= (x(1) and y(1)) or (carry(0) and x(1)) or (carry(0) and y(1));
end Behavioral;

