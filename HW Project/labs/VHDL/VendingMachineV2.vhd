library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

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
       An0,Display: out STD_LOGIC_VECTOR(7 downto 0);
       LED_s20, LED_s40: out std_logic
);
end entity;

architecture DrinksVending_arch of VendingM is
type states is (idle, s20, s40);
signal currentState, nextState: states;
	signal Refresh_counter: STD_LOGIC_VECTOR( 19 downto 0);
	signal Led_activation: STD_LOGIC_VECTOR(2 downto 0);
	signal DataDisp,sw1: STD_LOGIC_VECTOR(3 downto 0);
	signal Disp: STD_LOGIC_VECTOR(7 downto 0);
	signal sw0: STD_LOGIC_VECTOR(1 downto 0);
	signal drinksChoice: std_logic_vector ( 1 downto 0);
	signal balance, returnAmount: std_logic_vector( 3 downto 0);
        signal DispenseD : std_logic;
	signal secDealy: integer range 0 to 50000000;
	signal idiotcoffee: STD_LOGIC:= '0';
begin

----------------------------------------------

--Process 1: for storing

State_Memory_Process: process (Clock, Reset)
begin

	if( Reset = '1') then
		currentState <= idle;
	elsif (rising_edge(Clock)) then
   --  elsif (Clock'event and Clock ='1') then
			currentState <= nextState;
	end if;
end process;

----------------------------------------------

--Process 2: for logic

Next_State_Process: process (currentState, twentyCent, euroIn, tee, coffee)
--( currentState, euroIn, twentyCent, tee, coffee)

begin

	case (currentState) is

  		 when idle => if ( twentyCent = '1' and euroIn= '0') then
			                 nextState <= s20;    
			                 
			          --       LED_s40 <= '0';                                                                                                 
			        elsif (twentyCent = '0' and euroIn = '1' )then
			              nextState <= idle;
			         --     LED_s20 <= '0'; 
			         --     LED_s40 <= '0';
			       elsif (twentyCent = '0' and euroIn = '0') then
					nextState <= idle;
				  else
					nextState <= idle;
                      end if;

   		 when s20 => if ( twentyCent = '1') then --and tee= '1' and coffee= '0') then		
                            nextState <= s40;
                     --       LED_s40 <= '1'; 
                     --       LED_s20 <= '0'; 
           --          elsif ( twentyCent = '0'and tee= '0' and coffee= '1') then		--  it was( twentyCent = '1'and tee= '0' and coffee= '1')
             --               nextState <= s40;
                     else
                            nextState <= s20;
                     end if;

   		 when s40 => if ( twentyCent = '1' and tee ='0') then --and coffee = '1' and tee = '0') then
                           nextState <= s40;
                      -- elsif(twentyCent = '0') then -- and coffee = '0' and tee ='1') then
                       --    nextState <= idle;
		     else
				--if secDealy = 50000000 then
			         	nextState <= idle;

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
                DispenseD <= '1'; 
			   	balance <= "0001" ;
				returnAmount <= "0110";   
				drinksChoice <= "10";  -- 01 represents tee used in display reasons

               
                elsif ( euroIn = '1' and tee= '0' and coffee ='1') then ----- the chosen drink is coffee for 60 cent
                DispenseD <= '1'; 
			   	balance <= "0001" ;
				returnAmount <= "0100";   
				drinksChoice <= "01"; -- 10 represents tee used iin display reasons
 
   			    elsif ( euroIn = '1' and tee= '1' and coffee ='1') then ----- the chosen drink are  coffee for 60 cent and tee for 40 cent
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
		if (idiotCoffee = '1') then
			idiotCoffee <= '0';
			DispenseD <= '1'; 
			balance <= "0110" ;
			returnAmount <= "0000";   
			drinksChoice <= "10"; -- 00 represent no drinks used iin display reasons
		end if;
                LED_s40 <= '0'; 
                LED_s20 <= '0'; 
   		 when s20 => if (tee = '1' and coffee= '0') then
   		        DispenseD <= '0'; 
			   	balance <= "0010" ;
				returnAmount <= "0000";   
				drinksChoice <= "10"; -- 00 represent no drinks used iin display reasons
				elsif ( tee ='0' and coffee= '1') then
				DispenseD <= '0'; 
			   	balance <= "0010" ;
				returnAmount <= "0000";   
				drinksChoice <= "01"; -- 00 represent no drinks used iin display reasons
				else
				DispenseD <= '0'; 
			   	balance <= "0010" ;
				returnAmount <= "0000";   
				drinksChoice <= "00"; -- 00 represent no drinks used iin display reasons
			    end if;
			    LED_s20 <= '1'; 
                
   		 when s40 => if  (tee = '1' and coffee = '0') then --- have 40 cents in balance and asked for tee as a drink
                DispenseD <= '1'; 
			   	balance <= "0100" ; -- 40 cents
				returnAmount <= "0000";   
				drinksChoice <= "01";
				
			   -- elsif  ( twentyCent = '0' and tee = '0' and coffee = '1') then --- have 40 cents in balance and asked for tee as a drink
                		--DispenseD <= '0'; 
			   	--balance <= "0100" ; -- 40 cents
				--returnAmount <= "0000";   
				--drinksChoice <= "10";
				
				
                --elsif ( tee = '0' and coffee = '1' ) then -- (twentyCent = '1'  and tee = '0' and coffee = '1') then --- paid the exact price amount of coffee 
    --            DispenseD <= '1'; 
			   --	balance <= "0110" ; -- 60 cents balance
	--			returnAmount <= "0000";   
	--			drinksChoice <= "01";
				
		elsif (tee = '0' and coffee = '1') then --- have 40 cents in balance and asked for tee as a drink
                DispenseD <= '0'; 
			   	balance <= "0100" ; -- 40 cents
				returnAmount <= "0000";   
		    		drinksChoice <= "10";                 --changing to check the 20 cents output on fpga
				idiotCoffee <= '1';
				
                end if;

                LED_s40 <= '1';
				LED_s20 <= '0'; 
				
	   when others => 	DispenseD <= '0'; 
		       	        balance <= "0000" ;
			        returnAmount <= "0000";   
			        drinksChoice <= "00";

 end case;
