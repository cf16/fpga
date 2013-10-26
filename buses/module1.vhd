----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    07:45:59 10/24/2013 
-- Module Name:    module1 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity leds is
      Port ( switches : in  STD_LOGIC_VECTOR(4 downto 0);
             LED     :  out STD_LOGIC_VECTOR(5 downto 0);
				 LED2     :  out STD_LOGIC_VECTOR(1 downto 0));
end leds;

architecture Behavioral of leds is
begin
  --LED <= (3 downto 0 =>switches(3) AND switches(2) AND switches(1) AND switches(0),
  --7 downto 4 => switches(7) AND switches(6) AND switches(5) AND switches(4));
  --LED <= switches;
  LED <= std_logic_vector(switches) & '1';-- & switches(1); LED(0) will be on
                                          -- constantly
  LED2 <= switches(0) & switches(1);
end Behavioral;

