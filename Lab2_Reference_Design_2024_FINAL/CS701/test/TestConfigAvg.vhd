library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity TB_ADC_AVERAGER is
end TB_ADC_AVERAGER;

architecture beh of TB_ADC_AVERAGER is
component ConfigAspAvg is
	port (
		clock : in  std_logic;
		send  : out tdma_min_port;
		recv  : in  tdma_min_port

	);
end component;

signal t_clock : std_logic := '0';
signal t_send : tdma_min_port;
signal t_recv : tdma_min_port;

begin
	tb : AspAvg
	
	port map (
		clock => t_clock,
		adc_data => t_adc_data,
		adc_rdy => t_adc_rdy,
		avg_res => t_avg_res,
		avg_rdy => t_avg_rdy
	);

	clock_process : process
	begin
		t_clock <= '1';
		wait for 10 ns;
		t_clock <= '0';
		wait for 10 ns;
	end process;

	sim : process
	begin
		
		for i in 0 to 12 loop
			t_adc_data <= std_logic_vector(to_unsigned(i, 8));
			t_adc_rdy <= '1';
			wait until rising_edge(t_clock);
			t_adc_rdy <= '0';
			wait until rising_edge(t_clock);
		end loop;
		wait for 500 ns;
		wait;
	end process;
end beh;