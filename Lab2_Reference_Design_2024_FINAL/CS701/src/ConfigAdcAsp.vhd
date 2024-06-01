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

        -- bit_sel_out : out std_logic_vector(1 downto 0);
        -- sample_delay_out : out natural;
        --rom_data_port : out std_logic_vector(11 downto 0);
        -- data_out : out std_logic_vector(31 downto 0)
        
	);
end entity;

architecture beh of ConfigAdcAsp is

	Component rom_new IS
	PORT
	(
		-- address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q			: OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
        sample_delay: IN natural
	);
	END component rom_new;

	-- signals here
	-- ROM
 	signal rom_data         : std_logic_vector(11 downto 0);
    signal sample_delay     : natural;
	
    -- SIM
    -- signal prev_data_sim : std_logic_vector(11 downto 0):= (others => 'U');
	-- signal temp_data_sim : std_logic_vector(31 downto 0) := (others => '0');
	-- signal next_addr_sim : std_logic_vector(7 downto 0) := (others => '0');
	-- signal enable_sim : std_logic := '0';

begin

-- ROM INSTANTIATION
	rom_inst : rom_new
	port map(
		clock => clock,
		q => rom_data,
        sample_delay => sample_delay
	);


	process(clock)

	variable bit_sel        : std_logic_vector(1 downto 0) := (others => '0');
    variable prev_data      : std_logic_vector(11 downto 0) := (others => '0');
    variable next_addr      : std_logic_vector(7 downto 0) := (others => '0');
    variable enable         : std_logic := '0';
    variable temp_data      :std_logic_vector(31 downto 0) := (others => '0');

	begin
		if rising_edge(clock) then
            temp_data := (others => '0');
            -- send.data <= (others => '0');
			if reset = '1' then

				-- Reset variables to 0
				bit_sel         := (others => '0');
                prev_data       := (others => '0');
                next_addr       := (others => '0');
                enable          := '0';

			elsif recv.data(31 downto 28) = "1001" then

				-- Configuration message
                next_addr       := x"0" & recv.data(23 downto 20);
                bit_sel         := recv.data(19 downto 18);
                enable          := recv.data(17);
				sample_delay    <= natural(to_integer(unsigned(recv.data(15 downto 0))));
				

            elsif enable = '1' then
                if prev_data /= rom_data then

                    case bit_sel is
                        when "00" =>  -- 8-bit output
                            -- send.data <= x"8000" & x"00" & rom_data(11 downto 4);
                            temp_data := x"8000" & x"00" & rom_data(11 downto 4);
                        when "01" =>  -- 10-bit output
                            -- send.data <= x"8000" & "000000" & rom_data(11 downto 2);
                            temp_data := x"8000" & "000000" & rom_data(11 downto 2);
                        when "10" =>  -- 12-bit output
                            -- send.data <= x"8000" & x"0" & rom_data;
                            temp_data := x"8000" & x"0" & rom_data;
                        when others =>
                            -- send.data <= (others => '0');
                            -- send.data <= x"8000" & x"00" & rom_data(11 downto 4);
                            temp_data := x"8000" & x"00" & rom_data(11 downto 4);
                    end case;
                    
                    prev_data := rom_data;
                end if;
			end if;
            send.addr <= next_addr;
            send.data <= temp_data;
            -- SIM
            -- prev_data_sim <= prev_data;
            -- temp_data_sim <= temp_data;
            -- next_addr_sim <= next_addr;
            -- enable_sim <= enable;
            -- data_out <= temp_data;
            -- rom_data_port <= rom_data;
            -- bit_sel_out <= bit_sel;
            -- sample_delay_out <= sample_delay;

		end if;
	end process;

end architecture beh;