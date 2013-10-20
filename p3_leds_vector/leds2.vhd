----------------------------------------------------------------------------------
-- Company: cf16
-- Engineer: cf16
-- Create Date:    21:37:41 10/20/2013
-- Module Name:    leds2 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity leds2 is
      Port ( button : in  STD_LOGIC;
             LEDs2     :  out STD_LOGIC_VECTOR(1 downto 0));
end leds;

hjkl

architecture Behavioral of leds2 is
begin
  LEDs2 <= (1 downto 0 => button);
end Behavioral;

