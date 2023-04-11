library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;


entity top is
  Port (clock, resetn, s, k_in : in std_logic;
        compare_LED,k_out, state6 : out std_logic);
end top;

architecture Behavioral of top is
component FSM_INIT is
	port (clock, resetn, s, so,zC,zC1,zQ,fall_edge,zD1,zD2,compare : in std_logic; 
	      LR,ER,EC,EQ,ED1,ED2,EC1,ER1,k_line,S_PID : out std_logic);
end component;
component my_genpulse_sclr is
	--generic (COUNT: INTEGER:= (10**8)/2); -- (10**8)/2 cycles of T = 10 ns --> 0.5 s
	generic (COUNT: INTEGER:= (10**2)/2); -- (10**2)/2 cycles of T = 10 ns --> 0.5us
	port (clock, resetn, E, sclr: in std_logic;
			Q: out std_logic_vector ( integer(ceil(log2(real(COUNT)))) - 1 downto 0);
			z: out std_logic);
end component;
component my_pashiftreg_sclr is
   generic (N: INTEGER:= 4;
	         DIR: STRING:= "LEFT");
	port ( clock, resetn: in std_logic;
	       din, E, sclr, s_l: in std_logic; -- din: shiftin input
			 D: in std_logic_vector (N-1 downto 0);
	       Q: out std_logic_vector (N-1 downto 0);
          shiftout: out std_logic);
end component;
component Falling_edge_detector is
 Port (clock,resetn,k_line : in std_logic;
       fall_edge : out std_logic);
end component;
component my_rege is
   generic (N: INTEGER:= 4);
	port ( clock, resetn: in std_logic;
	       E, sclr: in std_logic; -- sclr: Synchronous clear
			 D: in std_logic_vector (N-1 downto 0);
	       Q: out std_logic_vector (N-1 downto 0));
end component;
component FSM_PID is
  Port (clock, resetn,S_PID,Z_SEC,zC1,z48,fall_edge,zD1,zD2,PID : in std_logic;
        E_SEC, E_Req, L_Req, EC1, E48, ED1, ED2, E_Res, E_Sel, E_Sync,k_line: out std_logic);
end component;
component mydec2to4 is
 Port (w: in std_logic_vector(1 downto 0);
        E: in std_logic;
        y: out std_logic_vector(3 downto 0) );
end component;
signal EQ,ZQ,EC,EC1,zC,zC1,ED1,ED2,zD1,zD2,so_1,LR,ER,ER1,compare,fall_edge,so,
S_PID,E_SEC,Z_SEC,E48,z48,PID,E_Req,L_Req,E_Sync,E_Sel,E_Res: std_logic;
signal Q_1,Q_2,compare_vector,compare_LED_vector : std_logic_vector(7 downto 0);
signal D_Store : std_logic_vector(47 downto 0);
signal SEL_PID : std_logic_vector(1 downto 0);
signal E_Store : std_logic_vector(3 downto 0);
begin
so <= not(so_1);
FSM: FSM_INIT port map(clock=>clock,resetn=>resetn,s=>s,so=>so,zC=>zC,zC1=>zC1,zQ=>zQ,fall_edge=>fall_edge,zD1=>zD1,zD2=>zD2,compare=>compare,
                       LR=>LR,ER=>ER,EC=>EC,EQ=>EQ,ED1=>ED1,ED2=>ED2,EC1=>EC1,ER1=>ER1,k_line=>k_out,S_PID=>S_PID);
FSM1: FSM_PID port map(clock=>clock,resetn=>resetn,S_PID=>S_PID,Z_SEC=>Z_SEC,zC1=>zC1,z48=>z48,fall_edge=>fall_edge,zD1=>zD1,
zD2=>zD2,PID=>PID,E_SEC=>E_SEC,E_Req=>E_Req,L_Req=>L_Req,EC1=>EC1,E48=>E48,ED1=>ED1,ED2=>ED2,E_Res=>E_Res,E_Sel=>E_Sel,
E_Sync=>E_Sync,k_line=>k_out);                       
COUNT0: my_genpulse_sclr generic map(COUNT=>8)
    port map(clock=>clock,resetn=>resetn,E=>EQ,sclr=>'0',Q=>open,z=>zQ);
