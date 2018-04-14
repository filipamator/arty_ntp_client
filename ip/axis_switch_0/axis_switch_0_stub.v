// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri Apr 13 20:32:24 2018
// Host        : PONIAK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub D:/FPGA/Xilinx/arty_ntp_client/ip/axis_switch_0/axis_switch_0_stub.v
// Design      : axis_switch_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axis_switch_v1_1_15_axis_switch,Vivado 2017.4" *)
module axis_switch_0(aclk, aresetn, s_axis_tvalid, s_axis_tready, 
  s_axis_tdata, s_axis_tlast, s_axis_tdest, m_axis_tvalid, m_axis_tready, m_axis_tdata, 
  m_axis_tlast, m_axis_tdest, s_req_suppress, s_decode_err)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_tvalid[3:0],s_axis_tready[3:0],s_axis_tdata[31:0],s_axis_tlast[3:0],s_axis_tdest[7:0],m_axis_tvalid[0:0],m_axis_tready[0:0],m_axis_tdata[7:0],m_axis_tlast[0:0],m_axis_tdest[1:0],s_req_suppress[3:0],s_decode_err[3:0]" */;
  input aclk;
  input aresetn;
  input [3:0]s_axis_tvalid;
  output [3:0]s_axis_tready;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tlast;
  input [7:0]s_axis_tdest;
  output [0:0]m_axis_tvalid;
  input [0:0]m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tlast;
  output [1:0]m_axis_tdest;
  input [3:0]s_req_suppress;
  output [3:0]s_decode_err;
endmodule
