LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_rom_new IS
END ENTITY;

ARCHITECTURE behavior OF tb_rom_new IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT rom_new
    PORT(
        clock       : IN  std_logic := '1';
        q           : OUT std_logic_vector(11 DOWNTO 0);
        sample_delay: IN  natural
    );
    END COMPONENT;
    
    -- Signals for the testbench
    SIGNAL clock       : std_logic := '0';
    SIGNAL q           : std_logic_vector(11 DOWNTO 0);
    SIGNAL sample_delay: natural := 0;
    
    -- Clock period definition
    CONSTANT clock_period : time := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: rom_new PORT MAP (
          clock => clock,
          q => q,
          sample_delay => sample_delay
        );

    -- Clock process definitions
    clock_process :process
    begin
        while True loop
            clock <= '0';
            wait for clock_period / 2;
            clock <= '1';
            wait for clock_period / 2;
        end loop;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin		
        -- hold reset state for 100 ns.
        wait for 100 ns;	
        
        -- Insert test values here
        sample_delay <= 1;
        wait for 100 ns;
        
        sample_delay <= 5;
        wait for 100 ns;
        
        sample_delay <= 10;
        wait for 100 ns;
        
        -- Add further test cases as needed
        wait;
    end process;

END;
