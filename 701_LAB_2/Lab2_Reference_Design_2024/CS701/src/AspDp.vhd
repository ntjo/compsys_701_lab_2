library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity AspDp is
	port (
		clock : in  std_logic;
		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture rtl of AspDp is

	signal addr : std_logic_vector(3 downto 0) := "0001";
	signal data : signed(15 downto 0); 
	signal tmp0 : signed(15 downto 0);
	signal tmp1 : signed(15 downto 0);
	signal abstmp : signed(15 downto 0);
	
begin
	
	process(clock)
		variable digit : signed(15 downto 0) := "0001000000000000";
	begin
		if rising_edge(clock) then
			if recv.data(31 downto 28) = "1000" and recv.data(16) = '0' then
				tmp0 <= signed(recv.data(15 downto 0));
			
				data <= shift_left((tmp0), 1);
				--abstmp <= abs(signed(data(15 downto 0)));
				--send.addr <= "00000001";
				if (data >= digit) then
					send.data <= x"8000" & std_logic_vector(digit);
				elsif(data <= -digit) then
					send.data <= x"8000" & std_logic_vector(-digit);
				else
					send.data <= x"8000" & std_logic_vector(data(15 downto 0));
				end if;
				
			elsif recv.data(31 downto 28) = "1000" and recv.data(16) = '1' then
				tmp0 <= signed(recv.data(15 downto 0));
			
				data <= shift_left((tmp0), 1);
				--abstmp <= abs(signed(data(15 downto 0)));
				--send.addr <= "00000001";
				if (data >= digit) then
					send.data <= x"8001" & std_logic_vector(digit);
				elsif(data <= -digit) then
					send.data <= x"8001" & std_logic_vector(-digit);
				else
					send.data <= x"8001" & std_logic_vector(data(15 downto 0));
				end if;
			elsif recv.data(31 downto 28) = "1001" then
				addr <= recv.data(23 downto 20);
				send.addr <= "0000" & addr;
			end if;
		end if;
	end process;

end architecture;