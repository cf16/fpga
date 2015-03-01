----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    22:32:54 10/19/2013 
-- Module Name:    Switches_LEDs - Behavioral 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Switches_LEDs is
    Port ( switch_0 : in  STD_LOGIC;
           switch_1 : in  STD_LOGIC;
			  switch_2 : in  STD_LOGIC;
           LED_0 : out  STD_LOGIC;
           LED_1 : out  STD_LOGIC;
			  LED_2 : out  STD_LOGIC);
end Switches_LEDs;

architecture Behavioral of Switches_LEDs is
begin
  LED_0 <= switch_0;
  LED_1 <= switch_1;
  LED_2 <= switch_2;
end Behavioral;

