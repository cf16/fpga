----------------------------------------------------------------------------------
-- Company: cf16
-- Engineer: cf16
-- Create Date:    07:45:59 10/24/2013 
-- Module Name:    module1 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity leds is
      Port ( switches : in  STD_LOGIC_VECTOR(7 downto 0);
             LED     :  out STD_LOGIC_VECTOR(7 downto 0));
end leds;

architecture Behavioral of leds is
begin
  --LED <= (3 downto 0 =>switches(3) AND switches(2) AND switches(1) AND switches(0),
  --7 downto 4 => switches(7) AND switches(6) AND switches(5) AND switches(4));
  --LED <= switches;
  LED <= std_logic_vector(switches);-- & switches(1);
end Behavioral;

