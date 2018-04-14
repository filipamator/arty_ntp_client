-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Fri Apr 13 20:32:24 2018
-- Host        : PONIAK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub D:/FPGA/Xilinx/arty_ntp_client/ip/axis_switch_0/axis_switch_0_stub.vhdl
-- Design      : axis_switch_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35ticsg324-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axis_switch_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tready : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_tlast : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    m_axis_tdest : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_req_suppress : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_decode_err : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );

end axis_switch_0;

architecture stub of axis_switch_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axis_tvalid[3:0],s_axis_tready[3:0],s_axis_tdata[31:0],s_axis_tlast[3:0],s_axis_tdest[7:0],m_axis_tvalid[0:0],m_axis_tready[0:0],m_axis_tdata[7:0],m_axis_tlast[0:0],m_axis_tdest[1:0],s_req_suppress[3:0],s_decode_err[3:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "axis_switch_v1_1_15_axis_switch,Vivado 2017.4";
begin
end;
