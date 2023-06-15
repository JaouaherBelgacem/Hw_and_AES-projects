library IEEE;
use IEEE.std_logic_1164.all;

entity vendingMtb is
end entity;

architecture testbench of vendingMtb is

    -- Constants
    constant CLK_PERIOD: time := 10 ns;

    -- Signals
    signal clk: std_logic := '0';
    signal reset_tb, euroIn_tb, twentyCent_tb, tee_tb, coffee_tb, DispenseD_tb: std_logic;
    signal drinksChoice_tb : std_logic_vector(1 downto 0);
    signal balance_tb, returnAmount_tb: std_logic_vector ( 3 downto 0);
    -- Component declaration
    component vendingM is
        port (
            Clock: in std_logic;
            Reset: in std_logic;
            euroIn: in std_logic;
            twentyCent: in std_logic;
            tee: in std_logic;
            coffee: in std_logic;
            drinksChoice: out std_logic_vector(1 downto 0);
            balance: out std_logic_vector(3 downto 0);
            returnAmount: out std_logic_vector(3 downto 0);
            DispenseD: out std_logic
        );
    end component;

begin

    -- DUT instantiation
    dut: vendingM
        port map (
            Clock => clk,
            Reset => reset_tb,
            euroIn => euroIn_tb,
            twentyCent => twentyCent_tb,
            tee => tee_tb,
            coffee => coffee_tb,
            drinksChoice => drinksChoice_tb,
            balance => balance_tb,
            returnAmount => returnAmount_tb,
            DispenseD => DispenseD_tb
        );

    -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop  -- Simulation duration
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        reset_tb <= '1';
        euroIn_tb <= '0';
        twentyCent_tb <= '0';
        tee_tb <= '0';
        coffee_tb <= '0';
        wait for 50 ns;
        reset_tb <= '0';

        -- Test Case : Choosing tee for 40 cents
        euroIn_tb <= '1';
        twentyCent_tb <= '0';
        tee_tb <= '1';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "01" report "Test Case 1 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0001" report "Test Case 1 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0110" report "Test Case 1 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '1' report "Test Case 1 Failed: DispenseD signal not asserted" severity error;
        wait for 10 ns;

        -- Test Case : Choosing coffee for 60 cents
        euroIn_tb <= '1';
        twentyCent_tb <= '0';
        tee_tb <= '0';
        coffee_tb <= '1';
        wait for 10 ns;
        assert drinksChoice_tb = "10" report "Test Case 2 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0001" report "Test Case 2 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0100" report "Test Case 2 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '1' report "Test Case 2 Failed: DispenseD signal not asserted" severity error;
        wait for 10 ns;

        -- Test Case : Choosing both coffee and tee
        euroIn_tb <= '1';
        twentyCent_tb <= '0';
        tee_tb <= '1';
        coffee_tb <= '1';
        wait for 10 ns;
        assert drinksChoice_tb = "11" report "Test Case 3 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0001" report "Test Case 3 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 3 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '1' report "Test Case 3 Failed: DispenseD signal not asserted" severity error;
        wait for 10 ns;

        -- Test Case : No drinks chosen and no money inserted
        euroIn_tb <= '0';
        twentyCent_tb <= '0';
        tee_tb <= '0';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "00" report "Test Case 4 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0000" report "Test Case 4 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 4 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '0' report "Test Case 4 Failed: DispenseD signal asserted" severity error;
        wait for 10 ns;

        -- Test Case : Inserting 20 cents, no drinks chosen
        euroIn_tb <= '0';
        twentyCent_tb <= '1';
        tee_tb <= '0';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "00" report "Test Case 5 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0010" report "Test Case 5 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 5 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '0' report "Test Case 5 Failed: DispenseD signal asserted" severity error;
        wait for 10 ns;

        -- Test Case : Inserting 20 cents twice, tee chosen
        euroIn_tb <= '0';
        twentyCent_tb <= '1';
        tee_tb <= '1';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "01" report "Test Case 6 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0100" report "Test Case 6 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 6 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '1' report "Test Case 6 Failed: DispenseD signal asserted" severity error;
        wait for 10 ns;

        -- Test Case : Inserting 20 cents three times, no drinks chosen
        euroIn_tb <= '0';
        twentyCent_tb <= '1';
        tee_tb <= '0';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "00" report "Test Case 7 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0010" report "Test Case 7 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 7 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '0' report "Test Case 7 Failed: DispenseD signal asserted" severity error;
        wait for 10 ns;

        -- Test Case 8: Inserting 20 cents, then 40 cents, choosing coffee
        euroIn_tb <= '0';
        twentyCent_tb <= '1';
        tee_tb <= '0';
        coffee_tb <= '1';
        wait for 10 ns;
        assert drinksChoice_tb = "10" report "Test Case 8 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0110" report "Test Case 8 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 8 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '1' report "Test Case 8 Failed: DispenseD signal not asserted" severity error;
        wait for 10 ns;

        -- Test Case 9: Inserting 40 cents, choosing tee
        euroIn_tb <= '0';
        twentyCent_tb <= '1';
        tee_tb <= '1';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "01" report "Test Case 9 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0100" report "Test Case 9 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 9 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '1' report "Test Case 9 Failed: DispenseD signal not asserted" severity error;
        wait for 10 ns;

        -- Test Case 10: No valid input, no drinks chosen
        euroIn_tb <= '1';
        twentyCent_tb <= '1';
        tee_tb <= '0';
        coffee_tb <= '0';
        wait for 10 ns;
        assert drinksChoice_tb = "00" report "Test Case 10 Failed: Incorrect drinks choice" severity error;
        assert balance_tb = "0100" report "Test Case 10 Failed: Incorrect balance" severity error;
        assert returnAmount_tb = "0000" report "Test Case 10 Failed: Incorrect return amount" severity error;
        assert DispenseD_tb = '0' report "Test Case 10 Failed: DispenseD signal asserted" severity error;
        wait for 10 ns;

        -- End of simulation
        wait;
    end process;

end architecture;
