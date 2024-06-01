library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.TdmaMinTypes.all;

entity tb_ConfigAdcAsp is
end entity;

architecture testbench of tb_ConfigAdcAsp is

    component ConfigAdcAsp is
        port (
            clock : in  std_logic;
            reset : in std_logic;
            send  : out tdma_min_port;
            recv  : in  tdma_min_port
        );
    end component;

    signal clock     : std_logic := '0';
    signal reset     : std_logic := '0';
    signal send      : tdma_min_port;
    signal recv      : tdma_min_port;

    constant clock_period : time := 10 ns;

begin

    uut: ConfigAdcAsp
        port map (
            clock => clock,
            reset => reset,
            send  => send,
            recv  => recv
        );

    -- Clock generation
    clock_process : process
    begin
        while true loop
            clock <= '0';
            wait for clock_period / 2;
            clock <= '1';
            wait for clock_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Initial reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Test case 1: Send a configuration message
        recv.data <= x"9000_0000"; -- Configuration message with delay 0, bit_sel 0
        wait for clock_period;

        recv.data <= x"9000_0001"; -- Configuration message with delay 1, bit_sel 0
        wait for clock_period;

        recv.data <= x"9000_0002"; -- Configuration message with delay 2, bit_sel 0
        wait for clock_period;

        -- Test case 2: Change bit selection
        recv.data <= x"9000_4001"; -- Configuration message with delay 1, bit_sel 01
        wait for clock_period;

        recv.data <= x"9000_8001"; -- Configuration message with delay 1, bit_sel 10
        wait for clock_period;

        -- Test case 3: Observe send data
        wait for 100 ns;

        -- End simulation
        wait;
    end process;

end architecture;
