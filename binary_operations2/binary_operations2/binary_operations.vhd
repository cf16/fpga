----------------------------------------------------------------------------------
-- Company: cf16
-- Engineer: cf16
-- Create Date:    15:33:23 10/20/2013 
-- Module Name:    binary_operations - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity binary_operations is
    Port ( switch0 : in  STD_LOGIC;
           switch1 : in  STD_LOGIC;
           LED0 : out  STD_LOGIC;
           LED1 : out  STD_LOGIC;
			  LED2 : out  STD_LOGIC;
			  LED3 : out  STD_LOGIC;
			  LED4 : out  STD_LOGIC;
			  LED5 : out STD_LOGIC;
			  LED6 : out STD_LOGIC;
			  LED7 : out STD_LOGIC);
end binary_operations;

architecture Behavioral of binary_operations is
begin
 LED0 <= switch0 NAND switch1;
 LED1 <= NOT(switch0 AND switch1);
 LED2 <= switch0 NAND switch1;
 LED3 <= NOT(switch0) OR NOT(switch1);
 LED4 <= NOT(switch0);
 LED5 <= switch0 XOR switch1;
 LED6 <= NOT(switch0 XOR switch1);
 LED7 <= switch1 AND NOT(switch0); -- liht up only when sw0 is off and sw1 is on
end Behavioral;

