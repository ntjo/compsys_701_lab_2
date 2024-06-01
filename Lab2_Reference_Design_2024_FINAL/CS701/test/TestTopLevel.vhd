library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;

entity TestTopLevel is
	-- generic (
	-- 	ports : positive := 8
	-- );
end entity;

architecture sim of TestTopLevel is

	signal clock : std_logic := '1';

	-- signal send_port : tdma_min_ports(0 to ports-1);
	-- signal recv_port : tdma_min_ports(0 to ports-1);

	-- signal reset : std_logic := '0';
	signal key : std_logic_vector(3 downto 0) := (others => '0');
    signal key_pulse : std_logic_vector(3 downto 0) := (others => '0');


begin

	clock <= not clock after 10 ns;

	-- tdma_min : entity work.TdmaMin
	-- generic map (
	-- 	ports => ports
	-- )
	-- port map (
	-- 	clock => clock,
	-- 	sends => send_port,
	-- 	recvs => recv_port
	-- );

	-- asp_adc : entity work.TestAdc
	-- generic map (
	-- 	forward => 2
	-- )
	-- port map (
	-- 	clock => clock,
	-- 	send  => send_port(0),
	-- 	recv  => recv_port(0)
	-- );
	-- asp_avg : entity work.ConfigAvgAsp
	-- port map (
	-- 	clock => clock,
	-- 	send  => send_port(2),
	-- 	recv  => recv_port(2)
	-- );
	-- asp_dac : entity work.TestDac
	-- port map (
	-- 	clock => clock,
	-- 	send  => send_port(1),
	-- 	recv  => recv_port(1)
	-- );
	-- test_avg : entity work.TestAvg
	-- generic map (
	-- 	forward => 2
	-- )
	-- port map (
	-- 	send => send_port(3),
	-- 	recv => recv_port(3)
	-- );

	-- NEW STUFF HERE

	-- TestConfigAdc : entity work.tb_ConfigAdcAspNEW
	-- generic map (
	-- 	forward => 2
	-- )
	-- port map (
	-- 	clock 	=> clock,
	-- 	send  	=> send_port(0),
	-- 	recv  	=> recv_port(0)
	-- );

	-- TestConfigAvg: entity work.tb_ConfigAvgAsp
	-- generic map (
	-- 	forward => 2
	-- )
	-- port map (
	-- 	clock 	=> clock,
	-- 	send 	=> send_port(1),
	-- 	recv 	=> recv_port(1)
	-- );

	process (clock)
	begin
		if rising_edge(clock) then
			if now = 20 ns then
				key_pulse(0) <= '1';
			else
				key_pulse(0) <= '0';
			end if;
		end if;
	end process;

	testTopLevel : entity work.TopLevel
	port map (
		CLOCK_50 => clock,
		key => key_pulse
	);

end architecture;
