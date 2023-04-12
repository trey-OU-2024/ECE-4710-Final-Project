---------------------------------------------------------------------------
-- This VHDL file was developed by Daniel Llamocca (2013).  It may be
-- freely copied and/or distributed at no cost.  Any persons using this
-- file for any purpose do so at their own risk, and are responsible for
-- the results of such use.  Daniel Llamocca does not guarantee that
-- this file is complete, correct, or fit for any particular purpose.
-- NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.  This notice must
-- accompany any copy of this file.
--------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.log2;
use ieee.math_real.ceil;

-- This file works for the Nexys-4 Board with eight 7-segment displays
entity serializer is
	port (resetn, clock: in std_logic; -- resetn: active-low input, pause: active-high input
	      A, B, C, D: in std_logic_vector (3 downto 0);
			segs: out std_logic_vector (6 downto 0); -- active-low input for all 7-segment displays
			AN: out std_logic_vector (7 downto 0)); -- eight active-low enable for each 7-segment display
end serializer;

architecture Behavioral of serializer is
    component my_genpulse_sclr
        --generic (COUNT: INTEGER:= (10**8)/2); -- (10**8)/2 cycles of T = 10 ns --> 0.5 s
        generic (COUNT: INTEGER:= (10**2)/2); -- (10**2)/2 cycles of T = 10 ns --> 0.5us
        port (clock, resetn, E, sclr: in std_logic;
                Q: out std_logic_vector ( integer(ceil(log2(real(COUNT)))) - 1 downto 0);
                z: out std_logic);
    end component;
	
	component hex2sevenseg
		port (hex: in std_logic_vector (3 downto 0);
				leds: out std_logic_vector (6 downto 0));
	end component;
	
	type state is (S1, S2, S3, S4);
	signal y: state;
	
	signal s: std_logic_vector (1 downto 0);
	signal omux: std_logic_vector (3 downto 0);
	signal E: std_logic;
	signal ENt: std_logic_vector (3 downto 0);
	signal leds: std_logic_vector (6 downto 0);
	
begin


-- Counter: 0.001s
--gz: my_genpulse_sclr generic map (COUNT => 10) -- --> This is for proper simulation
gz: my_genpulse_sclr generic map (COUNT => 10**5)
    port map (clock => clock, resetn => resetn, E => '1', sclr => '0', z => E);
    
-- Multiplexor
with s select
	omux <= A when "00",
	        B when "01",
			C when "10",
			D when others;
			  
seg7: hex2sevenseg port map (hex => omux, leds => leds);

segs <= not(leds);
 
-- 2-to-4 decoder with active-low inputs
with s select
		ENt <=  "1110" when "00",
			    "1101" when "01",
			    "1011" when "10",
			    "0111" when "11",
			    "1111" when others;

-- We have 8 7-segment displays. Here, we use only 4 of them, so the other 4 should be inactive
AN <= "1111"&ENt; -- for all the 8 seven-seg displays. '1' is inactive for active-low enable.
	 
	Transitions: process (resetn, clock, E)
	begin
		if resetn = '0' then -- asynchronous signal
			y <= S1; -- if resetn asserted, go to initial state: S1			
		elsif (clock'event and clock = '1') then
				case y is
					when S1 => if E =  '1' then y <= S2; else y <= S1; end if;
					when S2 => if E =  '1' then y <= S3; else y <= S2; end if;
					when S3 => if E =  '1' then y <= S4; else y <= S3; end if;
					when S4 => if E =  '1' then y <= S1; else y <= S4; end if;
				end case;
		end if;		
	end process;
	
	Outputs: process (y)
	begin
		case y is
			when S1 => s <= "00";
			when S2 => s <= "01";
			when S3 => s <= "10";
			when S4 => s <= "11";
		end case;
	end process;
	
end Behavioral;
