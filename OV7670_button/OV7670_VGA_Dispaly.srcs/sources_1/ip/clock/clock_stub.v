// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2700185 Thu Oct 24 18:46:05 MDT 2019
// Date        : Sat Feb  1 00:08:47 2020
// Host        : LAPTOP-7Q5UGIUP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/fpga_test/y2_project/20200201/ZYNQ_OV7670_hdmi_Dispaly_zybo/OV7670_VGA_Dispaly.srcs/sources_1/ip/clock/clock_stub.v
// Design      : clock
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock(clk_out1, resetn, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,resetn,clk_in1" */;
  output clk_out1;
  input resetn;
  input clk_in1;
endmodule
