library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Falling_edge_detector is
 Port (clock,resetn,k_line : in std_logic;
       fall_edge : out std_logic);
end Falling_edge_detector;

architecture Behavioral of Falling_edge_detector is

type state is (S1,S2);
signal y: state;

begin
Transitions: process(clock,resetn)
    begin
		if resetn = '0' then -- asynchronous signal
			y <= S1;  -- if resetn asserted, go to initial state: S1			
		elsif (clock'event and clock = '1') then
			case y is
			 when S1 => 
			     if k_line = '1' then y <= S2; else y <= S1; end if;
			 when S2 => 
			     if k_line = '0' then y <= S1; else y <= S2; end if;
        end case;
        end if;
   end process;
 
 Outputs: process(y,k_line)
    begin 
    fall_edge <= '0';
    case y is 
    when S1 => 
    when S2 => if k_line = '0' then fall_edge <= '1'; end if;
    end case;
    end process; 
   
end Behavioral;
