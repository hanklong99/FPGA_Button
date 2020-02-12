`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2014/05/23 15:48:40
// Design Name: 
// Module Name: VGA_Dispay
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies:  
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
	`define	H_FRONT	11'd16
	`define	H_SYNC 	11'd96  
	`define	H_TOTAL	11'd800 	
						
	`define	V_FRONT	11'd10  
	`define	V_SYNC 	11'd2     
	`define	V_TOTAL	11'd525

module VGA_Dispay(
	input 					clk,
	input 					rst_n,
	input      [15:0]       points,
	input       [11:0]      x_min,
    input       [11:0]      x_max,
    input       [11:0]      y_min,
    input       [11:0]      y_max,
    input                   sw0,
	input                   sw1,
	input                   sw2,
	
	output	reg	[15:0]		lcd_data,
	output 	reg 			vga_hsync,
	output 	reg 			vga_vsync,

	output 		[16:0] 		frame_addr,
	input 		[15:0] 		frame_pixel,
	output de,
	output [9:0] lcd_x,
	output [9:0] lcd_y
    );

`define SILVER  16'd50712//Òø»Ò	
`define	 YELLOW 	16'b11111_111111_00000
`define	 RED 	16'b11111_000000_00000
`define	 GREEN 	16'b00000_111111_00000
`define	 BLUE 	16'b00000_000000_11111

//Timing constants
parameter 	hRez   		= 640;
parameter 	hStartSync 	= 640+16;
parameter 	hEndSync   	= 640+16+96;
parameter 	hMaxCount  	= 800;
	
parameter 	vRez       	= 480;
parameter 	vStartSync 	= 480+10;
parameter 	vEndSync   	= 480+10+2;
parameter 	vMaxCount	= 480+10+2+33;

parameter 	hsync_active	=0;
parameter 	vsync_active  	=0;


reg	[9:0] 	hCounter;
reg	[9:0] 	vCounter;   

assign lcd_x = hCounter;
assign lcd_y = vCounter;
reg	[16:0] 	address;  
reg 				blank;
   
assign	frame_addr = address;
assign 	HCnt = hCounter;
assign 	VCnt = vCounter;

//-----------------------------------------------------------
//center calculation
reg [11:0] x_sum;
reg [11:0] y_sum;
reg [11:0] x_center;
reg [11:0] y_center;
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        x_sum <= 0;
        y_sum <= 0;
    end
    else begin
        x_sum <= x_min + x_max;
        y_sum <= y_min + y_max;
    end
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        x_center <= 0;
        y_center <= 0;
    end
    else begin
        x_center <= x_sum[11:1];
        y_center <= y_sum[11:1];
    end
end

//-----------------------------------------------------------
//scaling range calculation
reg [11:0] x_sub;
reg [11:0] y_sub;
reg [11:0] x_scaling;
reg [11:0] y_scaling;
always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        x_sub <= 0;
        y_sub <= 0;
    end
    else begin
        x_sub <= x_max - x_min;
        y_sub <= y_max - y_min;
    end
end

