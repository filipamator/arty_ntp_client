// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri Apr 13 20:32:24 2018
// Host        : PONIAK running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               D:/FPGA/Xilinx/arty_ntp_client/ip/axis_switch_0/axis_switch_0_sim_netlist.v
// Design      : axis_switch_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "axis_switch_0,axis_switch_v1_1_15_axis_switch,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "axis_switch_v1_1_15_axis_switch,Vivado 2017.4" *) 
(* NotValidForBitStream *)
module axis_switch_0
   (aclk,
    aresetn,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tlast,
    s_axis_tdest,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tlast,
    m_axis_tdest,
    s_req_suppress,
    s_decode_err);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLKIF CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLKIF, FREQ_HZ 100000000, PHASE 0.000" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RSTIF RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TVALID [0:0] [0:0], xilinx.com:interface:axis:1.0 S01_AXIS TVALID [0:0] [1:1], xilinx.com:interface:axis:1.0 S02_AXIS TVALID [0:0] [2:2], xilinx.com:interface:axis:1.0 S03_AXIS TVALID [0:0] [3:3]" *) input [3:0]s_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TREADY [0:0] [0:0], xilinx.com:interface:axis:1.0 S01_AXIS TREADY [0:0] [1:1], xilinx.com:interface:axis:1.0 S02_AXIS TREADY [0:0] [2:2], xilinx.com:interface:axis:1.0 S03_AXIS TREADY [0:0] [3:3]" *) output [3:0]s_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TDATA [7:0] [7:0], xilinx.com:interface:axis:1.0 S01_AXIS TDATA [7:0] [15:8], xilinx.com:interface:axis:1.0 S02_AXIS TDATA [7:0] [23:16], xilinx.com:interface:axis:1.0 S03_AXIS TDATA [7:0] [31:24]" *) input [31:0]s_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TLAST [0:0] [0:0], xilinx.com:interface:axis:1.0 S01_AXIS TLAST [0:0] [1:1], xilinx.com:interface:axis:1.0 S02_AXIS TLAST [0:0] [2:2], xilinx.com:interface:axis:1.0 S03_AXIS TLAST [0:0] [3:3]" *) input [3:0]s_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S00_AXIS TDEST [1:0] [1:0], xilinx.com:interface:axis:1.0 S01_AXIS TDEST [1:0] [3:2], xilinx.com:interface:axis:1.0 S02_AXIS TDEST [1:0] [5:4], xilinx.com:interface:axis:1.0 S03_AXIS TDEST [1:0] [7:6]" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 2, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, XIL_INTERFACENAME S01_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 2, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, XIL_INTERFACENAME S02_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 2, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, XIL_INTERFACENAME S03_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 2, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) input [7:0]s_axis_tdest;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TVALID" *) output [0:0]m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TREADY" *) input [0:0]m_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TDATA" *) output [7:0]m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TLAST" *) output [0:0]m_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M00_AXIS TDEST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M00_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 2, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef" *) output [1:0]m_axis_tdest;
  input [3:0]s_req_suppress;
  output [3:0]s_decode_err;

  wire aclk;
  wire aresetn;
  wire [7:0]m_axis_tdata;
  wire [1:0]m_axis_tdest;
  wire [0:0]m_axis_tlast;
  wire [0:0]m_axis_tready;
  wire [0:0]m_axis_tvalid;
  wire [31:0]s_axis_tdata;
  wire [7:0]s_axis_tdest;
  wire [3:0]s_axis_tlast;
  wire [3:0]s_axis_tready;
  wire [3:0]s_axis_tvalid;
  wire [3:0]s_decode_err;
  wire [3:0]s_req_suppress;
  wire NLW_inst_s_axi_ctrl_arready_UNCONNECTED;
  wire NLW_inst_s_axi_ctrl_awready_UNCONNECTED;
  wire NLW_inst_s_axi_ctrl_bvalid_UNCONNECTED;
  wire NLW_inst_s_axi_ctrl_rvalid_UNCONNECTED;
  wire NLW_inst_s_axi_ctrl_wready_UNCONNECTED;
  wire [7:0]NLW_inst_arb_dest_UNCONNECTED;
  wire [0:0]NLW_inst_arb_done_UNCONNECTED;
  wire [3:0]NLW_inst_arb_id_UNCONNECTED;
  wire [3:0]NLW_inst_arb_last_UNCONNECTED;
  wire [3:0]NLW_inst_arb_req_UNCONNECTED;
  wire [3:0]NLW_inst_arb_user_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_tstrb_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_tuser_UNCONNECTED;
  wire [1:0]NLW_inst_s_axi_ctrl_bresp_UNCONNECTED;
  wire [31:0]NLW_inst_s_axi_ctrl_rdata_UNCONNECTED;
  wire [1:0]NLW_inst_s_axi_ctrl_rresp_UNCONNECTED;

  (* C_ARB_ALGORITHM = "1" *) 
  (* C_ARB_ON_MAX_XFERS = "1" *) 
  (* C_ARB_ON_NUM_CYCLES = "0" *) 
  (* C_ARB_ON_TLAST = "1" *) 
  (* C_AXIS_SIGNAL_SET = "83" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "2" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_DECODER_REG = "0" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_INCLUDE_ARBITER = "1" *) 
  (* C_LOG_SI_SLOTS = "2" *) 
  (* C_M_AXIS_BASETDEST_ARRAY = "2'b00" *) 
  (* C_M_AXIS_CONNECTIVITY_ARRAY = "4'b1111" *) 
  (* C_M_AXIS_HIGHTDEST_ARRAY = "2'b00" *) 
  (* C_NUM_MI_SLOTS = "1" *) 
  (* C_NUM_SI_SLOTS = "4" *) 
  (* C_OUTPUT_REG = "0" *) 
  (* C_ROUTING_MODE = "0" *) 
  (* C_S_AXI_CTRL_ADDR_WIDTH = "7" *) 
  (* C_S_AXI_CTRL_DATA_WIDTH = "32" *) 
  (* DowngradeIPIdentifiedWarnings = "yes" *) 
  (* G_INDX_SS_TDATA = "1" *) 
  (* G_INDX_SS_TDEST = "6" *) 
  (* G_INDX_SS_TID = "5" *) 
  (* G_INDX_SS_TKEEP = "3" *) 
  (* G_INDX_SS_TLAST = "4" *) 
  (* G_INDX_SS_TREADY = "0" *) 
  (* G_INDX_SS_TSTRB = "2" *) 
  (* G_INDX_SS_TUSER = "7" *) 
  (* G_MASK_SS_TDATA = "2" *) 
  (* G_MASK_SS_TDEST = "64" *) 
  (* G_MASK_SS_TID = "32" *) 
  (* G_MASK_SS_TKEEP = "8" *) 
  (* G_MASK_SS_TLAST = "16" *) 
  (* G_MASK_SS_TREADY = "1" *) 
  (* G_MASK_SS_TSTRB = "4" *) 
  (* G_MASK_SS_TUSER = "128" *) 
  (* G_TASK_SEVERITY_ERR = "2" *) 
  (* G_TASK_SEVERITY_INFO = "0" *) 
  (* G_TASK_SEVERITY_WARNING = "1" *) 
  (* LP_CTRL_REG_WIDTH = "25" *) 
  (* LP_MERGEDOWN_MUX = "0" *) 
  (* LP_NUM_SYNCHRONIZER_STAGES = "4" *) 
  (* P_DECODER_CONNECTIVITY_ARRAY = "4'b1111" *) 
  (* P_SINGLE_SLAVE_CONNECTIVITY_ARRAY = "1'b0" *) 
  (* P_TPAYLOAD_WIDTH = "11" *) 
  axis_switch_0_axis_switch_v1_1_15_axis_switch inst
       (.aclk(aclk),
        .aclken(1'b1),
        .arb_dest(NLW_inst_arb_dest_UNCONNECTED[7:0]),
        .arb_done(NLW_inst_arb_done_UNCONNECTED[0]),
        .arb_gnt({1'b0,1'b0,1'b0,1'b0}),
        .arb_id(NLW_inst_arb_id_UNCONNECTED[3:0]),
        .arb_last(NLW_inst_arb_last_UNCONNECTED[3:0]),
        .arb_req(NLW_inst_arb_req_UNCONNECTED[3:0]),
        .arb_sel({1'b0,1'b0}),
        .arb_user(NLW_inst_arb_user_UNCONNECTED[3:0]),
        .aresetn(aresetn),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tdest(m_axis_tdest),
        .m_axis_tid(NLW_inst_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_inst_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .m_axis_tstrb(NLW_inst_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_inst_m_axis_tuser_UNCONNECTED[0]),
        .m_axis_tvalid(m_axis_tvalid),
        .s_axi_ctrl_aclk(1'b0),
        .s_axi_ctrl_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_ctrl_aresetn(1'b0),
        .s_axi_ctrl_arready(NLW_inst_s_axi_ctrl_arready_UNCONNECTED),
        .s_axi_ctrl_arvalid(1'b0),
        .s_axi_ctrl_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_ctrl_awready(NLW_inst_s_axi_ctrl_awready_UNCONNECTED),
        .s_axi_ctrl_awvalid(1'b0),
        .s_axi_ctrl_bready(1'b0),
        .s_axi_ctrl_bresp(NLW_inst_s_axi_ctrl_bresp_UNCONNECTED[1:0]),
        .s_axi_ctrl_bvalid(NLW_inst_s_axi_ctrl_bvalid_UNCONNECTED),
        .s_axi_ctrl_rdata(NLW_inst_s_axi_ctrl_rdata_UNCONNECTED[31:0]),
        .s_axi_ctrl_rready(1'b0),
        .s_axi_ctrl_rresp(NLW_inst_s_axi_ctrl_rresp_UNCONNECTED[1:0]),
        .s_axi_ctrl_rvalid(NLW_inst_s_axi_ctrl_rvalid_UNCONNECTED),
        .s_axi_ctrl_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_ctrl_wready(NLW_inst_s_axi_ctrl_wready_UNCONNECTED),
        .s_axi_ctrl_wvalid(1'b0),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tdest(s_axis_tdest),
        .s_axis_tid({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tkeep({1'b1,1'b1,1'b1,1'b1}),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tready(s_axis_tready),
        .s_axis_tstrb({1'b1,1'b1,1'b1,1'b1}),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(s_axis_tvalid),
        .s_decode_err(s_decode_err),
        .s_req_suppress(s_req_suppress));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_arb_rr" *) 
module axis_switch_0_axis_switch_v1_1_15_arb_rr
   (\gen_tdest_routing.busy_ns ,
    \arb_gnt_r_reg[0]_0 ,
    \busy_r_reg[1] ,
    \arb_gnt_r_reg[1]_0 ,
    arb_busy_r_reg_0,
    \arb_gnt_r_reg[3]_0 ,
    \busy_r_reg[2] ,
    m_axis_tvalid,
    \gen_tdest_routing.busy_ns_0 ,
    \busy_r_reg[3] ,
    \gen_tdest_routing.busy_ns_1 ,
    \gen_tdest_routing.busy_ns_2 ,
    SR,
    \busy_r_reg[0] ,
    D,
    m_axis_tdata,
    m_axis_tlast,
    m_axis_tdest,
    areset_r,
    aclken,
    aclk,
    \gen_tdest_routing.busy_r_reg[0] ,
    s_req_suppress,
    \gen_tdest_routing.busy_r_reg[0]_0 ,
    m_axis_tready,
    \gen_tdest_routing.busy_r_reg[0]_1 ,
    s_axis_tdest,
    s_axis_tvalid,
    \gen_tdest_routing.busy_r_reg[0]_2 ,
    Q,
    s_axis_tdata,
    s_axis_tlast);
  output \gen_tdest_routing.busy_ns ;
  output \arb_gnt_r_reg[0]_0 ;
  output \busy_r_reg[1] ;
  output \arb_gnt_r_reg[1]_0 ;
  output arb_busy_r_reg_0;
  output \arb_gnt_r_reg[3]_0 ;
  output \busy_r_reg[2] ;
  output [0:0]m_axis_tvalid;
  output \gen_tdest_routing.busy_ns_0 ;
  output \busy_r_reg[3] ;
  output \gen_tdest_routing.busy_ns_1 ;
  output \gen_tdest_routing.busy_ns_2 ;
  output [0:0]SR;
  output \busy_r_reg[0] ;
  output [2:0]D;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tlast;
  output [1:0]m_axis_tdest;
  input areset_r;
  input aclken;
  input aclk;
  input \gen_tdest_routing.busy_r_reg[0] ;
  input [3:0]s_req_suppress;
  input \gen_tdest_routing.busy_r_reg[0]_0 ;
  input [0:0]m_axis_tready;
  input \gen_tdest_routing.busy_r_reg[0]_1 ;
  input [7:0]s_axis_tdest;
  input [3:0]s_axis_tvalid;
  input \gen_tdest_routing.busy_r_reg[0]_2 ;
  input [3:0]Q;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tlast;

  wire [2:0]D;
  wire [3:0]Q;
  wire [0:0]SR;
  wire aclk;
  wire aclken;
  wire arb_busy_ns;
  wire arb_busy_r;
  wire arb_busy_r_i_2_n_0;
  wire arb_busy_r_i_3_n_0;
  wire arb_busy_r_i_4_n_0;
  wire arb_busy_r_reg_0;
  wire \arb_gnt_r[0]_i_1_n_0 ;
  wire \arb_gnt_r[1]_i_1_n_0 ;
  wire \arb_gnt_r[2]_i_1_n_0 ;
  wire \arb_gnt_r[3]_i_1_n_0 ;
  wire \arb_gnt_r[3]_i_2_n_0 ;
  wire \arb_gnt_r[3]_i_3_n_0 ;
  wire \arb_gnt_r_reg[0]_0 ;
  wire \arb_gnt_r_reg[1]_0 ;
  wire \arb_gnt_r_reg[3]_0 ;
  wire [1:0]arb_sel_i;
  wire arb_sel_r;
  wire \arb_sel_r[0]_i_1_n_0 ;
  wire \arb_sel_r[0]_i_2_n_0 ;
  wire \arb_sel_r[1]_i_1_n_0 ;
  wire areset_r;
  wire \busy_r_reg[0] ;
  wire \busy_r_reg[1] ;
  wire \busy_r_reg[2] ;
  wire \busy_r_reg[3] ;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.busy_ns_0 ;
  wire \gen_tdest_routing.busy_ns_1 ;
  wire \gen_tdest_routing.busy_ns_2 ;
  wire \gen_tdest_routing.busy_r_reg[0] ;
  wire \gen_tdest_routing.busy_r_reg[0]_0 ;
  wire \gen_tdest_routing.busy_r_reg[0]_1 ;
  wire \gen_tdest_routing.busy_r_reg[0]_2 ;
  wire [7:0]m_axis_tdata;
  wire [1:0]m_axis_tdest;
  wire [0:0]m_axis_tlast;
  wire [0:0]m_axis_tready;
  wire [0:0]m_axis_tvalid;
  wire \m_axis_tvalid[0]_INST_0_i_1_n_0 ;
  wire \m_axis_tvalid[0]_INST_0_i_2_n_0 ;
  wire [31:0]s_axis_tdata;
  wire [7:0]s_axis_tdest;
  wire [3:0]s_axis_tlast;
  wire [3:0]s_axis_tvalid;
  wire [3:0]s_req_suppress;
  wire [1:1]sel_i;

  LUT3 #(
    .INIT(8'hBA)) 
    arb_busy_r_i_1
       (.I0(arb_busy_r_i_2_n_0),
        .I1(arb_busy_r_i_3_n_0),
        .I2(arb_busy_r),
        .O(arb_busy_ns));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFF10)) 
    arb_busy_r_i_2
       (.I0(s_req_suppress[3]),
        .I1(arb_busy_r_i_4_n_0),
        .I2(arb_busy_r_reg_0),
        .I3(\arb_sel_r[0]_i_2_n_0 ),
        .I4(\arb_gnt_r[0]_i_1_n_0 ),
        .I5(\arb_gnt_r[3]_i_3_n_0 ),
        .O(arb_busy_r_i_2_n_0));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h08)) 
    arb_busy_r_i_3
       (.I0(\m_axis_tvalid[0]_INST_0_i_1_n_0 ),
        .I1(m_axis_tready),
        .I2(\m_axis_tvalid[0]_INST_0_i_2_n_0 ),
        .O(arb_busy_r_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'hE)) 
    arb_busy_r_i_4
       (.I0(\busy_r_reg[3] ),
        .I1(\gen_tdest_routing.busy_r_reg[0]_2 ),
        .O(arb_busy_r_i_4_n_0));
  FDRE arb_busy_r_reg
       (.C(aclk),
        .CE(aclken),
        .D(arb_busy_ns),
        .Q(arb_busy_r),
        .R(areset_r));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \arb_gnt_r[0]_i_1 
       (.I0(s_axis_tdest[0]),
        .I1(s_axis_tvalid[0]),
        .I2(s_axis_tdest[1]),
        .I3(\arb_gnt_r_reg[0]_0 ),
        .I4(\gen_tdest_routing.busy_r_reg[0] ),
        .I5(s_req_suppress[0]),
        .O(\arb_gnt_r[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000100)) 
    \arb_gnt_r[1]_i_1 
       (.I0(s_req_suppress[1]),
        .I1(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .I2(\busy_r_reg[1] ),
        .I3(\arb_gnt_r_reg[1]_0 ),
        .I4(\arb_gnt_r[0]_i_1_n_0 ),
        .O(\arb_gnt_r[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000100)) 
    \arb_gnt_r[2]_i_1 
       (.I0(s_req_suppress[2]),
        .I1(\gen_tdest_routing.busy_r_reg[0]_1 ),
        .I2(\busy_r_reg[2] ),
        .I3(\arb_gnt_r_reg[3]_0 ),
        .I4(\arb_gnt_r[0]_i_1_n_0 ),
        .I5(\arb_gnt_r[3]_i_3_n_0 ),
        .O(\arb_gnt_r[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFF4FFF00)) 
    \arb_gnt_r[3]_i_1 
       (.I0(arb_busy_r_i_3_n_0),
        .I1(arb_busy_r),
        .I2(arb_busy_r_i_2_n_0),
        .I3(areset_r),
        .I4(aclken),
        .O(\arb_gnt_r[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h1111111111111101)) 
    \arb_gnt_r[3]_i_2 
       (.I0(\arb_gnt_r[3]_i_3_n_0 ),
        .I1(\arb_gnt_r[0]_i_1_n_0 ),
        .I2(\arb_gnt_r_reg[3]_0 ),
        .I3(\busy_r_reg[2] ),
        .I4(\gen_tdest_routing.busy_r_reg[0]_1 ),
        .I5(s_req_suppress[2]),
        .O(\arb_gnt_r[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \arb_gnt_r[3]_i_3 
       (.I0(s_axis_tdest[2]),
        .I1(s_axis_tvalid[1]),
        .I2(s_axis_tdest[3]),
        .I3(\busy_r_reg[1] ),
        .I4(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .I5(s_req_suppress[1]),
        .O(\arb_gnt_r[3]_i_3_n_0 ));
  FDRE \arb_gnt_r_reg[0] 
       (.C(aclk),
        .CE(aclken),
        .D(\arb_gnt_r[0]_i_1_n_0 ),
        .Q(\arb_gnt_r_reg[0]_0 ),
        .R(\arb_gnt_r[3]_i_1_n_0 ));
  FDRE \arb_gnt_r_reg[1] 
       (.C(aclk),
        .CE(aclken),
        .D(\arb_gnt_r[1]_i_1_n_0 ),
        .Q(\busy_r_reg[1] ),
        .R(\arb_gnt_r[3]_i_1_n_0 ));
  FDRE \arb_gnt_r_reg[2] 
       (.C(aclk),
        .CE(aclken),
        .D(\arb_gnt_r[2]_i_1_n_0 ),
        .Q(\busy_r_reg[2] ),
        .R(\arb_gnt_r[3]_i_1_n_0 ));
  FDRE \arb_gnt_r_reg[3] 
       (.C(aclk),
        .CE(aclken),
        .D(\arb_gnt_r[3]_i_2_n_0 ),
        .Q(\busy_r_reg[3] ),
        .R(\arb_gnt_r[3]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h23FF2300)) 
    \arb_sel_r[0]_i_1 
       (.I0(\arb_gnt_r[3]_i_3_n_0 ),
        .I1(\arb_gnt_r[0]_i_1_n_0 ),
        .I2(\arb_sel_r[0]_i_2_n_0 ),
        .I3(arb_sel_r),
        .I4(arb_sel_i[0]),
        .O(\arb_sel_r[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \arb_sel_r[0]_i_2 
       (.I0(s_axis_tdest[4]),
        .I1(s_axis_tvalid[2]),
        .I2(s_axis_tdest[5]),
        .I3(\busy_r_reg[2] ),
        .I4(\gen_tdest_routing.busy_r_reg[0]_1 ),
        .I5(s_req_suppress[2]),
        .O(\arb_sel_r[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0888080808080808)) 
    \arb_sel_r[0]_i_3 
       (.I0(aclken),
        .I1(arb_busy_r_i_2_n_0),
        .I2(arb_busy_r),
        .I3(\m_axis_tvalid[0]_INST_0_i_2_n_0 ),
        .I4(m_axis_tready),
        .I5(\m_axis_tvalid[0]_INST_0_i_1_n_0 ),
        .O(arb_sel_r));
  LUT6 #(
    .INIT(64'hBFBFFFBF80800080)) 
    \arb_sel_r[1]_i_1 
       (.I0(sel_i),
        .I1(aclken),
        .I2(arb_busy_r_i_2_n_0),
        .I3(arb_busy_r),
        .I4(arb_busy_r_i_3_n_0),
        .I5(arb_sel_i[1]),
        .O(\arb_sel_r[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h0000FEFF)) 
    \arb_sel_r[1]_i_2 
       (.I0(s_req_suppress[1]),
        .I1(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .I2(\busy_r_reg[1] ),
        .I3(\arb_gnt_r_reg[1]_0 ),
        .I4(\arb_gnt_r[0]_i_1_n_0 ),
        .O(sel_i));
  FDRE \arb_sel_r_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .D(\arb_sel_r[0]_i_1_n_0 ),
        .Q(arb_sel_i[0]),
        .R(areset_r));
  FDRE \arb_sel_r_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .D(\arb_sel_r[1]_i_1_n_0 ),
        .Q(arb_sel_i[1]),
        .R(areset_r));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \busy_r[1]_i_1 
       (.I0(\busy_r_reg[1] ),
        .I1(Q[1]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \busy_r[2]_i_1 
       (.I0(\busy_r_reg[2] ),
        .I1(Q[2]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hEA)) 
    \busy_r[3]_i_1 
       (.I0(areset_r),
        .I1(arb_busy_r_i_3_n_0),
        .I2(aclken),
        .O(SR));
  LUT2 #(
    .INIT(4'hE)) 
    \busy_r[3]_i_2 
       (.I0(\busy_r_reg[3] ),
        .I1(Q[3]),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \gen_tdest_routing.busy_r[0]_i_1 
       (.I0(\gen_tdest_routing.busy_r_reg[0] ),
        .I1(\arb_gnt_r_reg[0]_0 ),
        .I2(arb_busy_r_i_3_n_0),
        .O(\gen_tdest_routing.busy_ns ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \gen_tdest_routing.busy_r[0]_i_1__0 
       (.I0(\gen_tdest_routing.busy_r_reg[0]_2 ),
        .I1(\busy_r_reg[3] ),
        .I2(arb_busy_r_i_3_n_0),
        .O(\gen_tdest_routing.busy_ns_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \gen_tdest_routing.busy_r[0]_i_1__1 
       (.I0(\gen_tdest_routing.busy_r_reg[0]_1 ),
        .I1(\busy_r_reg[2] ),
        .I2(arb_busy_r_i_3_n_0),
        .O(\gen_tdest_routing.busy_ns_1 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \gen_tdest_routing.busy_r[0]_i_1__2 
       (.I0(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .I1(\busy_r_reg[1] ),
        .I2(arb_busy_r_i_3_n_0),
        .O(\gen_tdest_routing.busy_ns_2 ));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tdata[0]_INST_0 
       (.I0(s_axis_tdata[0]),
        .I1(s_axis_tdata[24]),
        .I2(s_axis_tdata[16]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tdata[8]),
        .O(m_axis_tdata[0]));
  LUT6 #(
    .INIT(64'hAACCFFF0AACC00F0)) 
    \m_axis_tdata[1]_INST_0 
       (.I0(s_axis_tdata[25]),
        .I1(s_axis_tdata[9]),
        .I2(s_axis_tdata[1]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tdata[17]),
        .O(m_axis_tdata[1]));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tdata[2]_INST_0 
       (.I0(s_axis_tdata[2]),
        .I1(s_axis_tdata[26]),
        .I2(s_axis_tdata[10]),
        .I3(arb_sel_i[0]),
        .I4(arb_sel_i[1]),
        .I5(s_axis_tdata[18]),
        .O(m_axis_tdata[2]));
  LUT6 #(
    .INIT(64'hAACCFFF0AACC00F0)) 
    \m_axis_tdata[3]_INST_0 
       (.I0(s_axis_tdata[27]),
        .I1(s_axis_tdata[11]),
        .I2(s_axis_tdata[3]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tdata[19]),
        .O(m_axis_tdata[3]));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tdata[4]_INST_0 
       (.I0(s_axis_tdata[4]),
        .I1(s_axis_tdata[28]),
        .I2(s_axis_tdata[12]),
        .I3(arb_sel_i[0]),
        .I4(arb_sel_i[1]),
        .I5(s_axis_tdata[20]),
        .O(m_axis_tdata[4]));
  LUT6 #(
    .INIT(64'hAACCFFF0AACC00F0)) 
    \m_axis_tdata[5]_INST_0 
       (.I0(s_axis_tdata[29]),
        .I1(s_axis_tdata[13]),
        .I2(s_axis_tdata[5]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tdata[21]),
        .O(m_axis_tdata[5]));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tdata[6]_INST_0 
       (.I0(s_axis_tdata[6]),
        .I1(s_axis_tdata[30]),
        .I2(s_axis_tdata[14]),
        .I3(arb_sel_i[0]),
        .I4(arb_sel_i[1]),
        .I5(s_axis_tdata[22]),
        .O(m_axis_tdata[6]));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tdata[7]_INST_0 
       (.I0(s_axis_tdata[7]),
        .I1(s_axis_tdata[31]),
        .I2(s_axis_tdata[23]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tdata[15]),
        .O(m_axis_tdata[7]));
  LUT6 #(
    .INIT(64'hAACCFFF0AACC00F0)) 
    \m_axis_tdest[0]_INST_0 
       (.I0(s_axis_tdest[6]),
        .I1(s_axis_tdest[2]),
        .I2(s_axis_tdest[0]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tdest[4]),
        .O(m_axis_tdest[0]));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tdest[1]_INST_0 
       (.I0(s_axis_tdest[1]),
        .I1(s_axis_tdest[7]),
        .I2(s_axis_tdest[3]),
        .I3(arb_sel_i[0]),
        .I4(arb_sel_i[1]),
        .I5(s_axis_tdest[5]),
        .O(m_axis_tdest[1]));
  LUT6 #(
    .INIT(64'hCCFFF0AACC00F0AA)) 
    \m_axis_tlast[0]_INST_0 
       (.I0(s_axis_tlast[0]),
        .I1(s_axis_tlast[3]),
        .I2(s_axis_tlast[2]),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(s_axis_tlast[1]),
        .O(m_axis_tlast));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \m_axis_tvalid[0]_INST_0 
       (.I0(\m_axis_tvalid[0]_INST_0_i_1_n_0 ),
        .I1(\m_axis_tvalid[0]_INST_0_i_2_n_0 ),
        .O(m_axis_tvalid));
  LUT6 #(
    .INIT(64'hFFAACCF000AACCF0)) 
    \m_axis_tvalid[0]_INST_0_i_1 
       (.I0(\arb_gnt_r_reg[1]_0 ),
        .I1(\arb_gnt_r_reg[3]_0 ),
        .I2(\busy_r_reg[0] ),
        .I3(arb_sel_i[1]),
        .I4(arb_sel_i[0]),
        .I5(arb_busy_r_reg_0),
        .O(\m_axis_tvalid[0]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \m_axis_tvalid[0]_INST_0_i_2 
       (.I0(\busy_r_reg[1] ),
        .I1(Q[1]),
        .I2(\arb_gnt_r_reg[0]_0 ),
        .I3(Q[0]),
        .I4(D[2]),
        .I5(D[1]),
        .O(\m_axis_tvalid[0]_INST_0_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \s_axis_tready[0]_INST_0_i_1 
       (.I0(s_axis_tdest[1]),
        .I1(s_axis_tvalid[0]),
        .I2(s_axis_tdest[0]),
        .O(\busy_r_reg[0] ));
  LUT3 #(
    .INIT(8'h04)) 
    \s_axis_tready[1]_INST_0_i_1 
       (.I0(s_axis_tdest[3]),
        .I1(s_axis_tvalid[1]),
        .I2(s_axis_tdest[2]),
        .O(\arb_gnt_r_reg[1]_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \s_axis_tready[2]_INST_0_i_1 
       (.I0(s_axis_tdest[5]),
        .I1(s_axis_tvalid[2]),
        .I2(s_axis_tdest[4]),
        .O(\arb_gnt_r_reg[3]_0 ));
  LUT3 #(
    .INIT(8'h04)) 
    \s_axis_tready[3]_INST_0_i_1 
       (.I0(s_axis_tdest[7]),
        .I1(s_axis_tvalid[3]),
        .I2(s_axis_tdest[6]),
        .O(arb_busy_r_reg_0));
endmodule

(* C_ARB_ALGORITHM = "1" *) (* C_ARB_ON_MAX_XFERS = "1" *) (* C_ARB_ON_NUM_CYCLES = "0" *) 
(* C_ARB_ON_TLAST = "1" *) (* C_AXIS_SIGNAL_SET = "83" *) (* C_AXIS_TDATA_WIDTH = "8" *) 
(* C_AXIS_TDEST_WIDTH = "2" *) (* C_AXIS_TID_WIDTH = "1" *) (* C_AXIS_TUSER_WIDTH = "1" *) 
(* C_COMMON_CLOCK = "0" *) (* C_DECODER_REG = "0" *) (* C_FAMILY = "artix7" *) 
(* C_INCLUDE_ARBITER = "1" *) (* C_LOG_SI_SLOTS = "2" *) (* C_M_AXIS_BASETDEST_ARRAY = "2'b00" *) 
(* C_M_AXIS_CONNECTIVITY_ARRAY = "4'b1111" *) (* C_M_AXIS_HIGHTDEST_ARRAY = "2'b00" *) (* C_NUM_MI_SLOTS = "1" *) 
(* C_NUM_SI_SLOTS = "4" *) (* C_OUTPUT_REG = "0" *) (* C_ROUTING_MODE = "0" *) 
(* C_S_AXI_CTRL_ADDR_WIDTH = "7" *) (* C_S_AXI_CTRL_DATA_WIDTH = "32" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* G_INDX_SS_TDATA = "1" *) (* G_INDX_SS_TDEST = "6" *) (* G_INDX_SS_TID = "5" *) 
(* G_INDX_SS_TKEEP = "3" *) (* G_INDX_SS_TLAST = "4" *) (* G_INDX_SS_TREADY = "0" *) 
(* G_INDX_SS_TSTRB = "2" *) (* G_INDX_SS_TUSER = "7" *) (* G_MASK_SS_TDATA = "2" *) 
(* G_MASK_SS_TDEST = "64" *) (* G_MASK_SS_TID = "32" *) (* G_MASK_SS_TKEEP = "8" *) 
(* G_MASK_SS_TLAST = "16" *) (* G_MASK_SS_TREADY = "1" *) (* G_MASK_SS_TSTRB = "4" *) 
(* G_MASK_SS_TUSER = "128" *) (* G_TASK_SEVERITY_ERR = "2" *) (* G_TASK_SEVERITY_INFO = "0" *) 
(* G_TASK_SEVERITY_WARNING = "1" *) (* LP_CTRL_REG_WIDTH = "25" *) (* LP_MERGEDOWN_MUX = "0" *) 
(* LP_NUM_SYNCHRONIZER_STAGES = "4" *) (* ORIG_REF_NAME = "axis_switch_v1_1_15_axis_switch" *) (* P_DECODER_CONNECTIVITY_ARRAY = "4'b1111" *) 
(* P_SINGLE_SLAVE_CONNECTIVITY_ARRAY = "1'b0" *) (* P_TPAYLOAD_WIDTH = "11" *) 
module axis_switch_0_axis_switch_v1_1_15_axis_switch
   (aclk,
    aresetn,
    aclken,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser,
    arb_req,
    arb_done,
    arb_gnt,
    arb_sel,
    arb_last,
    arb_id,
    arb_dest,
    arb_user,
    s_req_suppress,
    s_axi_ctrl_aclk,
    s_axi_ctrl_aresetn,
    s_axi_ctrl_awvalid,
    s_axi_ctrl_awready,
    s_axi_ctrl_awaddr,
    s_axi_ctrl_wvalid,
    s_axi_ctrl_wready,
    s_axi_ctrl_wdata,
    s_axi_ctrl_bvalid,
    s_axi_ctrl_bready,
    s_axi_ctrl_bresp,
    s_axi_ctrl_arvalid,
    s_axi_ctrl_arready,
    s_axi_ctrl_araddr,
    s_axi_ctrl_rvalid,
    s_axi_ctrl_rready,
    s_axi_ctrl_rdata,
    s_axi_ctrl_rresp,
    s_decode_err);
  input aclk;
  input aresetn;
  input aclken;
  input [3:0]s_axis_tvalid;
  output [3:0]s_axis_tready;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tstrb;
  input [3:0]s_axis_tkeep;
  input [3:0]s_axis_tlast;
  input [3:0]s_axis_tid;
  input [7:0]s_axis_tdest;
  input [3:0]s_axis_tuser;
  output [0:0]m_axis_tvalid;
  input [0:0]m_axis_tready;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tstrb;
  output [0:0]m_axis_tkeep;
  output [0:0]m_axis_tlast;
  output [0:0]m_axis_tid;
  output [1:0]m_axis_tdest;
  output [0:0]m_axis_tuser;
  output [3:0]arb_req;
  output [0:0]arb_done;
  input [3:0]arb_gnt;
  input [1:0]arb_sel;
  output [3:0]arb_last;
  output [3:0]arb_id;
  output [7:0]arb_dest;
  output [3:0]arb_user;
  input [3:0]s_req_suppress;
  input s_axi_ctrl_aclk;
  input s_axi_ctrl_aresetn;
  input s_axi_ctrl_awvalid;
  output s_axi_ctrl_awready;
  input [6:0]s_axi_ctrl_awaddr;
  input s_axi_ctrl_wvalid;
  output s_axi_ctrl_wready;
  input [31:0]s_axi_ctrl_wdata;
  output s_axi_ctrl_bvalid;
  input s_axi_ctrl_bready;
  output [1:0]s_axi_ctrl_bresp;
  input s_axi_ctrl_arvalid;
  output s_axi_ctrl_arready;
  input [6:0]s_axi_ctrl_araddr;
  output s_axi_ctrl_rvalid;
  input s_axi_ctrl_rready;
  output [31:0]s_axi_ctrl_rdata;
  output [1:0]s_axi_ctrl_rresp;
  output [3:0]s_decode_err;

  wire \<const0> ;
  wire \<const1> ;
  wire aclk;
  wire aclken;
  wire [3:0]arb_gnt_i;
  wire areset_r;
  wire aresetn;
  wire \gen_decoder[0].axisc_decoder_0_n_0 ;
  wire \gen_decoder[1].axisc_decoder_0_n_1 ;
  wire \gen_decoder[2].axisc_decoder_0_n_1 ;
  wire \gen_decoder[3].axisc_decoder_0_n_1 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_12 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_13 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_14 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_15 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_16 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_5 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_6 ;
  wire \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_7 ;
  wire [3:0]\gen_tdest_router.busy_r ;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.busy_ns_0 ;
  wire \gen_tdest_routing.busy_ns_1 ;
  wire \gen_tdest_routing.busy_ns_2 ;
  wire [7:0]m_axis_tdata;
  wire [1:0]m_axis_tdest;
  wire [0:0]m_axis_tlast;
  wire [0:0]m_axis_tready;
  wire [0:0]m_axis_tvalid;
  wire p_0_in;
  wire [31:0]s_axis_tdata;
  wire [7:0]s_axis_tdest;
  wire [3:0]s_axis_tlast;
  wire [3:0]s_axis_tready;
  wire [3:0]s_axis_tvalid;
  wire [3:0]s_decode_err;
  wire [3:0]s_req_suppress;

  assign arb_dest[7] = \<const0> ;
  assign arb_dest[6] = \<const0> ;
  assign arb_dest[5] = \<const0> ;
  assign arb_dest[4] = \<const0> ;
  assign arb_dest[3] = \<const0> ;
  assign arb_dest[2] = \<const0> ;
  assign arb_dest[1] = \<const0> ;
  assign arb_dest[0] = \<const0> ;
  assign arb_done[0] = \<const0> ;
  assign arb_id[3] = \<const0> ;
  assign arb_id[2] = \<const0> ;
  assign arb_id[1] = \<const0> ;
  assign arb_id[0] = \<const0> ;
  assign arb_last[3] = \<const0> ;
  assign arb_last[2] = \<const0> ;
  assign arb_last[1] = \<const0> ;
  assign arb_last[0] = \<const0> ;
  assign arb_req[3] = \<const0> ;
  assign arb_req[2] = \<const0> ;
  assign arb_req[1] = \<const0> ;
  assign arb_req[0] = \<const0> ;
  assign arb_user[3] = \<const0> ;
  assign arb_user[2] = \<const0> ;
  assign arb_user[1] = \<const0> ;
  assign arb_user[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[0] = \<const1> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  assign s_axi_ctrl_arready = \<const0> ;
  assign s_axi_ctrl_awready = \<const0> ;
  assign s_axi_ctrl_bresp[1] = \<const0> ;
  assign s_axi_ctrl_bresp[0] = \<const0> ;
  assign s_axi_ctrl_bvalid = \<const0> ;
  assign s_axi_ctrl_rdata[31] = \<const0> ;
  assign s_axi_ctrl_rdata[30] = \<const0> ;
  assign s_axi_ctrl_rdata[29] = \<const0> ;
  assign s_axi_ctrl_rdata[28] = \<const0> ;
  assign s_axi_ctrl_rdata[27] = \<const0> ;
  assign s_axi_ctrl_rdata[26] = \<const0> ;
  assign s_axi_ctrl_rdata[25] = \<const0> ;
  assign s_axi_ctrl_rdata[24] = \<const0> ;
  assign s_axi_ctrl_rdata[23] = \<const0> ;
  assign s_axi_ctrl_rdata[22] = \<const0> ;
  assign s_axi_ctrl_rdata[21] = \<const0> ;
  assign s_axi_ctrl_rdata[20] = \<const0> ;
  assign s_axi_ctrl_rdata[19] = \<const0> ;
  assign s_axi_ctrl_rdata[18] = \<const0> ;
  assign s_axi_ctrl_rdata[17] = \<const0> ;
  assign s_axi_ctrl_rdata[16] = \<const0> ;
  assign s_axi_ctrl_rdata[15] = \<const0> ;
  assign s_axi_ctrl_rdata[14] = \<const0> ;
  assign s_axi_ctrl_rdata[13] = \<const0> ;
  assign s_axi_ctrl_rdata[12] = \<const0> ;
  assign s_axi_ctrl_rdata[11] = \<const0> ;
  assign s_axi_ctrl_rdata[10] = \<const0> ;
  assign s_axi_ctrl_rdata[9] = \<const0> ;
  assign s_axi_ctrl_rdata[8] = \<const0> ;
  assign s_axi_ctrl_rdata[7] = \<const0> ;
  assign s_axi_ctrl_rdata[6] = \<const0> ;
  assign s_axi_ctrl_rdata[5] = \<const0> ;
  assign s_axi_ctrl_rdata[4] = \<const0> ;
  assign s_axi_ctrl_rdata[3] = \<const0> ;
  assign s_axi_ctrl_rdata[2] = \<const0> ;
  assign s_axi_ctrl_rdata[1] = \<const0> ;
  assign s_axi_ctrl_rdata[0] = \<const0> ;
  assign s_axi_ctrl_rresp[1] = \<const0> ;
  assign s_axi_ctrl_rresp[0] = \<const0> ;
  assign s_axi_ctrl_rvalid = \<const0> ;
  assign s_axi_ctrl_wready = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    areset_r_i_1
       (.I0(aresetn),
        .O(p_0_in));
  FDRE areset_r_reg
       (.C(aclk),
        .CE(1'b1),
        .D(p_0_in),
        .Q(areset_r),
        .R(1'b0));
  axis_switch_0_axis_switch_v1_1_15_axisc_decoder \gen_decoder[0].axisc_decoder_0 
       (.Q(\gen_tdest_router.busy_r [0]),
        .aclk(aclk),
        .aclken(aclken),
        .arb_gnt_i(arb_gnt_i[0]),
        .\arb_gnt_r_reg[0] (\gen_decoder[0].axisc_decoder_0_n_0 ),
        .areset_r(areset_r),
        .\gen_tdest_routing.busy_ns (\gen_tdest_routing.busy_ns_2 ),
        .m_axis_tready(m_axis_tready),
        .s_axis_tdest(s_axis_tdest[1:0]),
        .s_axis_tdest_0_sp_1(\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_13 ),
        .s_axis_tready(s_axis_tready[0]),
        .s_axis_tvalid(s_axis_tvalid[0]),
        .s_decode_err(s_decode_err[0]));
  axis_switch_0_axis_switch_v1_1_15_axisc_decoder_0 \gen_decoder[1].axisc_decoder_0 
       (.Q(\gen_tdest_router.busy_r [1]),
        .aclk(aclk),
        .aclken(aclken),
        .arb_gnt_i(arb_gnt_i[1]),
        .areset_r(areset_r),
        .\gen_tdest_routing.busy_ns (\gen_tdest_routing.busy_ns ),
        .\gen_tdest_routing.busy_r_reg[0]_0 (\gen_decoder[1].axisc_decoder_0_n_1 ),
        .m_axis_tready(m_axis_tready),
        .s_axis_tdest(s_axis_tdest[3:2]),
        .\s_axis_tdest[2] (\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_5 ),
        .s_axis_tready(s_axis_tready[1]),
        .s_axis_tvalid(s_axis_tvalid[1]),
        .s_decode_err(s_decode_err[1]));
  axis_switch_0_axis_switch_v1_1_15_axisc_decoder_1 \gen_decoder[2].axisc_decoder_0 
       (.Q(\gen_tdest_router.busy_r [2]),
        .aclk(aclk),
        .aclken(aclken),
        .arb_gnt_i(arb_gnt_i[2]),
        .areset_r(areset_r),
        .\gen_tdest_routing.busy_ns (\gen_tdest_routing.busy_ns_0 ),
        .\gen_tdest_routing.busy_r_reg[0]_0 (\gen_decoder[2].axisc_decoder_0_n_1 ),
        .m_axis_tready(m_axis_tready),
        .s_axis_tdest(s_axis_tdest[5:4]),
        .\s_axis_tdest[4] (\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_7 ),
        .s_axis_tready(s_axis_tready[2]),
        .s_axis_tvalid(s_axis_tvalid[2]),
        .s_decode_err(s_decode_err[2]));
  axis_switch_0_axis_switch_v1_1_15_axisc_decoder_2 \gen_decoder[3].axisc_decoder_0 
       (.Q(\gen_tdest_router.busy_r [3]),
        .aclk(aclk),
        .aclken(aclken),
        .arb_gnt_i(arb_gnt_i[3]),
        .areset_r(areset_r),
        .\gen_tdest_routing.busy_ns (\gen_tdest_routing.busy_ns_1 ),
        .\gen_tdest_routing.busy_r_reg[0]_0 (\gen_decoder[3].axisc_decoder_0_n_1 ),
        .m_axis_tready(m_axis_tready),
        .s_axis_tdest(s_axis_tdest[7:6]),
        .\s_axis_tdest[6] (\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_6 ),
        .s_axis_tready(s_axis_tready[3]),
        .s_axis_tvalid(s_axis_tvalid[3]),
        .s_decode_err(s_decode_err[3]));
  axis_switch_0_axis_switch_v1_1_15_axis_switch_arbiter \gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter 
       (.D({\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_14 ,\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_15 ,\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_16 }),
        .Q(\gen_tdest_router.busy_r ),
        .SR(\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_12 ),
        .aclk(aclk),
        .aclken(aclken),
        .arb_busy_r_reg(\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_6 ),
        .arb_gnt_i(arb_gnt_i),
        .\arb_gnt_r_reg[1] (\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_5 ),
        .\arb_gnt_r_reg[3] (\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_7 ),
        .areset_r(areset_r),
        .\busy_r_reg[0] (\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_13 ),
        .\gen_tdest_routing.busy_ns (\gen_tdest_routing.busy_ns_2 ),
        .\gen_tdest_routing.busy_ns_0 (\gen_tdest_routing.busy_ns_1 ),
        .\gen_tdest_routing.busy_ns_1 (\gen_tdest_routing.busy_ns_0 ),
        .\gen_tdest_routing.busy_ns_2 (\gen_tdest_routing.busy_ns ),
        .\gen_tdest_routing.busy_r_reg[0] (\gen_decoder[0].axisc_decoder_0_n_0 ),
        .\gen_tdest_routing.busy_r_reg[0]_0 (\gen_decoder[1].axisc_decoder_0_n_1 ),
        .\gen_tdest_routing.busy_r_reg[0]_1 (\gen_decoder[2].axisc_decoder_0_n_1 ),
        .\gen_tdest_routing.busy_r_reg[0]_2 (\gen_decoder[3].axisc_decoder_0_n_1 ),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tdest(m_axis_tdest),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .m_axis_tvalid(m_axis_tvalid),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tdest(s_axis_tdest),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tvalid(s_axis_tvalid),
        .s_req_suppress(s_req_suppress));
  axis_switch_0_axis_switch_v1_1_15_axisc_transfer_mux \gen_transfer_mux[0].axisc_transfer_mux_0 
       (.D({\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_14 ,\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_15 ,\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_16 }),
        .Q(\gen_tdest_router.busy_r ),
        .SR(\gen_int_arbiter.gen_arbiter.axis_switch_v1_1_15_axis_switch_arbiter_n_12 ),
        .aclk(aclk),
        .aclken(aclken),
        .arb_gnt_i(arb_gnt_i[0]));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axis_switch_arbiter" *) 
module axis_switch_0_axis_switch_v1_1_15_axis_switch_arbiter
   (\gen_tdest_routing.busy_ns ,
    arb_gnt_i,
    \arb_gnt_r_reg[1] ,
    arb_busy_r_reg,
    \arb_gnt_r_reg[3] ,
    m_axis_tvalid,
    \gen_tdest_routing.busy_ns_0 ,
    \gen_tdest_routing.busy_ns_1 ,
    \gen_tdest_routing.busy_ns_2 ,
    SR,
    \busy_r_reg[0] ,
    D,
    m_axis_tdata,
    m_axis_tlast,
    m_axis_tdest,
    areset_r,
    aclken,
    aclk,
    \gen_tdest_routing.busy_r_reg[0] ,
    s_req_suppress,
    \gen_tdest_routing.busy_r_reg[0]_0 ,
    m_axis_tready,
    \gen_tdest_routing.busy_r_reg[0]_1 ,
    s_axis_tdest,
    s_axis_tvalid,
    \gen_tdest_routing.busy_r_reg[0]_2 ,
    Q,
    s_axis_tdata,
    s_axis_tlast);
  output \gen_tdest_routing.busy_ns ;
  output [3:0]arb_gnt_i;
  output \arb_gnt_r_reg[1] ;
  output arb_busy_r_reg;
  output \arb_gnt_r_reg[3] ;
  output [0:0]m_axis_tvalid;
  output \gen_tdest_routing.busy_ns_0 ;
  output \gen_tdest_routing.busy_ns_1 ;
  output \gen_tdest_routing.busy_ns_2 ;
  output [0:0]SR;
  output \busy_r_reg[0] ;
  output [2:0]D;
  output [7:0]m_axis_tdata;
  output [0:0]m_axis_tlast;
  output [1:0]m_axis_tdest;
  input areset_r;
  input aclken;
  input aclk;
  input \gen_tdest_routing.busy_r_reg[0] ;
  input [3:0]s_req_suppress;
  input \gen_tdest_routing.busy_r_reg[0]_0 ;
  input [0:0]m_axis_tready;
  input \gen_tdest_routing.busy_r_reg[0]_1 ;
  input [7:0]s_axis_tdest;
  input [3:0]s_axis_tvalid;
  input \gen_tdest_routing.busy_r_reg[0]_2 ;
  input [3:0]Q;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tlast;

  wire [2:0]D;
  wire [3:0]Q;
  wire [0:0]SR;
  wire aclk;
  wire aclken;
  wire arb_busy_r_reg;
  wire [3:0]arb_gnt_i;
  wire \arb_gnt_r_reg[1] ;
  wire \arb_gnt_r_reg[3] ;
  wire areset_r;
  wire \busy_r_reg[0] ;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.busy_ns_0 ;
  wire \gen_tdest_routing.busy_ns_1 ;
  wire \gen_tdest_routing.busy_ns_2 ;
  wire \gen_tdest_routing.busy_r_reg[0] ;
  wire \gen_tdest_routing.busy_r_reg[0]_0 ;
  wire \gen_tdest_routing.busy_r_reg[0]_1 ;
  wire \gen_tdest_routing.busy_r_reg[0]_2 ;
  wire [7:0]m_axis_tdata;
  wire [1:0]m_axis_tdest;
  wire [0:0]m_axis_tlast;
  wire [0:0]m_axis_tready;
  wire [0:0]m_axis_tvalid;
  wire [31:0]s_axis_tdata;
  wire [7:0]s_axis_tdest;
  wire [3:0]s_axis_tlast;
  wire [3:0]s_axis_tvalid;
  wire [3:0]s_req_suppress;

  axis_switch_0_axis_switch_v1_1_15_arb_rr \gen_mi_arb[0].gen_arb_algorithm.gen_fixed_priority.inst_arb_rr_1 
       (.D(D),
        .Q(Q),
        .SR(SR),
        .aclk(aclk),
        .aclken(aclken),
        .arb_busy_r_reg_0(arb_busy_r_reg),
        .\arb_gnt_r_reg[0]_0 (arb_gnt_i[0]),
        .\arb_gnt_r_reg[1]_0 (\arb_gnt_r_reg[1] ),
        .\arb_gnt_r_reg[3]_0 (\arb_gnt_r_reg[3] ),
        .areset_r(areset_r),
        .\busy_r_reg[0] (\busy_r_reg[0] ),
        .\busy_r_reg[1] (arb_gnt_i[1]),
        .\busy_r_reg[2] (arb_gnt_i[2]),
        .\busy_r_reg[3] (arb_gnt_i[3]),
        .\gen_tdest_routing.busy_ns (\gen_tdest_routing.busy_ns ),
        .\gen_tdest_routing.busy_ns_0 (\gen_tdest_routing.busy_ns_0 ),
        .\gen_tdest_routing.busy_ns_1 (\gen_tdest_routing.busy_ns_1 ),
        .\gen_tdest_routing.busy_ns_2 (\gen_tdest_routing.busy_ns_2 ),
        .\gen_tdest_routing.busy_r_reg[0] (\gen_tdest_routing.busy_r_reg[0] ),
        .\gen_tdest_routing.busy_r_reg[0]_0 (\gen_tdest_routing.busy_r_reg[0]_0 ),
        .\gen_tdest_routing.busy_r_reg[0]_1 (\gen_tdest_routing.busy_r_reg[0]_1 ),
        .\gen_tdest_routing.busy_r_reg[0]_2 (\gen_tdest_routing.busy_r_reg[0]_2 ),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tdest(m_axis_tdest),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .m_axis_tvalid(m_axis_tvalid),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tdest(s_axis_tdest),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tvalid(s_axis_tvalid),
        .s_req_suppress(s_req_suppress));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axisc_arb_responder" *) 
module axis_switch_0_axis_switch_v1_1_15_axisc_arb_responder
   (Q,
    arb_gnt_i,
    SR,
    aclken,
    D,
    aclk);
  output [3:0]Q;
  input [0:0]arb_gnt_i;
  input [0:0]SR;
  input aclken;
  input [2:0]D;
  input aclk;

  wire [2:0]D;
  wire [3:0]Q;
  wire [0:0]SR;
  wire aclk;
  wire aclken;
  wire [0:0]arb_gnt_i;
  wire \busy_r[0]_i_1_n_0 ;

  LUT2 #(
    .INIT(4'hE)) 
    \busy_r[0]_i_1 
       (.I0(Q[0]),
        .I1(arb_gnt_i),
        .O(\busy_r[0]_i_1_n_0 ));
  FDRE \busy_r_reg[0] 
       (.C(aclk),
        .CE(aclken),
        .D(\busy_r[0]_i_1_n_0 ),
        .Q(Q[0]),
        .R(SR));
  FDRE \busy_r_reg[1] 
       (.C(aclk),
        .CE(aclken),
        .D(D[0]),
        .Q(Q[1]),
        .R(SR));
  FDRE \busy_r_reg[2] 
       (.C(aclk),
        .CE(aclken),
        .D(D[1]),
        .Q(Q[2]),
        .R(SR));
  FDRE \busy_r_reg[3] 
       (.C(aclk),
        .CE(aclken),
        .D(D[2]),
        .Q(Q[3]),
        .R(SR));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axisc_decoder" *) 
module axis_switch_0_axis_switch_v1_1_15_axisc_decoder
   (\arb_gnt_r_reg[0] ,
    s_decode_err,
    s_axis_tready,
    areset_r,
    aclken,
    \gen_tdest_routing.busy_ns ,
    aclk,
    s_axis_tdest,
    s_axis_tvalid,
    Q,
    arb_gnt_i,
    m_axis_tready,
    s_axis_tdest_0_sp_1);
  output \arb_gnt_r_reg[0] ;
  output [0:0]s_decode_err;
  output [0:0]s_axis_tready;
  input areset_r;
  input aclken;
  input \gen_tdest_routing.busy_ns ;
  input aclk;
  input [1:0]s_axis_tdest;
  input [0:0]s_axis_tvalid;
  input [0:0]Q;
  input [0:0]arb_gnt_i;
  input [0:0]m_axis_tready;
  input s_axis_tdest_0_sp_1;

  wire [0:0]Q;
  wire aclk;
  wire aclken;
  wire [0:0]arb_gnt_i;
  wire \arb_gnt_r_reg[0] ;
  wire areset_r;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.decode_err_r0 ;
  wire [0:0]m_axis_tready;
  wire [1:0]s_axis_tdest;
  wire s_axis_tdest_0_sn_1;
  wire [0:0]s_axis_tready;
  wire [0:0]s_axis_tvalid;
  wire [0:0]s_decode_err;

  assign s_axis_tdest_0_sn_1 = s_axis_tdest_0_sp_1;
  FDRE \gen_tdest_routing.busy_r_reg[0] 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.busy_ns ),
        .Q(\arb_gnt_r_reg[0] ),
        .R(areset_r));
  LUT4 #(
    .INIT(16'h5040)) 
    \gen_tdest_routing.decode_err_r_i_1 
       (.I0(s_decode_err),
        .I1(s_axis_tdest[0]),
        .I2(s_axis_tvalid),
        .I3(s_axis_tdest[1]),
        .O(\gen_tdest_routing.decode_err_r0 ));
  FDRE \gen_tdest_routing.decode_err_r_reg 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.decode_err_r0 ),
        .Q(s_decode_err),
        .R(areset_r));
  LUT5 #(
    .INIT(32'hFEAAAAAA)) 
    \s_axis_tready[0]_INST_0 
       (.I0(s_decode_err),
        .I1(Q),
        .I2(arb_gnt_i),
        .I3(m_axis_tready),
        .I4(s_axis_tdest_0_sn_1),
        .O(s_axis_tready));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axisc_decoder" *) 
module axis_switch_0_axis_switch_v1_1_15_axisc_decoder_0
   (s_decode_err,
    \gen_tdest_routing.busy_r_reg[0]_0 ,
    s_axis_tready,
    areset_r,
    aclken,
    aclk,
    \gen_tdest_routing.busy_ns ,
    s_axis_tdest,
    s_axis_tvalid,
    m_axis_tready,
    Q,
    arb_gnt_i,
    \s_axis_tdest[2] );
  output [0:0]s_decode_err;
  output \gen_tdest_routing.busy_r_reg[0]_0 ;
  output [0:0]s_axis_tready;
  input areset_r;
  input aclken;
  input aclk;
  input \gen_tdest_routing.busy_ns ;
  input [1:0]s_axis_tdest;
  input [0:0]s_axis_tvalid;
  input [0:0]m_axis_tready;
  input [0:0]Q;
  input [0:0]arb_gnt_i;
  input \s_axis_tdest[2] ;

  wire [0:0]Q;
  wire aclk;
  wire aclken;
  wire [0:0]arb_gnt_i;
  wire areset_r;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.busy_r_reg[0]_0 ;
  wire \gen_tdest_routing.decode_err_r0 ;
  wire [0:0]m_axis_tready;
  wire [1:0]s_axis_tdest;
  wire \s_axis_tdest[2] ;
  wire [0:0]s_axis_tready;
  wire [0:0]s_axis_tvalid;
  wire [0:0]s_decode_err;

  FDRE \gen_tdest_routing.busy_r_reg[0] 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.busy_ns ),
        .Q(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .R(areset_r));
  LUT4 #(
    .INIT(16'h5040)) 
    \gen_tdest_routing.decode_err_r_i_1__1 
       (.I0(s_decode_err),
        .I1(s_axis_tdest[0]),
        .I2(s_axis_tvalid),
        .I3(s_axis_tdest[1]),
        .O(\gen_tdest_routing.decode_err_r0 ));
  FDRE \gen_tdest_routing.decode_err_r_reg 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.decode_err_r0 ),
        .Q(s_decode_err),
        .R(areset_r));
  LUT5 #(
    .INIT(32'hEEEAAAAA)) 
    \s_axis_tready[1]_INST_0 
       (.I0(s_decode_err),
        .I1(m_axis_tready),
        .I2(Q),
        .I3(arb_gnt_i),
        .I4(\s_axis_tdest[2] ),
        .O(s_axis_tready));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axisc_decoder" *) 
module axis_switch_0_axis_switch_v1_1_15_axisc_decoder_1
   (s_decode_err,
    \gen_tdest_routing.busy_r_reg[0]_0 ,
    s_axis_tready,
    areset_r,
    aclken,
    aclk,
    \gen_tdest_routing.busy_ns ,
    s_axis_tdest,
    s_axis_tvalid,
    m_axis_tready,
    Q,
    arb_gnt_i,
    \s_axis_tdest[4] );
  output [0:0]s_decode_err;
  output \gen_tdest_routing.busy_r_reg[0]_0 ;
  output [0:0]s_axis_tready;
  input areset_r;
  input aclken;
  input aclk;
  input \gen_tdest_routing.busy_ns ;
  input [1:0]s_axis_tdest;
  input [0:0]s_axis_tvalid;
  input [0:0]m_axis_tready;
  input [0:0]Q;
  input [0:0]arb_gnt_i;
  input \s_axis_tdest[4] ;

  wire [0:0]Q;
  wire aclk;
  wire aclken;
  wire [0:0]arb_gnt_i;
  wire areset_r;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.busy_r_reg[0]_0 ;
  wire \gen_tdest_routing.decode_err_r0 ;
  wire [0:0]m_axis_tready;
  wire [1:0]s_axis_tdest;
  wire \s_axis_tdest[4] ;
  wire [0:0]s_axis_tready;
  wire [0:0]s_axis_tvalid;
  wire [0:0]s_decode_err;

  FDRE \gen_tdest_routing.busy_r_reg[0] 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.busy_ns ),
        .Q(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .R(areset_r));
  LUT4 #(
    .INIT(16'h5040)) 
    \gen_tdest_routing.decode_err_r_i_1__0 
       (.I0(s_decode_err),
        .I1(s_axis_tdest[0]),
        .I2(s_axis_tvalid),
        .I3(s_axis_tdest[1]),
        .O(\gen_tdest_routing.decode_err_r0 ));
  FDRE \gen_tdest_routing.decode_err_r_reg 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.decode_err_r0 ),
        .Q(s_decode_err),
        .R(areset_r));
  LUT5 #(
    .INIT(32'hEEEAAAAA)) 
    \s_axis_tready[2]_INST_0 
       (.I0(s_decode_err),
        .I1(m_axis_tready),
        .I2(Q),
        .I3(arb_gnt_i),
        .I4(\s_axis_tdest[4] ),
        .O(s_axis_tready));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axisc_decoder" *) 
module axis_switch_0_axis_switch_v1_1_15_axisc_decoder_2
   (s_decode_err,
    \gen_tdest_routing.busy_r_reg[0]_0 ,
    s_axis_tready,
    areset_r,
    aclken,
    aclk,
    \gen_tdest_routing.busy_ns ,
    s_axis_tdest,
    s_axis_tvalid,
    m_axis_tready,
    Q,
    arb_gnt_i,
    \s_axis_tdest[6] );
  output [0:0]s_decode_err;
  output \gen_tdest_routing.busy_r_reg[0]_0 ;
  output [0:0]s_axis_tready;
  input areset_r;
  input aclken;
  input aclk;
  input \gen_tdest_routing.busy_ns ;
  input [1:0]s_axis_tdest;
  input [0:0]s_axis_tvalid;
  input [0:0]m_axis_tready;
  input [0:0]Q;
  input [0:0]arb_gnt_i;
  input \s_axis_tdest[6] ;

  wire [0:0]Q;
  wire aclk;
  wire aclken;
  wire [0:0]arb_gnt_i;
  wire areset_r;
  wire \gen_tdest_routing.busy_ns ;
  wire \gen_tdest_routing.busy_r_reg[0]_0 ;
  wire \gen_tdest_routing.decode_err_r0 ;
  wire [0:0]m_axis_tready;
  wire [1:0]s_axis_tdest;
  wire \s_axis_tdest[6] ;
  wire [0:0]s_axis_tready;
  wire [0:0]s_axis_tvalid;
  wire [0:0]s_decode_err;

  FDRE \gen_tdest_routing.busy_r_reg[0] 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.busy_ns ),
        .Q(\gen_tdest_routing.busy_r_reg[0]_0 ),
        .R(areset_r));
  LUT4 #(
    .INIT(16'h5040)) 
    \gen_tdest_routing.decode_err_r_i_1__2 
       (.I0(s_decode_err),
        .I1(s_axis_tdest[0]),
        .I2(s_axis_tvalid),
        .I3(s_axis_tdest[1]),
        .O(\gen_tdest_routing.decode_err_r0 ));
  FDRE \gen_tdest_routing.decode_err_r_reg 
       (.C(aclk),
        .CE(aclken),
        .D(\gen_tdest_routing.decode_err_r0 ),
        .Q(s_decode_err),
        .R(areset_r));
  LUT5 #(
    .INIT(32'hEEEAAAAA)) 
    \s_axis_tready[3]_INST_0 
       (.I0(s_decode_err),
        .I1(m_axis_tready),
        .I2(Q),
        .I3(arb_gnt_i),
        .I4(\s_axis_tdest[6] ),
        .O(s_axis_tready));
endmodule

(* ORIG_REF_NAME = "axis_switch_v1_1_15_axisc_transfer_mux" *) 
module axis_switch_0_axis_switch_v1_1_15_axisc_transfer_mux
   (Q,
    arb_gnt_i,
    SR,
    aclken,
    D,
    aclk);
  output [3:0]Q;
  input [0:0]arb_gnt_i;
  input [0:0]SR;
  input aclken;
  input [2:0]D;
  input aclk;

  wire [2:0]D;
  wire [3:0]Q;
  wire [0:0]SR;
  wire aclk;
  wire aclken;
  wire [0:0]arb_gnt_i;

  axis_switch_0_axis_switch_v1_1_15_axisc_arb_responder \gen_tdest_router.axisc_arb_responder 
       (.D(D),
        .Q(Q),
        .SR(SR),
        .aclk(aclk),
        .aclken(aclken),
        .arb_gnt_i(arb_gnt_i));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
