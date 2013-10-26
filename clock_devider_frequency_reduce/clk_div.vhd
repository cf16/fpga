----------------------------------------------------------------------------------
-- Engineer: cf16
-- Create Date:    15:58:30 10/26/2013 
-- Module Name:    clk_div - Behavioral 
----------------------------------------------------------------------------------
-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity
entity clk_div is
Port (
    clk    : in std_logic;
    div_en : in std_logic;
    sclk : out std_logic);
end clk_div;

-- architecture
architecture my_clk_div of clk_div is
    type my_count is range 0 to 100; -- user-defined type
    constant max_count : my_count := 31; -- user-defined constant
    signal tmp_sclk : std_logic; -- intermediate signal
    begin
        my_div: process (clk,div_en)
        variable div_count : my_count := 0;
        begin
            if (div_en = '0') then
                div_count := 0;
                tmp_sclk <= '0';
            elsif (rising_edge(clk)) then
                   -- divider enabled
                   if (div_count = max_count) then
                       tmp_sclk <= not tmp_sclk;  -- toggle output
                       div_count := 0;  -- reset count
                   else
                       div_count := div_count + 1; -- count
                   end if;
            end if;
     end process my_div;
     sclk <= tmp_sclk;  -- final assignment
end my_clk_div;