----------------------------------------------------------------------------------
-- Company: cf16
-- Engineer: cf16
-- Create Date:    21:13:25 10/20/2013 
-- Module Name:    leds - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity leds is
      Port ( switches : in  STD_LOGIC_VECTOR(1 downto 0);
             LEDs     :  out STD_LOGIC_VECTOR(5 downto 0);
				 button : in  STD_LOGIC;
             LEDs2     :  out STD_LOGIC_VECTOR(1 downto 0));
end leds;

architecture Behavioral of leds is
begin
  LEDs <= (5 downto 2 =>switches(0), 1 downto 0 => switches(1));
  LEDs2 <= (1 downto 0 => button);
end Behavioral;

