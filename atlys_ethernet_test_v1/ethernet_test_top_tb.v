`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:05:00 02/28/2011
// Design Name:   ethernet_test_top
// Module Name:   C:/Users/Administrator/Desktop/Xilinx/atlys_ethernet_test/ethernet_test_top_tb.v
// Project Name:  atlys_ethernet_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ethernet_test_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ethernet_test_top_tb;

	// Inputs
	reg clk_100_pin;
	reg MII_TX_CLK_pin;
	wire [7:0] GMII_RXD_pin;
	wire GMII_RX_DV_pin;
	reg GMII_RX_ER_pin;
	reg GMII_RX_CLK_pin;
	reg [7:0] sw;

	// Outputs
	wire PhyResetOut_pin;
	wire [7:0] GMII_TXD_pin;
	wire GMII_TX_EN_pin;
	wire GMII_TX_ER_pin;
	wire GMII_TX_CLK_pin;
	wire MDC_pin;
	wire [7:0] leds;

	// Bidirs
	wire MDIO_pin;

	// Instantiate the Unit Under Test (UUT)
	ethernet_test_top uut (
		.clk_100_pin(clk_100_pin), 
		.PhyResetOut_pin(PhyResetOut_pin), 
		.MII_TX_CLK_pin(MII_TX_CLK_pin), 
		.GMII_TXD_pin(GMII_TXD_pin), 
		.GMII_TX_EN_pin(GMII_TX_EN_pin), 
		.GMII_TX_ER_pin(GMII_TX_ER_pin), 
		.GMII_TX_CLK_pin(GMII_TX_CLK_pin), 
		.GMII_RXD_pin(GMII_RXD_pin), 
		.GMII_RX_DV_pin(GMII_RX_DV_pin), 
		.GMII_RX_ER_pin(GMII_RX_ER_pin), 
		.GMII_RX_CLK_pin(GMII_RX_CLK_pin), 
		.MDC_pin(MDC_pin), 
		.MDIO_pin(MDIO_pin), 
		.leds(leds), 
		.sw(sw)
	);



   // Loopback
   assign GMII_RX_DV_pin  = GMII_TX_EN_pin;
   assign GMII_RXD_pin    = GMII_TXD_pin;
   wire GMII_RX_CLK   = GMII_TX_CLK_pin;
	
	
	initial begin
		// Initialize Inputs
		clk_100_pin = 0;
		MII_TX_CLK_pin = 0;
		GMII_RX_CLK_pin = 0;
		sw = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
	always begin
		#8;
		GMII_RX_CLK_pin = ~GMII_RX_CLK_pin;
	end
	
	always begin
		#10;
		clk_100_pin = ~clk_100_pin;
	end
endmodule

