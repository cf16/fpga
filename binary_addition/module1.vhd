----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    21:09:23 10/27/2013 
-- Module Name:    binary_addition
-- brief
-- Add two 3-bits into 4-bit result
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity module1 is
    Port(switches : in  std_logic_vector(7 downto 0);
	      LED     : out std_logic_vector(7 downto 0)
			);
end module1;

architecture Behavioral of module1 is
    signal x      : STD_LOGIC_VECTOR(2 downto 0); -- 3-bits
	 signal y      : STD_LOGIC_VECTOR(2 downto 0); -- 3-bits
	 signal carry  : STD_LOGIC_VECTOR(3 downto 0); -- 4-bits
	 signal result : STD_LOGIC_VECTOR(3 downto 0); -- 4-bits
begin
    LED <= "0000" & result; -- 4-bits + 4-bits
    x <= switches(2 downto 0);
	 y <= switches(6 downto 4);
	 
	 result(0) <= x(0) xor y(0);
	 carry(0) <= x(0) and y(0); -- produced always by 1 and 1
	 
	 result(1) <= x(1) xor y(1) xor carry(0); -- must be 0 if 01 or 10 but carry==1
	 carry(1) <= (x(1) and y(1)) or (carry(0) and x(1)) or (carry(0) and y(1));

	 result(2) <= x(2) xor y(2) xor carry(1); -- must be 0 if 01 or 10 but carry==1
	 carry(2) <= (x(2) and y(2)) or (carry(1) and x(2)) or (carry(1) and y(2));
	 
	 result(3) <= carry(2); -- end
end Behavioral;

