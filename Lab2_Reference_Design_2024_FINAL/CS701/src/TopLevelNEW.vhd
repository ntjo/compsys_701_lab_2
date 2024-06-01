library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.TdmaMinTypes.all;
entity TopLevel is
	generic (
		ports : positive := 8
	);
	port (
		CLOCK_50      : in    std_logic;
		CLOCK2_50     : in    std_logic;
		CLOCK3_50     : in    std_logic;

		FPGA_I2C_SCLK : out   std_logic;
		FPGA_I2C_SDAT : inout std_logic;
		AUD_ADCDAT    : in    std_logic;
		AUD_ADCLRCK   : inout std_logic;
		AUD_BCLK      : inout std_logic;
		AUD_DACDAT    : out   std_logic;
		AUD_DACLRCK   : inout std_logic;
		AUD_XCK       : out   std_logic;

		KEY           : in    std_logic_vector(3 downto 0);
		SW            : in    std_logic_vector(9 downto 0);
		LEDR          : out   std_logic_vector(9 downto 0);
		HEX0          : out   std_logic_vector(6 downto 0);
		HEX1          : out   std_logic_vector(6 downto 0);
		HEX2          : out   std_logic_vector(6 downto 0);
		HEX3          : out   std_logic_vector(6 downto 0);
		HEX4          : out   std_logic_vector(6 downto 0);
		HEX5          : out   std_logic_vector(6 downto 0);
		
		-- --
		DRAM_DQ : inout std_logic_vector(15 downto 0);
		DRAM_ADDR : out std_logic_vector(12 downto 0);
		DRAM_BA : out std_logic_vector(1 downto 0);
		DRAM_CAS_N, DRAM_RAS_N, DRAM_CLK : out std_logic;
		DRAM_CKE, DRAM_CS_N, DRAM_WE_N : out std_logic;
		DRAM_UDQM, DRAM_LDQM: out std_logic);
end entity;

architecture rtl of TopLevelNEW is
	-- component Nios_System_2A is
	-- 	port (
	-- 		button_pio_external_connection_export   : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
	-- 		clocks_ref_clk_clk                      : in    std_logic                     := 'X';             -- clk
	-- 		clocks_ref_reset_reset                  : in    std_logic                     := 'X';             -- reset
	-- 		clocks_sdram_clk_clk                    : out   std_logic;                                        -- clk
	-- 		digit_0_pio_external_connection_export  : out   std_logic_vector(6 downto 0);                     -- export
	-- 		digit_1_pio_external_connection_export  : out   std_logic_vector(6 downto 0);                     -- export
	-- 		--digit_2_pio_external_connection_export  : out   std_logic_vector(6 downto 0);                     -- export
	-- 		--digit_3_pio_external_connection_export  : out   std_logic_vector(6 downto 0);                     -- export
	-- 		led_pio_external_connection_export      : out   std_logic_vector(9 downto 0);                     -- export
	-- 		sdram_wire_addr                         : out   std_logic_vector(12 downto 0);                    -- addr
	-- 		sdram_wire_ba                           : out   std_logic_vector(1 downto 0);                     -- ba
	-- 		sdram_wire_cas_n                        : out   std_logic;                                        -- cas_n
	-- 		sdram_wire_cke                          : out   std_logic;                                        -- cke
	-- 		sdram_wire_cs_n                         : out   std_logic;                                        -- cs_n
	-- 		sdram_wire_dq                           : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
	-- 		sdram_wire_dqm                          : out   std_logic_vector(1 downto 0);                     -- dqm
	-- 		sdram_wire_ras_n                        : out   std_logic;                                        -- ras_n
	-- 		sdram_wire_we_n                         : out   std_logic;                                        -- we_n
	-- 		switches_pio_external_connection_export : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
	-- 		noc_8_external_connection_in_port       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- in_port
	-- 		noc_8_external_connection_out_port      : out   std_logic_vector(7 downto 0);                     -- out_port
	-- 		noc_32_external_connection_in_port      : in    std_logic_vector(31 downto 0) := (others => 'X'); -- in_port
	-- 		noc_32_external_connection_out_port     : out   std_logic_vector(31 downto 0)                     -- out_port
	-- 	);
	-- end component Nios_System_2A;


	signal clock : std_logic;

	signal reset : std_logic;

	signal send_port : tdma_min_ports(0 to ports-1);
	signal recv_port : tdma_min_ports(0 to ports-1);

