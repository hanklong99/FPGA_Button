-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2700185 Thu Oct 24 18:46:05 MDT 2019
-- Date        : Sat Feb  1 00:08:47 2020
-- Host        : LAPTOP-7Q5UGIUP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/fpga_test/y2_project/20200201/ZYNQ_OV7670_hdmi_Dispaly_zybo/OV7670_VGA_Dispaly.srcs/sources_1/ip/clock/clock_stub.vhdl
-- Design      : clock
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock is
  Port ( 
    clk_out1 : out STD_LOGIC;
    resetn : in STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clock;

architecture stub of clock is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,resetn,clk_in1";
begin
end;
