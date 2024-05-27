library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity ConfigAdcAsp is
	port (
		clock : in  std_logic;
		reset : in std_logic;


		send  : out tdma_min_port;
		recv  : in  tdma_min_port
	);
end entity;

architecture beh of ConfigAdcAsp is

-- signals here
signal sample_rate : := 

begin

	process(clock)
	begin
		if rising_edge(clock) then
			if reset = '1' then
				-- reset things to 0
			else
				sample_rate <= (unsigned(sample_delay) + 1);-- 100 MHz / (sample_delay + 1)
			end if;
	end process;

	process(clock)
	
	-- variables here
	sample_delay : std_logic_vector(15 downto 0) := (others => '0');
	bit_sel -- 8, 10, 12-bit data
	
	begin
		if rising_edge(clock) then
			if reset = '1' then
				-- reset things to 0
			elsif recv.data(31 downto 28) = "1001" then
				-- config msg
				sample_delay := recv.data(15 downto 0);
				bit_sel := recv.data(19 downto 19);
				
			elsif newdata then
				if delay /= '0' then
					delay = delay - 1;
					
				else
					case bit_sel is
					when "00" =>
						-- output is 8-bits
						send.data <= "00000000" &  data
					when "01" =>
						-- output is 10-bits
						send.data <= "00000
					when "10" =>
						-- output is 12-bits
					when others =>
			else 
				send.data <= (others => '0');
			end if;
		
	end process;

end architecture beh;