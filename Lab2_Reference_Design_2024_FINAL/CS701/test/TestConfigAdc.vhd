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
            reset : in  std_logic;
            send  : out tdma_min_port;
            recv  : in  tdma_min_port
            -- bit_sel_out : out std_logic_vector(1 downto 0);
            -- sample_delay_out : out natural;
            -- rom_data_port : out std_logic_vector(11 downto 0);
            -- data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Clock and reset signals
    signal clock : std_logic := '0';
    signal reset : std_logic := '0';

    -- TdmaMinPort signals
    signal send  : tdma_min_port;
    signal recv  : tdma_min_port;

    constant clock_period : time := 10 ns;
    -- signal rom_data_port : std_logic_vector(11 downto 0);
    -- signal data_out : std_logic_vector(31 downto 0);
    -- signal bit_sel_out :  std_logic_vector(1 downto 0);
    -- signal sample_delay_out :  natural;
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ConfigAdcAsp
        port map (
            clock => clock,
            reset => reset,
            send  => send,
            recv  => recv
            -- bit_sel_out => bit_sel_out,
            -- sample_delay_out => sample_delay_out,
            -- rom_data_port => rom_data_port,
            -- data_out => data_out

        );

    -- Clock generation process
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

    -- Stimulus process to apply test vectors
    stimulus_process : process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        recv.data <= (others => '0');

        wait for 20 ns;

        -- Test case 1: Send a configuration message
        recv.data <= x"912A0001"; -- Configuration message with delay 1, bit_sel 0, enable 1
        -- CONFIG MSG: 1001 DEST: 1 NEXT: 2 BIT_SEL: 10 EN: 1 SAMPLE DELAY: 1  

        -- recv.data <= "10010001001000100000000000000001";
        -- wait for clock_period;

        -- recv.data <= x"91220002"; -- Configuration message with delay 2, bit_sel 0, enable 1
        -- wait for clock_period;

        -- -- Test case 2: Change bit selection
        -- recv.data <= x"91260001"; -- Configuration message with delay 1, bit_sel 01, enable 1
        -- wait for clock_period;

        -- recv.data <= x"912A0001"; -- Configuration message with delay 1, bit_sel 10, enable 1
        -- wait for clock_period;

        -- -- Test case 3: Disable the configuration
        -- recv.data <= x"90000000"; -- Configuration message with delay 0, bit_sel 0, enable 0
        -- wait for clock_period;

        -- -- Wait for some time to observe outputs
        -- wait for 200 ns;

        -- End simulation
        wait for 20 ns;
        recv.data <= (others => '0');
        wait;
    end process;

end architecture;
