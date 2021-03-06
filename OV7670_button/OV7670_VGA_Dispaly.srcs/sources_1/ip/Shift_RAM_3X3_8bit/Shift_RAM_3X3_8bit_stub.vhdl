-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2700185 Thu Oct 24 18:46:05 MDT 2019
-- Date        : Sat Feb  1 00:08:47 2020
-- Host        : LAPTOP-7Q5UGIUP running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/fpga_test/y2_project/20200201/ZYNQ_OV7670_hdmi_Dispaly_zybo/OV7670_VGA_Dispaly.srcs/sources_1/ip/Shift_RAM_3X3_8bit/Shift_RAM_3X3_8bit_stub.vhdl
-- Design      : Shift_RAM_3X3_8bit
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Shift_RAM_3X3_8bit is
  Port ( 
    D : in STD_LOGIC_VECTOR ( 7 downto 0 );
    CLK : in STD_LOGIC;
    CE : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );

end Shift_RAM_3X3_8bit;

architecture stub of Shift_RAM_3X3_8bit is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "D[7:0],CLK,CE,SCLR,Q[7:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "c_shift_ram_v12_0_14,Vivado 2019.2";
begin
end;
