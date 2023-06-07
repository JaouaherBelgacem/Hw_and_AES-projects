library IEEE;
use IEEE.std_logic_1164.all;

Entity DrinksVending is
port ( Clock, Reset: in std_logic;
       euroIn, twentyCent, tee, coffee: in std_logic;
       DispenseD, returnAmount : out std_logic
);
end entity;

architecture DrinksVending_arch of DrinksVending is

type states is (idle, s20, s40, s60);
signal currentState, nextState: states;

begin

----------------------------------------------

--Process 1: for storing

Memory_Process: process (Clock, Reset)
begin

	if( Reset = '0') then
		currentState <= idle;
        elsif (rising_edge (Clock)) then
		currentState <= nextState;
	end if;

end process;

----------------------------------------------

--Process 2: for logic

Next_State_Process: process ( currentState, euroIn, twentyCent)

begin

	case (currentState) is

  		 when idle => if ( twentyCent = '1') then
                           nextState <= s20;
                           else
                           nextState <= idle;
                           end if;

   		 when s20 => if ( twentyCent = '1') then
                           nextState <= s40;
                           else
                           nextState <= s20;
                           end if;

   		 when s40 => if ( twentyCent = '1') then
                           nextState <= s60;
                           else
                           nextState <= s40;
                           end if;

   	 	 when s60 => if ( twentyCent = '1') then
                           nextState <= idle;
                           else
                           nextState <= s60;
                           end if;

	         when others => nextState <= idle;

       end case;
end process;
-----------------------------------------------

--Process 3: output results

Output_Process: process ( currentState, euroIn, twentyCent, tee, coffee)

begin

	case (currentState) is

  		 when idle => if ( euroIn = '1' and tee= '1' and coffee ='0') then ----- the chosen drink is tee for 40 cents
                           DispenseD <= '1'; returnAmount <= '1'; 
                           elsif ( euroIn = '1' and tee= '0' and coffee ='1') then ----- the chosen drink is coffee for 60 cent
                           DispenseD <= '1'; returnAmount <= '1'; 
   			   elsif ( euroIn = '1' and tee= '1' and coffee ='1') then ----- the chosen drink are  coffee for 60 cent and tee for 40 cent
			   DispenseD <= '1'; returnAmount <= '0';
                           else
			   DispenseD <= '0'; returnAmount <= '0';
                           end if;

   		 when s20 => DispenseD <= '0'; returnAmount <= '0';

   		 when s40 => if ( twentyCent = '1' and tee = '0' and coffee = '0') then --- paid the exact price amount of tee and chose did not choose a drink 
                           DispenseD <= '0'; returnAmount <= '0';
                           elsif ( twentyCent = '1' and tee = '1' and coffee = '0') then --- paid 40 cents and asked for tee as a drink
                           DispenseD <= '1'; returnAmount <= '0';
                           else
                           DispenseD <= '0'; returnAmount <= '0';
                           end if;

   	 	 when s60 => if ( twentyCent = '1' and tee = '1' and coffee='0') then --- paid the grater amount than tee price and chose it as drink 
                           DispenseD <= '1'; returnAmount <= '1';
                           elsif ( twentyCent = '1' and tee = '0' and coffee='1') then --- paid the exact price amount of coffee and ask for it as a drink 
                           DispenseD <= '1'; returnAmount <= '0';
                           else
                           DispenseD <= '0'; returnAmount <= '0';
                           end if;

	when others => DispenseD <= '0'; returnAmount <= '0';

 end case;
end process;


end architecture;