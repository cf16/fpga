		`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joel Williams
// 
// Create Date:    11:23:07 02/18/2011 
// Design Name: 
// Module Name:    ethernet_test_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Simple test framework for the Atlys' 88E1111 chip
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ethernet_test_top(
	input wire clk_100_pin,
	
	output reg PhyResetOut_pin,
	input wire MII_TX_CLK_pin, // 25 MHz clock for 100 Mbps - not used here
	output reg [7:0] GMII_TXD_pin, 
	output reg GMII_TX_EN_pin,
	output reg GMII_TX_ER_pin,
	output wire GMII_TX_CLK_pin,
	input wire [7:0] GMII_RXD_pin, 
	input wire GMII_RX_DV_pin,
	input wire GMII_RX_ER_pin,
	input wire GMII_RX_CLK_pin,
	output wire MDC_pin,
	inout wire MDIO_pin,
	output wire [7:0] leds,
	input wire [7:0] sw,
	input wire [5:0] btn
    );

	// USRP2 clocks
	// clk_to_mac = 8ns = 125 MHz
	// GMII_RX_CLK = 8ns = 125 MHz
	// clk_fpga_p = 10ns = 100 MHz
	// dsp_clk = 200 MHz
	// wb_clk = 50 MHz
	

	// System clocks
	wire clk_100;
	IBUFG ibufg_100 (
		.I(clk_100_pin),
		.O(clk_100));
		
	// 125 MHz for PHY. 90 degree shifted clock drives PHY's GMII_TX_CLK.
	wire clk_125, clk_125_GTX_CLK, clk_125_GTX_CLK_n, clk_125_tx_locked;
	wire clk_150, pll_rst;
	clk_125_tx clk_125_tx(
		.CLK_IN1(clk_100),
		.CLK_OUT1(clk_125), // 0 deg
		.CLK_OUT2(clk_125_GTX_CLK), // 90 deg
		.CLK_OUT3(clk_125_GTX_CLK_n), // 270 deg
		.CLK_OUT4(clk_150),
		.RESET(pll_rst),
		.LOCKED(clk_125_tx_locked));

	// PLL reset
	// http://forums.xilinx.com/t5/Spartan-Family-FPGAs/RESET-SIGNALS/m-p/133182#M10198
	reg [25:0] pll_status_counter;
	always @(posedge clk_100)
		if (clk_125_tx_locked)
			pll_status_counter <= 0;
		else
			pll_status_counter <= pll_status_counter + 1'b1;
			
	assign pll_rst = (pll_status_counter > (2**26 - 26'd20)); // Reset for 20 cycles
		
	// The USRP2 has a 125 MHz oscillator connected to clk_to_mac. While the
	// 88E1111 generates a 125 MHz reference (125CLK), this isn't connected.
	// We can either generate this clock from the Atlys' 100 MHz oscillator
	// using a clock manager or (hopefully) just re-use the GMI_RX_CLK pin 
	wire clk_to_mac;
	assign clk_to_mac = clk_125;
	
	// USRP2 runs the GEMAC's FIFOs at 100 MHz, though this is buffered through a DCM.
	wire dsp_clk;
	assign dsp_clk = clk_150;
	
	// USRP2 runs its CPU and the Wishbone bus at 50 MHz system clock, possibly due to
	// speed limitations in the Spartan-3. Let's try running it at full speed.
	wire wb_clk;
	assign wb_clk = clk_150;

	//  Drive the GTX_CLK output from a DDR register
	wire GMII_GTX_CLK_int;
	
	OFDDRRSE OFDDRRSE_gmii_inst 
     (.Q(GMII_TX_CLK_pin),      // Data output (connect directly to top-level port)
      .C0(clk_125_GTX_CLK),    // 0 degree clock input
      .C1(clk_125_GTX_CLK_n),    // 180 degree clock input
      .CE(1'b1),    // Clock enable input
      .D0(1'b0),    // Posedge data input
      .D1(1'b1),    // Negedge data input
      .R(1'b0),      // Synchronous reset input
      .S(1'b0)       // Synchronous preset input
      );

	// Register MAC outputs
	wire GMII_TX_EN, GMII_TX_ER;
	wire [7:0] GMII_TXD;
	
	always @(posedge GMII_GTX_CLK_int)
	begin
		GMII_TX_EN_pin <= GMII_TX_EN;
		GMII_TX_ER_pin <= GMII_TX_ER;
		GMII_TXD_pin <= GMII_TXD;
	end
	
	reg [7:0] ledreg;
	assign leds = ledreg;
	
	
	// FSM reset generator
	parameter RST_DELAY = 3;
	reg rst = 1'b1;
	reg [RST_DELAY-1:0] rst_dly = {RST_DELAY{1'b1}};
	always @(posedge clk_100)
		if (clk_125_tx_locked)
			{rst,rst_dly} <= {rst_dly,1'b0};

	
	// Instantiate GEMAC with Wishbone interface
	// Wishbone is used for setting registers and retrieving link status
	// FIFOs are exposed for transferring data.
	
	localparam dw = 32; // WB data bus width
	localparam aw = 8; // WB address bus width
	reg wb_rst = 0;
	reg rd2_ready_o, wr2_ready_o;
	wire wr2_ready_i, rd2_ready_i;
   reg [3:0] 	 wr2_flags;
	wire [3:0]   rd2_flags;
   wire [31:0]  rd2_data;
	reg [31:0]	 wr2_data;
   reg [dw-1:0] s6_dat_o;
	wire [dw-1:0] s6_dat_i;
	reg [aw-1:0] s6_adr;
	wire s6_ack;
	reg s6_stb, s6_cyc, s6_we;
	wire [79:0] debug_mac;
	

   simple_gemac_wrapper #(.RXFIFOSIZE(9), .TXFIFOSIZE(6)) simple_gemac_wrapper
     (.clk125(clk_to_mac),  .reset(wb_rst),
      .GMII_GTX_CLK(GMII_GTX_CLK_int), .GMII_TX_EN(GMII_TX_EN),
      .GMII_TX_ER(GMII_TX_ER), .GMII_TXD(GMII_TXD),
      .GMII_RX_CLK(GMII_RX_CLK_pin), .GMII_RX_DV(GMII_RX_DV_pin),  
      .GMII_RX_ER(GMII_RX_ER_pin), .GMII_RXD(GMII_RXD_pin),
      .sys_clk(dsp_clk),
      .rx_f36_data({rd2_flags,rd2_data}), .rx_f36_src_rdy(rd2_ready_i), .rx_f36_dst_rdy(rd2_ready_o),
      .tx_f36_data({wr2_flags,wr2_data}), .tx_f36_src_rdy(wr2_ready_o), .tx_f36_dst_rdy(wr2_ready_i),
      .wb_clk(wb_clk), .wb_rst(wb_rst), .wb_stb(s6_stb), .wb_cyc(s6_cyc), .wb_ack(s6_ack),
      .wb_we(s6_we), .wb_adr(s6_adr), .wb_dat_i(s6_dat_o), .wb_dat_o(s6_dat_i),
      .mdio(MDIO_pin), .mdc(MDC_pin),
      .debug(debug_mac));
	

	// Would normally initialise using Wishbone, but we've hard-coded a MAC address.
	
	
	// Sync a pushbutton to FSM clock to initiate packet
	wire sw_fall, sw_reconfig;
	edge_detect edge_detect_s1 (.async_sig(btn[0]), .clk(dsp_clk), .fall(sw_fall));
	edge_detect edge_detect_s2 (.async_sig(btn[1]), .clk(dsp_clk), .fall(sw_reconfig));
	
	// Blast out some packets
	(* fsm_encoding = "user" *)
	reg [4:0] state = 0;
	reg [25:0] count = 0;
	reg [31:0] phy_status;
	reg [4:0] phy_addr = 7; // Valid for the Atlys
	
	reg [13:0] bigpacket = 0;
	reg [15:0] port_count = 0;
	
	// Define the packet to send out
	reg [31:0] packet_buffer [11:0];
	reg [3:0] packet_count = 0;
	initial begin
		packet_buffer[0] = 32'h0023_dfff; // dstmac (8)
		packet_buffer[1] = 32'h3311_0037; // dstmac (4), srcmac (4)
		packet_buffer[2] = 32'hffff_3737; // srcmac(8)
		packet_buffer[3] = 32'h0800_4500; // hwtype ethernet (4), protocol type ipv4 (1),  header length (1) (*4), dsc (2)
		packet_buffer[4] = 32'h0023_1234; // total length (4), identification (4), 
		packet_buffer[5] = 32'h0000_4011; // flags/frag offset (4), ttl (2), protocol (2)
		packet_buffer[6] = 32'h0000_a9fe; // checksum (4), srcip (4)
		packet_buffer[7] = 32'h4d01_a9fe; // srcip (4), dstip (4)
		packet_buffer[8] = 32'h4d9d_1234; // dstip (4), srcport(4)
		packet_buffer[9] = 32'h1234_000f; // dstport (4), length (4)
		packet_buffer[10] = 32'h0000_4845; // checksum (4), data (4)
		packet_buffer[11] = 32'h4c4c_4f20; // data
		end
	
	always @(posedge dsp_clk) begin
		if(rst)
			state <= 0;
		else
		case(state)
		0: begin
		
			// Reset the PHY for ages (must be > 10ms)
			PhyResetOut_pin <= 1;
			wr2_ready_o	<= 0;
			ledreg[0] <= 1;
			wb_rst <= 1;
			count <= count + 1'b1;
				
			if (count[23] == 1)
				state <= 1;
			end
		1: begin
			count <= 24'h0;
			state <= 2;
			end
		2: begin
			PhyResetOut_pin <= 0; // Active low reset
			count <= count + 1'b1;
			if (count[23] == 1)
				state <= 3;
			end
		3: begin
			count <= 24'h0;
			state <= 4;
			end
		4: begin
			PhyResetOut_pin <= 1; // Bring out of reset, then wait for chip to fire up
			count <= count + 1'b1;
			if (count[23] == 1)
				state <= 5;
			end
		5: begin
			wb_rst <= 0;
			ledreg[1] <= 1;
			s6_adr <= 20; // Set MDIO clock divider
			s6_dat_o <= 24; // to 24 (@150 = 6.25 MHz )
			s6_stb <= 1;
			s6_cyc <= 1;
			s6_we <= 1;
			state <= 6;
			end
		6:	if (s6_ack) begin
				s6_stb <= 0;
				s6_cyc <= 0;
				s6_we <= 0;		
				state <= 7;
			end	
		7: begin 
		// First read the current status to make sure the PHY is present
			s6_adr <= {6'd6, 2'd0}; // ADDRESS =
			s6_dat_o <= {5'd1, 3'd0, phy_addr}; //				Reg 1, NC, PHYADD n
			s6_stb <= 1;
			s6_cyc <= 1;
			s6_we <= 1;
			state <= 8;
			end
		8: if (s6_ack) begin
				s6_stb <= 0;
				s6_cyc <= 0;
				s6_we <= 0;
				state <= 9;
			end
		9: begin
			s6_adr <= {6'd8, 2'd0}; // COMMAND =
			s6_dat_o <= 32'd2; // 					RSTAT
			s6_stb <= 1;
			s6_cyc <= 1;
			s6_we <= 1;
			state <= 10;
			end
		10: if (s6_ack) begin
			s6_stb <= 0;
			s6_cyc <= 0;
			s6_we <= 0;
			state <= 11;
			end
		11: begin
			s6_adr <= {6'd9, 2'd0}; // Read MIISTATUS
			state <= 12;
			end
		12: if (~s6_dat_i[1]) // Wait until not busy
				state <= 13;
		13: begin
			s6_adr <= {6'd10, 2'd0}; // Read MIIRX_DATA
			s6_we <= 0;
			s6_stb <= 1;
			s6_cyc <= 1;
			state <= 14;
			end
		14: if (s6_ack) begin
			s6_stb <= 0;
			s6_cyc <= 0;
			phy_status <= s6_dat_i;
			state <= 15;
			end
		15: begin
			// Set to GMII mode, first by reading reg 27
			s6_adr <= {6'd6, 2'd0}; // ADDRESS =
			s6_dat_o <= {5'd27, 3'd0, phy_addr}; // Reg 27
			s6_stb <= 1; s6_cyc <=1; s6_we <= 1;
			state <= 16;
			end
		16: if (s6_ack) begin
				s6_stb <= 0; s6_cyc <= 0; s6_we <= 0; state <= 17;
			end
		17: begin
			s6_adr <= {6'd8, 2'd0}; // COMMAND =
			s6_dat_o <= 32'd6; // 					RSTAT
			s6_stb <= 1; s6_cyc <= 1; s6_we <= 1; state <= 18;
			end
		18: if (s6_ack) begin
				s6_stb <= 0; s6_cyc <= 0; s6_we <= 0; state <= 19;
			end
		19: begin
			s6_adr <= {6'd9, 2'd0}; // Read MIISTATUS
			state <= 20;
			end
		20: if (~s6_dat_i[1]) // Wait until not busy
				state <= 21;
		21: begin
			// Now write to GMII mode register
			phy_status <= s6_dat_i;
			s6_adr <= {6'd6, 2'd0}; // ADDRESS =
			s6_dat_o <= {5'd27, 3'd0, phy_addr}; // Reg 27
			s6_stb <= 1; s6_cyc <=1; s6_we <= 1;
			state <= 22;
			end
		22: if (s6_ack) begin
				s6_stb <= 0; s6_cyc <= 0; s6_we <= 0; state <= 23;
			end
		23: begin
			s6_adr <= {6'd8, 2'd0}; // COMMAND = TxData
			s6_dat_o <= {phy_status[15:4], 4'b1111}; // HWCFG_MODE = GMII to Copper
			s6_stb <= 1; s6_cyc <= 1; s6_we <= 1; state <= 24;
			end
		24: if (s6_ack) begin
			s6_stb <= 0; s6_cyc <= 0; s6_we <= 0; state <= 25;
			ledreg <= 0;
			
			end
		
		25: 
			if (sw_fall)
				state <= 26;
			else if (sw_reconfig)
				state <= 0;
		// Output a hard-coded UDP packet
		26: begin
			wr2_ready_o <= 1;
			wr2_flags <= 4'b0001; // SOF
			wr2_data <= packet_buffer[0]; // dst mac (8)
			state <= 27;
			count <= 0;
			packet_count <= 1;
			port_count <= port_count + 1'b1;
			packet_buffer[9] <= {port_count, 3'b0, sw[7:0], 5'b01000}; // dstport (4), length (4)
			packet_buffer[4] <= {3'b0, sw[7:0], 5'b11100, 16'h1234};
			end
		27: begin
			wr2_flags <= 4'b0000;
			wr2_data <= packet_buffer[packet_count];
				
			packet_count <= packet_count + 1'b1;
			bigpacket <= 0;
			if (packet_count == 4'd11)
				state <= 28;
				
			end
		28: begin
			if (wr2_ready_i) begin
				wr2_data <= {18'd0, bigpacket[13:0]}; // data
				bigpacket <= bigpacket + 1'b1;
				if (bigpacket == {5'b0, sw[7:0], 3'b100}) begin // switch controls packet size
					state <= 29;
					wr2_flags <= 4'b0010; // 4 bytes, EOF
				end
			end
			
			end

		29: begin
			if (wr2_ready_i) begin
				wr2_ready_o <= 0;
				wr2_flags <= 0;
				count <= count + 1'b1;
			end
			if (count[25]) state <= 25;
			end

		endcase
			
	end
	
	wire [35:0] control0, control1;
	cg_icon cg_icon (
		.CONTROL0(control0),
		.CONTROL1(control1)
	);
	
	cg_ila1 cg_ila1 (
		.CLK(clk_125),
		.CONTROL(control0),
		.TRIG0(debug_mac), // [79:0]
		.TRIG1({GMII_TX_EN, GMII_TX_ER, GMII_TXD})); // [9:0]

	cg_ila2 cg_ila2 (
		.CLK(clk_150),
		.CONTROL(control1),
		.TRIG0({1'b0, wr2_flags[3:0], state[4:0]}) // [9:0]
	);
	
endmodule