end process;
--------------------------------------------------------------------------------------------------
--Seven segment Display process

	Refresh: process(Clock ,Reset)
	begin 
   		if(Reset='1') then         --- reset = 1 does reset all the seven segments except the 6 & 7
        		refresh_counter <= (others => '0');
			secDealy <= 0;
    		elsif(rising_edge(Clock)) then
        		refresh_counter <= refresh_counter+1;
			secDealy <= secDealy+1;
    		end if;
	end Process;
	Led_activation <= Refresh_counter(19 downto 17);
	DisplayBCD: process(Led_Activation)
	begin 
		sw0 <= drinksChoice;
		Case(Led_activation) is           -- Led-activation for anode activation
		when "000" =>
			An0 <= "01111111";
			if(sw0 = "00") then
				DataDisp <= "0000";
			elsif(sw0 = "01") then
				DataDisp <= "1101";
			elsif(sw0 = "10") then
				DataDisp <= "0101";
			elsif(Sw0 = "11") then
				DataDisp <= "1101";
			else
				DataDisp <= "0000";
			end if;
		when "001" =>
			An0 <= "10111111";
			if(Sw0 = "11") then
				DataDisp <= "0101";
			else
				DataDisp <= "0000";
			end if;
		when"010" =>
			An0 <= "11011111";
			if(sw0 = "01") then
				DataDisp <= "0000";
			elsif(sw0 = "10") then
				DataDisp <= "0000";
			elsif(sw0 = "11") then
				DataDisp <= "0001";
			else
				DataDisp <= "0000";
			end if;
		when "011" =>
			An0 <= "11101111";
			if(sw0 = "01") then
				DataDisp <= "0110";
			elsif(sw0 = "10") then
				DataDisp <= "0100";
			else
				DataDisp <= "0000";
			end if;
		when "100" =>
			An0 <= "11110111";
			if DispenseD = '1' then
				DataDisp <= "1001"; --change it to Display D
			else 
				DataDisp <= "0111"; --change it to Display N=n
			end if;
		when "101" =>
			An0 <= "11111101";
			--if DispenseD = '0' then
				DataDisp <= balance;
			--else
				--DataDisp <= returnAmount;
			--end if;

		when others =>
			An0 <= "11111110";
			DataDisp <= returnAmount;

		end case;
	end process;
	CallDisp: process (DataDisp)
	begin
    	case DataDisp is
    		when "0000" => Display <= "00000011"; -- "0"     
    		when "0001" => Display <= "10011111"; -- "1" 
    		when "0010" => Display <= "00100101"; -- "2" 
    		when "0011" => Display <= "00001101"; -- "3" 
    		when "0100" => Display <= "10011001"; -- "4" 
    		when "0101" => Display <= "11100001"; -- "t"  CAN CHANGE IT
    		when "0110" => Display <= "01000001"; -- "6" 
    		when "0111" => Display <= "11010101"; -- "n"  CAN CHANGE IT
    		when "1000" => Display <= "00000001"; -- "8"     
    		when "1001" => Display <= "10000101"; -- "d"  CAN CHANGE IT
    		when "1010" => Display <= "00000010"; -- 0.
    		when "1011" => Display <= "10011110"; -- 1.
    		when "1100" => Display <= "00100100"; -- 2.
    		when "1101" => Display <= "01100011"; -- C
    		when "1110" => Display <= "01100001"; -- E
    		when others => Display <= "01110001"; -- F
    	end case;
	end process;

end architecture;
