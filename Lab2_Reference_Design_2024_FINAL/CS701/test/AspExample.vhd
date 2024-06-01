library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity AspExample is
    port (
        clock : in  std_logic;
        key   : in  std_logic_vector(3 downto 0);
        send  : out tdma_min_port;
        recv  : in  tdma_min_port
    );
end entity;

architecture rtl of AspExample is
begin

    process(clock)
        variable state : natural := 0;
    begin
        if rising_edge(clock) then
            -- Check for key pulse on key(0)
            if key(0) = '1' then
                if state > 4 then
                    state := 10;
                else
                    state := 10;
                end if;
            end if;

            -- Process data if available
            if recv.data(31 downto 28) = "1000" and recv.data(16) = '0' and key(2) = '1' then
                send.addr <= x"03";
                send.data <= recv.data;
            elsif recv.data(31 downto 28) = "1000" and recv.data(16) = '1' and key(1) = '1' then
                send.addr <= x"03";
                send.data <= recv.data;
            else
                case state is
                    when 10 =>
						send.addr <= x"03";
						send.data <= "1100" & "0010" & "0101" & "1000" & x"0000";
                        
                        state := 9;
                    when 9 =>
						send.addr <= x"02";
						send.data <= "1011" & "0010" & "0011" & "11" & "001" & "000" & x"000";
                        
                        state := 8;
                    when 8 =>
						send.addr <= x"01";
						send.data <= "1010" & "0001" & "0010" & "1100" & x"0000";
                        
                        state := 7;
                    when 7 =>
						send.addr <= x"00";
						send.data <= "1001" & "0000" & "0001" & "1100" & x"0000";
                        state := 6;
                    when 4 =>
                        send.addr <= x"01";
                        send.data <= x"00000000";
                        state := 3;
                    when 3 =>
                        send.addr <= x"00";
                        send.data <= x"00000000";
                        state := 2;
                    when others =>
                        send.addr <= x"01";
                        send.data <= x"00000000";
                end case;
            end if;
        end if;
    end process;

end architecture;
