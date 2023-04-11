----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2023 11:11:32 PM
-- Design Name: 
-- Module Name: mydec2to4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mydec2to4 is
 Port (w: in std_logic_vector(1 downto 0);
        E: in std_logic;
        y: out std_logic_vector(3 downto 0) );
end mydec2to4;

architecture Behavioral of mydec2to4 is
signal Ew : std_logic_vector(2 downto 0);
begin
Ew <= E&w;
with Ew select
        y <= "0001" when "100",
             "0010" when "101",
             "0100" when "110",
             "1000" when "111",
             "0000" when others;


end Behavioral;
