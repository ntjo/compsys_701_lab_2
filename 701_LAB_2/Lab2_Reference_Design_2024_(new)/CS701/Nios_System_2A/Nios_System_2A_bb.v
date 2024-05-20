
module Nios_System_2A (
	button_pio_external_connection_export,
	clocks_ref_clk_clk,
	clocks_ref_reset_reset,
	clocks_sdram_clk_clk,
	digit_0_pio_external_connection_export,
	digit_1_pio_external_connection_export,
	led_pio_external_connection_export,
	noc_32_in_external_connection_export,
	noc_32_out_external_connection_export,
	noc_8_in_external_connection_export,
	noc_8_out_external_connection_export,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	switches_pio_external_connection_export);	

	input	[3:0]	button_pio_external_connection_export;
	input		clocks_ref_clk_clk;
	input		clocks_ref_reset_reset;
	output		clocks_sdram_clk_clk;
	output	[6:0]	digit_0_pio_external_connection_export;
	output	[6:0]	digit_1_pio_external_connection_export;
	output	[9:0]	led_pio_external_connection_export;
	input	[31:0]	noc_32_in_external_connection_export;
	output	[31:0]	noc_32_out_external_connection_export;
	input	[7:0]	noc_8_in_external_connection_export;
	output	[7:0]	noc_8_out_external_connection_export;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input	[9:0]	switches_pio_external_connection_export;
endmodule
