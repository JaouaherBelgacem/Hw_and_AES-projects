LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

    COMPONENT VendingM
    PORT(
         Clock : IN  std_logic;
         Reset : IN  std_logic;
         euroIn : IN  std_logic;
         twentyCent : IN  std_logic;
         tee : IN  std_logic;
         coffee : IN  std_logic;
         An0 : OUT  std_logic_vector(7 downto 0);
         Display : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   --Inputs
   signal Clock : std_logic := '0';
   signal Reset : std_logic := '0';
   signal euroIn : std_logic := '0';
   signal twentyCent : std_logic := '0';
   signal tee : std_logic := '0';
   signal coffee : std_logic := '0';

    --Outputs
   signal An0 : std_logic_vector(7 downto 0);
   signal Display : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant Clock_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: VendingM PORT MAP (
          Clock => Clock,
          Reset => Reset,
          euroIn => euroIn,
          twentyCent => twentyCent,
          tee => tee,
          coffee => coffee,
          An0 => An0,
          Display => Display
        );

   -- Clock process definitions
   Clock_process :process
   begin
		Clock <= '0';
		wait for Clock_period/2;
		Clock <= '1';
		wait for Clock_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      Reset <= '1';
      wait for 100 ns;	
      
      Reset <= '0'; 
      wait for Clock_period;

      -- nothing inserted, no drinks selected
      euroIn <= '0'; twentyCent <= '0'; tee <= '0'; coffee <= '0'; 
      wait for Clock_period;

      -- nothing inserted, tee selected
      euroIn <= '0'; twentyCent <= '0'; tee <= '1'; coffee <= '0'; 
      wait for Clock_period;

      -- nothing inserted, coffee selected
      euroIn <= '0'; twentyCent <= '0'; tee <= '0'; coffee <= '1'; 
      wait for Clock_period;

      -- nothing inserted, tee + coffee selected
      euroIn <= '0'; twentyCent <= '0'; tee <= '1'; coffee <= '1'; 
      wait for Clock_period;

      -- insert 1 euro, no drinks selected
      euroIn <= '1'; tee <= '0'; coffee <= '0'; 
      wait for Clock_period;

      -- insert 1 euro, tee selected
      euroIn <= '1'; tee <= '1'; coffee <= '0'; 
      wait for Clock_period;

      -- insert 1 euro, coffee selected
      euroIn <= '1'; tee <= '0'; coffee <= '1'; 
      wait for Clock_period;

      -- insert 1 euro, tee and coffee selected
      euroIn <= '1'; tee <= '1'; coffee <= '1'; 
      wait for Clock_period;

      -- insert 20 cents, no drinks selected
      twentyCent <= '1'; tee <= '0'; coffee <= '0'; 
      wait for Clock_period;

      -- insert 20 cents, tee selected
      twentyCent <= '1'; tee <= '1'; coffee <= '0'; 
      wait for Clock_period;

      -- insert 20 cents, coffee selected
      twentyCent <= '1'; tee <= '0'; coffee <= '1'; 
      wait for Clock_period;

      -- insert 20 cents, tee + coffe selected
      twentyCent <= '1'; tee <= '1'; coffee <= '1'; 
      wait for Clock_period;

      -- insert another 20 cents, no drinks selected
      twentyCent <= '1'; tee <= '0'; coffee <= '0'; 
      wait for Clock_period;

      -- now select tea
      twentyCent <= '0'; tee <= '1'; coffee <= '0'; 
      wait for Clock_period;

      -- hold reset state for 100 ns.
      Reset <= '1';
      wait for 100 ns;	
      
      Reset <= '0'; 
      wait for Clock_period;

      -- insert 20 cents, no drink selected
      twentyCent <= '1'; tee <= '1'; coffee <= '1'; 
      wait for Clock_period;

      -- insert another 20 cents, no drinks selected
      twentyCent <= '1'; tee <= '0'; coffee <= '0'; 
      wait for Clock_period;

      -- insert another 20 cents, coffee selected
      twentyCent <= '1'; tee <= '0'; coffee <= '1'; 
      wait for Clock_period;

      -- now select coffee
      twentyCent <= '0'; tee <= '0'; coffee <= '1'; 
      wait for Clock_period;




	  wait;
   end process;

END;

