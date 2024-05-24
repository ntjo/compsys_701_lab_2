library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.TdmaMinTypes.all;

entity ConfigAspAvg is	
	port (
		clock : in  std_logic;
		send  : out tdma_min_port;
		recv  : in  tdma_min_port

	);
end entity;

architecture rtl of ConfigAspAvg is
	-- signals here 
	type fifo_array is array (0 to 7) of signed(15 downto 0);	
	signal fifo2 : fifo_array := (others => (others => '0'));
begin
	process(clock)
		-- variables here
		variable sum : signed(15 downto 0) := (others => '0');
		variable window_size : natural range 4 to 8 := 4;
		variable fifo : fifo_array := (others => (others => '0'));
		variable tail : natural range 0 to 7 := 0;
		variable temp: signed(15 downto 0);
	begin
		if rising_edge(clock) then
			if recv.data(31 downto 28) = "1000" then -- data signal
			
				temp := signed(recv.data(15 downto 0));

				sum := (sum + temp - fifo(tail));

				fifo(tail) := temp;

				tail := (tail + 1) mod window_size;

				--send.data <= x"8000" & std_logic_vector(sum / window_size);
				if window_size = 4 then
					send.data <= x"8000" & std_logic_vector(shift_right(sum, 2));
				else 
					send.data <= x"8000" & std_logic_vector(shift_right(sum, 3));
				end if;
				send.addr <= x"01";
			elsif recv.data(31 downto 28) = "1010" then -- configuration signal / mode: 0 (window_size = 4)
				send.addr <= "0000" & recv.data(23 downto 20);
				if recv.data(19 downto 16) = "0000" then
					window_size := 4;
				else 
					window_size := 8;
				end if;
			else 
				send.data <= (others => '0');
			end if;
			fifo2 <= fifo;
		end if;
	end process;

end architecture;

