library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_PID is
  Port (clock, resetn,S_PID,Z_SEC,zC1,z48,fall_edge,zD1,zD2,PID : in std_logic;
        E_SEC, E_Req, L_Req, EC1, E48, ED1, ED2, E_Res, E_Sel, E_Sync,k_line: out std_logic);
end FSM_PID;

architecture Behavioral of FSM_PID is
    type state is (S1, S2, S3, S4, S5, S6, S7, S8, S9, S10);
	signal y: state;
	
begin
Transitions: process (resetn, clock)
	begin
		if resetn = '0' then -- asynchronous signal
			y <= S1;  -- if resetn asserted, go to initial state: S1			
		elsif (clock'event and clock = '1') then
			case y is
				when S1 => 
				    if S_PID = '1' then y <= S2; else y <= S1; end if;    
				when S2 => 
				    if Z_SEC = '1' then y <= S3; else y <= S2; end if;     
				when S3 => 
				    if zC1 = '1' then y <= S4; else y <= S3; end if;   
				when S4 => 
				    if zC1 = '1' then 
				        if z48 = '1' then y <= S5;
				        else y <= S4; end if;
				    else y <= S4;
				    end if; 
				when S5 => 
				    if zC1 = '1' then y <= S6; else y <= S5; end if;			        
				when S6 =>
				    if fall_edge = '1' then y <= S7; else y <= S6; end if;
				when S7 => 
				    if zD1 = '1' then y <= S8; else y <= S7; end if;
				when S8 =>  
				    if zC1 = '1' then 
				        if z48 = '1' then y <= S9; 
				        else y <= S8; end if;
				    else y <= S8; 
				    end if;
			    when S9 =>
			         if zC1 = '1' then y <= S10; else y <= S9; end if;        
				when S10 => 
				    if zD2 = '1' then y <= S2; else y <= S10; end if;    
	       end case;
	   end if;		
	end process;

Outputs: process (y,zC1,Z_SEC,zD1,zD2,PID,z48)
 begin
	E_SEC <= '0'; E_Req <= '0'; L_Req <= '0'; EC1 <= '0'; E48 <= '0'; ED1 <= '0'; ED2 <= '0'; E_Res <= '0'; 
	E_Sel <= '0'; E_Sync <= '0'; k_line <= '0';
    case y is
        when S1 => k_line <= '1';  
        when S2 => k_line <= '1';
            if Z_SEC = '1' then E_Req <= '1'; E_SEC <= '1'; L_Req <= '1'; else E_SEC <= '1'; end if;     
        when S3 => k_line <= '0';
            if zC1 = '1' then EC1 <= '1'; else EC1 <= '1'; end if;   
        when S4 => k_line <= PID;
            if zC1 = '1' then EC1 <= '1'; E_Req <= '1';
                if z48 = '1' then E48 <= '1'; 
                else  E48 <= '1'; end if;
            else EC1 <= '1'; 
            end if;
        when S5 => k_line <= '1';
            if zC1 = '1' then EC1 <= '1'; else EC1 <= '1'; end if;
        when S6 => k_line <= '1';
        when S7 => k_line <= '1';
            if zD1 = '1' then ED1 <= '1'; else ED1 <= '1'; end if;
        when S8 => k_line <= '1'; 
            if zC1 = '1' then EC1 <= '1'; E_Res <= '1'; 
                if z48 = '1' then E48 <= '1'; 
                else E48 <= '1'; end if;
            else EC1 <= '1'; 
            end if;
        when S9 => k_line <= '1';
             if zC1 = '1' then EC1 <= '1'; else EC1 <= '1'; end if;        
        when S10 => k_line <= '1';
            if zD2 = '1' then ED2 <= '1'; E_Sel <= '1'; E_Sync <= '1'; 
            else ED2 <= '1'; end if; 
end case;
	end process;
end Behavioral;