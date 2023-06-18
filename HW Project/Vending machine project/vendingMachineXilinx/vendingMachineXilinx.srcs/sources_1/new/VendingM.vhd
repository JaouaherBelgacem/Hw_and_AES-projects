----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/15/2023 01:12:54 PM
-- Design Name: 
-- Module Name: VendingM - Behavioral
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


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2023 01:52:47 PM
-- Design Name: 
-- Module Name: vendingM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revis
--0ion 0.01 - File Created
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

entity VendingM is
port ( Clock, Reset: in std_logic;
       euroIn, twentyCent, tee, coffee: in std_logic;
       drinksChoice: out std_logic_vector ( 1 downto 0);
       balance, returnAmount: out std_logic_vector( 3 downto 0);
       DispenseD : out std_logic
);
end entity;

architecture DrinksVending_arch of VendingM is
type states is (idle, s20, s40);
signal currentState, nextState: states;

begin

----------------------------------------------

--Process 1: for storing

State_Memory_Process: process (Clock, Reset)
begin

	if( Reset = '0') then
		currentState <= idle;
        elsif (rising_edge (Clock)) then
		currentState <= nextState;
	end if;

end process;

----------------------------------------------

--Process 2: for logic

Next_State_Process: process ( currentState, euroIn, twentyCent, tee, coffee)

begin

	case (currentState) is

  		 when idle => if ( twentyCent = '1') then
			      nextState <= s20;
			      else nextState <= idle;
                            end if;

   		 when s20 => if ( twentyCent = '1') then		
                           	nextState <= s40;
                           	else
                           	nextState <= s20;
                           end if;

   		 when s40 => if ( twentyCent = '1') then
                           nextState <= idle;
                           else
                           nextState <= s40;
                           end if;

	         when others => nextState <= idle;

       end case;
end process;
-----------------------------------------------

--Process 3: output results

Output_Process: process ( currentState, euroIn, twentyCent, tee, coffee)

begin

	case (currentState) is

  		 when idle => if ( euroIn = '1' and twentyCent = '0' and tee= '1' and coffee ='0') then ----- the chosen drink is tee for 40 cents
                           	DispenseD <= '1'; 
			   	balance <= "0001" ;
				returnAmount <= "0110";   
				drinksChoice <= "01";  -- 01 represents tee used in display reasons

                           elsif ( euroIn = '1' and twentyCent = '0'and tee= '0' and coffee ='1') then ----- the chosen drink is coffee for 60 cent
                           	DispenseD <= '1'; 
			   	balance <= "0001" ;
				returnAmount <= "0100";   
				drinksChoice <= "10"; -- 10 represents tee used iin display reasons
 
   			   elsif ( euroIn = '1' and twentyCent = '0' and tee= '1' and coffee ='1') then ----- the chosen drink are  coffee for 60 cent and tee for 40 cent
			   	DispenseD <= '1'; 
			   	balance <= "0001" ;
				returnAmount <= "0000";   
				drinksChoice <= "11"; -- 11 represents tee + coffee used iin display reasons
                           else
			   	DispenseD <= '0'; 
			   	balance <= "0000" ;
				returnAmount <= "0000";   
				drinksChoice <= "00"; -- 00 represent no drinks used iin display reasons
                           end if;

   		 when s20 => 	DispenseD <= '0'; 
			   	balance <= "0010" ;
				returnAmount <= "0000";   
				drinksChoice <= "00"; -- 00 represent no drinks used iin display reasons
			

   		 when s40 => if ( twentyCent = '1' and euroIn = '0' and tee = '0' and coffee = '1') then --- paid the exact price amount of coffee 
                          	DispenseD <= '1'; 
			   	balance <= "0110" ; -- 60 cents balance
				returnAmount <= "0000";   
				drinksChoice <= "10";
                           elsif ( twentyCent = '0' and euroIn = '0' and tee = '1' and coffee = '0') then --- have 40 cents in balance and asked for tee as a drink
                           	DispenseD <= '1'; 
			   	balance <= "0100" ; -- 40 cents
				returnAmount <= "0000";   
				drinksChoice <= "01";
                           else 
                           	DispenseD <= '0'; 
			   	balance <= "0100" ;
				returnAmount <= "0000";   
				drinksChoice <= "00";
                           end if;



	when others => 	DispenseD <= '0'; 
		       	balance <= "0000" ;
			returnAmount <= "0000";   
			drinksChoice <= "00";

 end case;
end process;


end architecture;
                           