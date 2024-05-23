library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
--use work.TdmaMinTypes.all;

entity AspAvg is
	generic (
		WINDOW_SIZE : integer := 4 	-- size of n
	);
	port (
		clock 		: in  std_logic;			-- clk
		adc_data 	: in std_logic_vector(7 downto 0);	-- 8-bit ADC data input
		adc_rdy 	: in std_logic;				-- 1-bit ready control signal
		avg_res 	: out std_logic_vector(15 downto 0);	-- 16-bit AVG data output
		avg_rdy 	: out std_logic				-- 1-bit ready control signal
	);
end entity;

architecture rtl of AspAvg is

	-- signals here 
	type fifo_array is array (0 to WINDOW_SIZE-1) of std_logic_vector(7 downto 0);
	signal fifo : fifo_array := (others => (others => '0'));
	signal head, tail : integer range 0 to WINDOW_SIZE-1 := 0;
	signal sum : std_logic_vector(15 downto 0) := (others => '0');	
	signal count : integer range 0 to WINDOW_SIZE := 0;
	
begin
	
	process(clock)
		-- variable to hold sum
		variable temp_sum : std_logic_vector(15 downto 0);
	begin
		if rising_edge(clock) then
			if adc_rdy = '1' then 
				
				-- Use temp_sum to handle calculations
				temp_sum := sum;
				
				if count = WINDOW_SIZE then 					-- if FIFO is full
					-- Subtract the oldest sample
					temp_sum := temp_sum - fifo(head);
					-- if (head + 1) = WINDOW_SIZE, head = 0
					head <= (head + 1) mod WINDOW_SIZE;
				else
					count <= count + 1;
				end if;
				
				-- Add the new sample
				temp_sum := temp_sum + adc_data;
				
				-- Update the buffer array tail
				fifo(tail) <= adc_data;
				-- if (tail + 1) = WINDOW_SIZE, tail = 0
				tail <= (tail + 1) mod WINDOW_SIZE;
				
				-- Update sum with temp_sum
				sum <= temp_sum;

				-- Set control signal for next clock cycle
				avg_rdy <= '1';
				
			else 
				avg_rdy <= '0';
			end if;
			-- if on last clock cycle adc was received, send average
			if adc_rdy = '1' then
				avg_res <= temp_sum;
			end if;
		end if;
	end process;

end architecture;