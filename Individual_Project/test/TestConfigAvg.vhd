library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestRecop is
    generic (
        forward : natural
    );
    port (
        send  : out tdma_min_port;
        recv  : in  tdma_min_port
    );
end entity;

architecture sim of TestRecop is

begin

    send.addr <= std_logic_vector(to_unsigned(forward, tdma_min_addr'length));

    process
    begin
        -- Initial wait for 50 ns
        wait for 50 ns;
        
        -- Set send.data to all zeros
        send.data <= x"A0130000"; -- 1010 0000 0001 0011 0000 0000
        
        -- Wait indefinitely to prevent the process from terminating
        wait for 20 ns;
        
    send.data <= (others => '0');
    end process;

end architecture;