always @ (posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        x_scaling <= 0;
        y_scaling <= 0;
    end
    else begin
        x_scaling <= x_sub[11:2];
        y_scaling <= y_sub[11:2];
    end
end

//------------------------------------------------------------
//frame_en
reg 	[2:0] frame_en;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		frame_en <= 3'b000;
	else if(lcd_y == y_min + 40 && lcd_x >= x_min + 120 && lcd_x <= x_max + 120
		|| lcd_y == y_max + 40 && lcd_x >= x_min + 120 && lcd_x <= x_max + 120
		|| lcd_x == x_min + 120 && lcd_y >= y_min + 40 && lcd_y <= y_max + 40
		|| lcd_x == x_max + 120 && lcd_y >= y_min + 40 && lcd_y <= y_max + 40
		|| lcd_x == x_center + 120 && lcd_y >= y_min + 40 && lcd_y <= y_max + 40
		|| lcd_y == y_center + 40 && lcd_x >= x_min + 120 && lcd_x <= x_max + 120)
		frame_en <= 3'b001;
		
	else if ( lcd_y >= 280  && lcd_y <= 510  && lcd_x >= 120 && lcd_x <= 440)
		frame_en <= 3'b010;
		
    else if(lcd_y >= 280 && lcd_y <= 510 && lcd_x >= 440 && lcd_x <= 780 )
		frame_en <= 3'b011;
	
	else if(lcd_y >= 40 && lcd_y <= 280 && lcd_x >= 440 && lcd_x <= 780)
		frame_en <= 3'b100;
		
	else 
		frame_en <= 3'b000;
end

//------------------------------------------------------------
//block_en
wire [15:0]	lcd_block;
wire flag;

application u_application(
    .clk(clk),
    .rst_n(rst_n),
    .x_center(x_center),
    .y_center(y_center),
    .lcd_x(lcd_x),
    .lcd_y(lcd_y),
    
    .sw0(sw0),
    .sw1(sw1),
    .sw2(sw2),
    .lcd_block(lcd_block),
    .flag(flag)
    );


//-------------------------------------------------
//scaling
wire [15:0]	lcd_scaling;
scaling u_scaling(
    .clk(clk),
    .rst_n(rst_n),
    .x_center(x_center),
    .y_center(y_center),
    .x_scaling(x_scaling),
    .y_scaling(y_scaling),
    .lcd_x(lcd_x),
    .lcd_y(lcd_y),

    .sw0(sw0),
    .sw1(sw1),
    .sw2(sw2),
    .lcd_scaling(lcd_scaling)
    );



//-------------------------------------------------
//scoreboard
wire [15:0] lcd_scoreboard;
scoreboard u_scoreboard(
    .clk (clk),
    .rst_n(rst_n),
    .flag (flag),
    .lcd_x (lcd_x),
    .lcd_y (lcd_y),

    .sw0(sw0),
    .sw1(sw1),
    .sw2(sw2),
    .lcd_scoreboard (lcd_scoreboard)
    );

//------------------------------------------------------------------------
//display
reg 	[15:0]	lcd_data_r0;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		lcd_data <= 16'b0;
	else if (frame_en == 3'b000)
	   lcd_data <= lcd_data_r0;
	else if (frame_en == 3'b001) 
	   lcd_data <= `YELLOW;
	else if (frame_en == 3'b010)
	   lcd_data <= lcd_scaling;
	else if (frame_en == 3'b011)
	   lcd_data <= lcd_scoreboard;
	else if (frame_en == 3'b100)
	   lcd_data <= lcd_block;
end


    
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		hCounter	<= 10'b0;
	    vCounter 	<= 10'b0;
	    address 	<= 17'b0; 
	    blank 		<= 1'b1;    
	end
	else begin
        if(hCounter == hMaxCount - 1)begin
			hCounter <=  10'b0;
			if (vCounter == vMaxCount - 1)
				vCounter <=  10'b0;
			else
				vCounter <= vCounter + 1;
			end
		else
			hCounter <= hCounter + 1;
		if (blank ==0) begin
			/* vga_red   <= frame_pixel[15:11];
			vga_green <= frame_pixel[10:5];
			vga_blue  <= frame_pixel[4:0]; */
			lcd_data_r0 <= frame_pixel;
			end
		else begin
			/* vga_red   <= 5'b0;
			vga_green <= 6'b0;
			vga_blue  <= 5'b0; */
			lcd_data_r0 <= 'd0;
		     end;
		if(vCounter  >= 280 || vCounter  < 40) begin
			address <= 17'b0; 
			blank <= 1;
			end
		else begin
			if (hCounter  < 440 && hCounter  >= 120) begin
				blank <= 0;
				address <= address+1;
				end
			else
				blank <= 1;
		end
		// Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
		if(hCounter > hStartSync && hCounter <= hEndSync)
			vga_hsync <= hsync_active;
		else
			vga_hsync <= ~ hsync_active;
		// Are we in the vSync pulse?
		if(vCounter >= vStartSync && vCounter < vEndSync )
			vga_vsync <= vsync_active;
		else
			vga_vsync <= ~ vsync_active;
	end
end

wire hs = (hCounter > `H_FRONT + `H_SYNC - 1 && hCounter <= `H_TOTAL  - 1)? 1'b1: 1'b0; 
wire vs = (vCounter > `V_FRONT + `V_SYNC - 1 && vCounter <=  `V_TOTAL - 1)? 1'b1: 1'b0;
assign de = hs & vs;  
endmodule
