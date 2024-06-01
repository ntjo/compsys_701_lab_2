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


	Component rom_test IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
	END component rom_test;

	-- signals here
	signal sample_delay   : std_logic_vector(15 downto 0) := (others => '0');
   signal bit_sel        : std_logic_vector(1 downto 0) := (others => '0');
	signal sample_rate    : unsigned(31 downto 0) := (others => '0');

	-- ROM STUFF
   signal addr           : std_logic_vector(7 downto 0) := (others => '0');
   signal rom_data       : std_logic_vector(11 downto 0);

	
begin

-- ROM INSTANTIATION
	rom_inst : rom_test
	port map(
		address => addr,
		clock => clock,
		q => rom_data
	);


	process(clock)
	
	begin
		if rising_edge(clock) then
			if reset = '1' then
				-- reset things to 0
				sample_delay <= (others => '0');
            bit_sel <= (others => '0');
            sample_rate <= (others => '0');
			elsif recv.data(31 downto 28) = "1001" then
            -- Configuration message
            sample_delay <= recv.data(15 downto 0);
            bit_sel <= recv.data(19 downto 18);
            sample_rate <= unsigned(recv.data(15 downto 0)) + 1;
			end if;
		end if;
	end process;

	process(clock)
	
	-- variables here
	variable new_data 	: std_logic := '0';
	variable data_ready	: std_logic := '0';
	variable counter 		: unsigned(31 downto 0) := (others => '0');
	
	begin
		if rising_edge(clock) then
			if reset = '1' then
				-- reset things to 0
				counter := (others => '0');
            addr <= (others => '0');
            new_data := '0';
            data_ready := '0';
            send.data <= (others => '0');
				
			elsif counter = 0 then
        		if new_data = '1' then
                    counter := sample_rate;
                    data_ready := '1';
                        
                    -- Increment address for next ROM sample
                    addr <= std_logic_vector(unsigned(addr) + 1);
                        
                    -- Select bit width for data output
                    case bit_sel is
                        when "00" =>  -- 8-bit output
                            send.data <= x"00" & rom_data(11 downto 4);
                        when "01" =>  -- 10-bit output
                            send.data <= x"00" & rom_data(11 downto 2);
                        when "10" =>  -- 12-bit output
                            send.data <= rom_data;
                        when others =>
                            send.data <= (others => '0');
                    end case;
                end if;
            else
                counter := counter - 1;
                data_ready := '0';
            end if;
        end if;
	end process;


end architecture beh;