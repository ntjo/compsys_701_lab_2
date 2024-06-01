LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

library work;
use work.TdmaMinTypes.all;

ENTITY ADC_ASP_tb IS
END ADC_ASP_tb;

ARCHITECTURE behavior OF ADC_ASP_tb IS

    -- Signals for interfacing with ADC_ASP
    SIGNAL clk            : std_logic := '0';
    SIGNAL send           : tdma_min_port;
    SIGNAL recv           : tdma_min_port;

    -- Component under test
    COMPONENT ADC_ASP
    PORT(
        clk            : IN std_logic;
        send           : OUT tdma_min_port;
        recv           : IN tdma_min_port
    );
    END COMPONENT;
BEGIN
    -- Clock generation
    CLOCKING: PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 10 ns;
        clk <= '1';
        WAIT FOR 10 ns;
        clk <= NOT clk;
    END PROCESS CLOCKING;

    -- Instance of ADC_ASP
    uut: ADC_ASP PORT MAP (
        clk          => clk,
        send         => send,
        recv         => recv
    );

    -- Test stimulus process
    STIMULUS: PROCESS
    BEGIN
        -- Initialize inputs
        recv.data <= (others => '0');

        -- Simulate configuration data reception
        WAIT FOR 20 ns;
        recv.data <= "10010000001010100000000000000000";
        WAIT FOR 20 ns;
        recv.data <= (others => '0');

        -- Complete the simulation
        
        WAIT;
    END PROCESS STIMULUS;


END behavior;
