LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    
    component top is
    Port (clock, resetn, s, k_in : in std_logic;
         test : out std_logic_vector(7 downto 0);
         compare_LED,k_out : out std_logic);
    end component;
    

   --Inputs
   signal clock : std_logic := '0';
   signal resetn: std_logic := '0';
   signal s : std_logic := '0';
   signal k_in : std_logic := '0';
  
 	--Outputs
   signal test : std_logic_vector(7 downto 0);
   signal compare_LED : std_logic;
   signal k_out : std_logic;
   
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
       clock => clock,
       resetn => resetn,
       s => s,
       k_in => k_in,
       test => test,
       compare_LED => compare_LED,
       k_out => k_out
        );

clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns; 	resetn <= '1';
      
      wait for 10 ns; s <= '1';
      wait for 10 ns; s <= '0';
      wait for 10*200 ms; 
      wait for 10 ms;
      k_in <= '1';
      wait for 10 ms;
      k_in <= '0'; wait for 9614*10 ns; k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns; 
      wait for 5 ms;
      k_in <= '0'; wait for 9614*10 ns; k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;
      wait for 5 ms;
      k_in <= '0'; wait for 9614*10 ns; k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;
      wait for 12 ms; k_in <= '0';
      wait for 13 ms;
      wait for 10*10*9614 ns;
      wait for 12 ms; k_in <= '1';
      wait for 13 ms;
      k_in <= '0'; wait for 9614*10 ns; k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '0'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;k_in <= '1'; wait for 9614*10 ns;
      wait for 5 ms; k_in <= '0';
      
		
	
      wait;
   end process;

END;
