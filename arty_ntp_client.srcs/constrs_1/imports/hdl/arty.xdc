# Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK100MHZ]


create_clock -period 40.000 -name eth_rx_clk -waveform {0.000 20.000} [get_ports eth_rx_clk]
create_clock -period 40.000 -name eth_tx_clk -waveform {0.000 20.000} [get_ports eth_tx_clk]


# Switches - used to set packet speed.
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {switches[0]}]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {switches[1]}]
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports {switches[2]}]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {switches[3]}]

##SMSC Ethernet PHY
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports eth_col]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports eth_crs]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports eth_mdc]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports eth_mdio]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports eth_ref_clk]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports eth_rstn]
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports eth_rx_clk]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports eth_rx_dv]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {eth_rx_d[0]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {eth_rx_d[1]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {eth_rx_d[2]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {eth_rx_d[3]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports eth_rx_err]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports eth_tx_clk]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports eth_tx_en]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {eth_tx_d[0]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {eth_tx_d[1]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {eth_tx_d[2]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {eth_tx_d[3]}]


set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports led4]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports led5]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports led6]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports led7]


##Pmod Header JA

set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports PMODA_1]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports PMODA_2]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports PMODA_3]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports PMODA_4]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports PMODA_7]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports PMODA_8]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports PMODA_9]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports PMODA_10]


##Pmod Header JB

#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L12P_T1_MRCC_15 Sch=jb[1]
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L12N_T1_MRCC_15 Sch=jb[2]
#set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L22N_T3_A16_15 Sch=jb[3]
#set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L23P_T3_FOE_B_15 Sch=jb[4]
#set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L23N_T3_FWE_B_15 Sch=jb[7]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { jb[8] }]; #IO_L24P_T3_RS1_15 Sch=jb[8]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { jb[9] }]; #IO_L24N_T3_RS0_15 Sch=jb[9]
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { jb[10] }]; #IO_25_15 Sch=jb[10]


##Pmod Header JC

#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { jc[1] }]; #IO_L20P_T3_A08_D24_14 Sch=jc[1]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { jc[2] }]; #IO_L20N_T3_A07_D23_14 Sch=jc[2]
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { jc[3] }]; #IO_L21P_T3_DQS_14 Sch=jc[3]
#set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { jc[4] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=jc[4]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { jc[7] }]; #IO_L22P_T3_A05_D21_14 Sch=jc[7]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { jc[8] }]; #IO_L22N_T3_A04_D20_14 Sch=jc[8]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { jc[9] }]; #IO_L23P_T3_A03_D19_14 Sch=jc[9]
#set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { jc[10] }]; #IO_L23N_T3_A02_D18_14 Sch=jc[10]


##Pmod Header JD

#set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { jd[1] }]; #IO_L11N_T1_SRCC_35 Sch=jd[1]
#set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { jd[2] }]; #IO_L12N_T1_MRCC_35 Sch=jd[2]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { jd[3] }]; #IO_L13P_T2_MRCC_35 Sch=jd[3]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { jd[4] }]; #IO_L13N_T2_MRCC_35 Sch=jd[4]
#set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { jd[7] }]; #IO_L14P_T2_SRCC_35 Sch=jd[7]
#set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { jd[8] }]; #IO_L14N_T2_SRCC_35 Sch=jd[8]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { jd[9] }]; #IO_L15P_T2_DQS_35 Sch=jd[9]
#set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { jd[10] }]; #IO_L15N_T2_DQS_35 Sch=jd[10]


#USB-UART Interface

set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports UART_RXD]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports UART_TXD]



