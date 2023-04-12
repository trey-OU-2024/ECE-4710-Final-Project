library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity FSM_INIT is
	port (clock, resetn, s, so,zC,zC1,zQ,fall_edge,zD1,zD2,compare : in std_logic; 
	      LR,ER,EC,EQ,ED1,ED2,EC1,ER1,k_line,S_PID : out std_logic);
end FSM_INIT;

architecture behaviour of FSM_INIT is
	type state is (S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19);
	signal y: state;
	

begin



	Transitions: process (resetn, clock)
	begin
		if resetn = '0' then -- asynchronous signal
			y <= S1;  -- if resetn asserted, go to initial state: S1			
		elsif (clock'event and clock = '1') then
			case y is
				when S1 => 
				    if s = '0' then y <= S2; else y <= S1; end if;    
				when S2 => 
				    if s = '1' then y <= S3; else y <= S2; end if;     
				when S3 => 
				    if zC = '1' then y <= S4; else y <= S3; end if;   
				when S4 => 
				    if zC = '1' then 
				        if zQ = '1' then y <= S5; 
				        else  y <= S4; end if;
				    else y <= S4; 
				    end if;
				when S5 => 
				    if zC = '1' then y <= S6; else y <= S5; end if;			        
				when S6 =>
				    if fall_edge = '1' then y <= S7; else y <= S6; end if;
				when S7 => 
				    if zD1 = '1' then y <= S8; else y <= S7; end if;
				when S8 =>  
				    if zC1 = '1' then 
				        if zQ = '1' then y <= S9; 
				        else y <= S8; end if;
				    else y <= S8; 
				    end if;
			    when S9 =>
			         if zC1 = '1' then y <= S10; else y <= S9; end if;        
				when S10 => 
				    if compare = '1' then y <= S11; else y <= S6; end if;    
				when S11 => 
				    if zD2 = '1' then y <= S12; else y <= S11; end if; 
				when S12 => 
				    if zC1 = '1' then y <= S13; else y <= S12; end if;
				when S13 => 
				    if zC1 = '1' then 
				        if zQ = '1' then y <= S14;
				        else y <= S13; end if;
				    else y <= S13; end if;
				when S14 => 
				    if zC1 = '1' then y <= S15; else y <= S14; end if;				   
				when S15 =>
				    if fall_edge = '1' then y <= S16; else y <= S15; end if;
				when S16 => 
				    if zD1 = '1' then y <= S17; else y <= S16; end if;
				when S17 =>  
				    if zC1 = '1' then 
				        if zQ = '1' then y <= S18; 
				        else y <= S17; end if;
				    else y <= S17; 
				    end if;
			    when S18 =>
			         if zC1 = '1' then y <= S19; else y <= S18; end if; 
			    when S19 => y <= S19;   
			end case;
		end if;		
	end process;
	
	Outputs: process (y,s,zC,zQ,zD1,zC1,compare, zD2, so)
	begin
	k_line <= '0'; LR <= '0'; ER <= '0'; EC <= '0'; EQ <= '0'; ED1 <= '0'; ED2 <= '0'; EC1 <= '0'; ER1 <= '0'; S_PID <= '0';
    case y is
       when S1 => k_line <= '1';  
            when S2 => k_line <= '1';
                if s = '1' then LR <= '1'; ER <= '1'; end if;     
            when S3 => k_line <= '0';
                if zC = '1' then EC <= '1'; else EC <= '1';  end if;   
            when S4 => k_line <= so;
                if zC = '1' then EC <= '1'; ER <= '1';
                    if zQ = '1' then EQ <= '1'; 
                    else  EQ <= '1'; end if;
                else EC <= '1'; 
                end if;
            when S5 => k_line <= '1';
                if zC = '1' then EC <= '1'; else EC <= '1'; end if;
            when S6 => k_line <= '1';
            when S7 => k_line <= '1';
                if zD1 = '1' then ED1 <= '1'; else ED1 <= '1'; end if;
            when S8 => k_line <= '1'; 
                if zC1 = '1' then ER <= '1'; LR <= '0'; EC1 <= '1'; 
                    if zQ = '1' then EQ <= '1'; 
                    else EQ <= '1'; end if;
                else EC1 <= '1'; 
                end if;
            when S9 => k_line <= '1';
                 if zC1 = '1' then EC1 <= '1'; else EC1 <= '1'; end if;        
            when S10 => k_line <= '1';
                if compare = '0' then ER1 <= '1'; end if; 
            when S11 => k_line <= '1';
                if zD2 = '1' then ED2 <= '1'; else ED2 <= '1'; end if; 
            when S12 => k_line <= '0';
                if zC1 = '1' then EC1 <= '1'; else EC1 <= '1';  end if;
            when S13 => k_line <= so;
                if zC1 = '1' then EC1 <= '1'; ER <= '1'; 
                    if zQ = '1' then EQ <= '1';
                    else EQ <= '1'; end if;
                else EC1 <= '1'; end if;
            when S14 => k_line <= '1';
                if zC1 = '1' then EC1 <= '1'; else EC1 <= '1'; end if; 
            when S15 => k_line <= '1';
            when S16 => k_line <= '1';
                if zD1 = '1' then ED1 <= '1'; else ED1 <= '1'; end if;
            when S17 => k_line <= '1';
                if zC1 = '1' then ER <= '1'; LR <= '0'; EC1 <= '1';
                    if zQ = '1' then EQ <= '1'; 
                    else EQ <= '1'; end if;
                else EC1 <= '1'; 
                end if;
            when S18 => k_line <= '1';
                 if zC1 = '1' then EC1 <= '1'; else EC1 <= '1'; end if; 
            when S19 => k_line <= '1'; S_PID <= '1';
end case;
	end process;
end behaviour;