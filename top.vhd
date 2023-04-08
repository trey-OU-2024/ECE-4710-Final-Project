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
	      LR,ER,EC,EQ,ED1,ED2,EC1,ER1,k_line : out std_logic);
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
signal EQ,ZQ,EC,EC1,zC,zC1,ED1,ED2,zD1,zD2,so_1,LR,ER,ER1,compare,fall_edge,so: std_logic;
signal Q_1,Q_2,compare_vector,compare_LED_vector : std_logic_vector(7 downto 0);
begin
so <= not(so_1);
FSM: FSM_INIT port map(clock=>clock,resetn=>resetn,s=>s,so=>so,zC=>zC,zC1=>zC1,zQ=>zQ,fall_edge=>fall_edge,zD1=>zD1,zD2=>zD2,compare=>compare,
                       LR=>LR,ER=>ER,EC=>EC,EQ=>EQ,ED1=>ED1,ED2=>ED2,EC1=>EC1,ER1=>ER1,k_line=>k_out);
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
        
SHIFTREG: my_pashiftreg_sclr generic map(N=>8,DIR=>"RIGHT")
    port map(clock=>clock,resetn=>resetn,din=>k_in,E=>ER,sclr=>'0',s_l=>LR,D=>"11001100",Q=>Q_1,shiftout=>so_1);

EDGE: Falling_edge_detector port map(clock=>clock,resetn=>resetn,k_line=>k_in,fall_edge=>fall_edge);
REG: my_rege generic map(N=>8)
    port map(clock=>clock,resetn=>resetn,E=>ER1,sclr=>'0',D=>Q_1,Q=>Q_2);
    
compare_vector <= Q_2 xnor Q_1;
compare <= compare_vector(0) and compare_vector(1) and compare_vector(2) and compare_vector(3) and compare_vector(4) and compare_vector(5) and compare_vector(6) and compare_vector(7);    

compare_LED_vector <= "00110011" xnor Q_1;
compare_LED <= compare_LED_vector(0) and compare_LED_vector(1) and compare_LED_vector(2) and compare_LED_vector(3) 
and compare_LED_vector(4) and compare_LED_vector(5) and compare_LED_vector(6) and compare_LED_vector(7);    
    
end Behavioral;