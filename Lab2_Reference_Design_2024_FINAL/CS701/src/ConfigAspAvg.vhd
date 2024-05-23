library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

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
	type fifo_array is array (0 to 7) of std_logic_vector(7 downto 0);
	signal addr : std_logic_vector(3 downto 0) := "0001";
	
begin
	
	process(clock)
		-- variables here
		variable sum : signed(15 downto 0) := (others => '0');
		variable window_size : integer := 4;
		variable fifo : fifo_array := (others => (others => '0'));
		variable tail : integer range 0 to 7 := 0;
	begin
		if rising_edge(clock) then
			if recv.data(31 downto 28) = "1000" and recv.data(16) = '0' then -- data signal
				
					sum := sum + signed(recv.data(7 downto 0)) - signed(fifo(tail));

					fifo(tail) := recv.data(7 downto 0);

					tail := (tail + 1) mod window_size;

					send.data <= x"8000" & std_logic_vector(sum);
				
			elsif recv.data(31 downto 28) = "1000" and recv.data(16) = '1' then -- data signal
				
					sum := sum + signed(recv.data(7 downto 0)) - signed(fifo(tail));

					fifo(tail) := recv.data(7 downto 0);

					tail := (tail + 1) mod window_size;

					send.data <= x"8000" & std_logic_vector(sum);

			elsif recv.data(31 downto 28) = "1001" and recv.data(19 downto 16) = "0000" then -- configuration signal / mode: 0 (window_size = 4)
				addr <= recv.data(23 downto 20);
				send.addr <= "0000" & addr;
				window_size := 4;
			elsif recv.data(31 downto 28) = "1001" and recv.data(19 downto 16) = "0001" then -- configuration signal / mode: 1 (window_size = 8)
				addr <= recv.data(23 downto 20);
				send.addr <= "0000" & addr;
				window_size := 8;
			end if;
		end if;
	end process;

end architecture;