begin

	clock <= CLOCK_50;
	
	-- u0 : component Nios_System_2A
	-- 	port map (
	-- 		button_pio_external_connection_export   => NOT KEY,   --   button_pio_external_connection.export
	-- 		clocks_ref_clk_clk                      => clock,                      --                   clocks_ref_clk.clk
	-- 		clocks_ref_reset_reset                  => NOT KEY(3),                  --                 clocks_ref_reset.reset
	-- 		clocks_sdram_clk_clk                    => DRAM_CLK,                    --                 clocks_sdram_clk.clk
	-- 		digit_0_pio_external_connection_export  => HEX0,  --  digit_0_pio_external_connection.export
	-- 		digit_1_pio_external_connection_export  => HEX1,  --  digit_1_pio_external_connection.export
	-- 		--digit_2_pio_external_connection_export  => HEX2,  --  digit_2_pio_external_connection.export
	-- 		--digit_3_pio_external_connection_export  => HEX3,  --  digit_3_pio_external_connection.export
	-- 		led_pio_external_connection_export      => LEDR,      --      led_pio_external_connection.export
	-- 		sdram_wire_addr                         => DRAM_ADDR,                         --                       sdram_wire.addr
	-- 		sdram_wire_ba                           => DRAM_BA,                           --                                 .ba
	-- 		sdram_wire_cas_n                        => DRAM_CAS_N,                        --                                 .cas_n
	-- 		sdram_wire_cke                          => DRAM_CKE,                          --                                 .cke
	-- 		sdram_wire_cs_n                         => DRAM_CS_N,                         --                                 .cs_n
	-- 		sdram_wire_dq                           => DRAM_DQ,                           --                                 .dq
	-- 		sdram_wire_dqm(1)                  		 => DRAM_UDQM,                     		--                            	  .dqm
	-- 		sdram_wire_dqm(0)                  		 => DRAM_LDQM,                     		--     
	-- 		sdram_wire_ras_n                        => DRAM_RAS_N,                        --                                 .ras_n
	-- 		sdram_wire_we_n                         => DRAM_WE_N,                         --                                 .we_n
	-- 		switches_pio_external_connection_export => SW, -- switches_pio_external_connection.export
	-- 		noc_8_external_connection_in_port       => recv_port(2).addr,       --        noc_8_external_connection.in_port
	-- 		noc_8_external_connection_out_port      => send_port(2).addr,      --                                 .out_port
	-- 		noc_32_external_connection_in_port      => recv_port(2).data,      --       noc_32_external_connection.in_port
	-- 		noc_32_external_connection_out_port     => send_port(2).data    --                                 .out_port
	-- );

	tdma_min : entity work.TdmaMin
	generic map (
		ports => ports
	)
	port map (
		clock => clock,
		sends => send_port,
		recvs => recv_port
	);

	ConfigAdcAsp : entity work.ConfigAdcAsp
	port map (
		clock => clock,
		empty => adc_empty,
		get   => adc_get,
		data  => adc_data,

		send  => send_port(0),
		recv  => recv_port(0)
	);

	ConfigControlAsp : entity work.ConfigControlAsp
	port map (
		clock => clock,
		key   => KEY,

		send  => send_port(2),
		recv  => recv_port(2)
	);

	ConfigAvgAsp : entity work.ConfigAvgAsp
	port map (
		clock => clock,
        reset => reset,
		send  => send_port(1),
		recv  => recv_port(1)
	);

end architecture;