COUNT1: my_genpulse_sclr generic map(COUNT=>20000000)
    port map(clock=>clock,resetn=>resetn,E=>EC,sclr=>'0',Q=>open,z=>zC);
COUNT2: my_genpulse_sclr generic map(COUNT=>9615)
    port map(clock=>clock,resetn=>resetn,E=>EC1,sclr=>'0',Q=>open,z=>zC1);
COUNT3: my_genpulse_sclr generic map(COUNT=>4808)
    port map(clock=>clock,resetn=>resetn,E=>ED1,sclr=>'0',Q=>open,z=>zD1);   
COUNT4: my_genpulse_sclr generic map(COUNT=>1000000)
    port map(clock=>clock,resetn=>resetn,E=>ED2,sclr=>'0',Q=>open,z=>zD2);
COUNT5: my_genpulse_sclr generic map(COUNT=>1000000000)
    port map(clock=>clock,resetn=>resetn,E=>E_SEC,sclr=>'0',Q=>open,z=>Z_SEC);
COUNT6: my_genpulse_sclr generic map(COUNT=>48)
    port map(clock=>clock,resetn=>resetn,E=>E48,sclr=>'0',Q=>open,z=>z48);
COUNT7: my_genpulse_sclr generic map(COUNT=>4)
    port map(clock=>clock,resetn=>resetn,E=>E_sel,sclr=>'0',Q=>SEL_PID,z=>open);
           
SHIFTREG_INIT: my_pashiftreg_sclr generic map(N=>8,DIR=>"RIGHT")
    port map(clock=>clock,resetn=>resetn,din=>k_in,E=>ER,sclr=>'0',s_l=>LR,D=>"11001100",Q=>Q_1,shiftout=>so_1);
SHIFTREG_PID_REQ: my_pashiftreg_sclr generic map(N=>8,DIR=>"RIGHT")
    port map(clock=>clock,resetn=>resetn,din=>'0',E=>E_Req,sclr=>'0',s_l=>L_Req,D=>mux_out,Q=>open,shiftout=>PID);
SHIFTREG_PID_RES: my_pashiftreg_sclr generic map(N=>8,DIR=>"RIGHT")
    port map(clock=>clock,resetn=>resetn,din=>k_in,E=>E_res,sclr=>'0',s_l=>'0',D=>"0x000000000000",Q=>D_Store);

EDGE: Falling_edge_detector port map(clock=>clock,resetn=>resetn,k_line=>k_in,fall_edge=>fall_edge);
REG: my_rege generic map(N=>8)
    port map(clock=>clock,resetn=>resetn,E=>ER1,sclr=>'0',D=>Q_1,Q=>Q_2);
    
REG_STORE0: my_rege generic map(N=>8)
    port map(clock=>clock,resetn=>resetn,E=>E_Store(0),sclr=>'0',D=>D_Store(31 downto 24),Q=>Q_Store0);
REG_STORE1: my_rege generic map(N=>8)
    port map(clock=>clock,resetn=>resetn,E=>E_Store(1),sclr=>'0',D=>D_Store(23 downto 16),Q=>Q_Store1);
REG_STORE2: my_rege generic map(N=>8)
    port map(clock=>clock,resetn=>resetn,E=>E_Store(2),sclr=>'0',D=>D_Store(15 downto 8),Q=>Q_Store2);
REG_STORE3: my_rege generic map(N=>8)
    port map(clock=>clock,resetn=>resetn,E=>E_Store(3),sclr=>'0',D=>D_Store(7 downto 0),Q=>Q_Store3);
DEC: mydec2to4 port map(w=>SEL_PID, E=>E_Sync ,y=>E_Store)
with SEL_PID select
    mux_out <= "0xC90501F16A68" when "00",
                ""              when "01",
                ""              when "10",
                ""              when others;                     
compare_vector <= Q_2 xnor Q_1;
compare <= compare_vector(0) and compare_vector(1) and compare_vector(2) and compare_vector(3) and compare_vector(4) and compare_vector(5) and compare_vector(6) and compare_vector(7);    

compare_LED_vector <= "00110011" xnor Q_1;
compare_LED <= compare_LED_vector(0) and compare_LED_vector(1) and compare_LED_vector(2) and compare_LED_vector(3) 
and compare_LED_vector(4) and compare_LED_vector(5) and compare_LED_vector(6) and compare_LED_vector(7);    
    
end Behavioral;