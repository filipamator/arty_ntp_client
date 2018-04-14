vlib work
vlib unisim
vmap unisim D:/FPGA/Xilinx/libs/unisim
vlib fifo_generator_v13_2_1
vmap fifo_generator_v13_2_1 D:/FPGA/Xilinx/libs/fifo_generator_v13_2_1
vlib blk_mem_gen_v8_4_1
vmap blk_mem_gen_v8_4_1 D:/FPGA/Xilinx/libs/blk_mem_gen_v8_4_1
vlib xpm
vmap xpm D:/FPGA/Xilinx/libs/xpm



vcom -nopsl -2008 -work work ../hdl/ntp_pkg.vhd

vcom -nopsl -2008 -work work ../hdl/sim/mii_terminal.vhd
vcom -nopsl -2008 -work work ../hdl/sim/arty_ntp_client_tb.vhd
vcom -nopsl -2008 -work work ../hdl/sim/mii_logger.vhd
#vcom -work work ../hdl/sim/nibble2byte.vhd
vcom -work work ../hdl/sim/axis_master.vhd

vcom -nopsl -2008 -work work ../hdl/arty_ntp_client.vhd
vcom -nopsl -2008 -work work ../hdl/add_crc32.vhd
vcom -nopsl -2008 -work work ../hdl/add_preamble.vhd
#vcom -nopsl -2008 -work work hdl/blk_mem_gen_3.vhd
vcom -nopsl -2008 -work work ../hdl/resetgen.vhd
vcom -nopsl -2008 -work work ../hdl/packet_decoder.vhd
vcom -nopsl -2008 -work work ../hdl/ipv4_decoder.vhd
vcom -nopsl -2008 -work work ../hdl/arp_decoder.vhd
vcom -work work -2008 ../hdl/axis_eth.vhd

vcom -work work ../hdl/axis_arbiter.vhd
vcom -work work ../hdl/axis_ntp.vhd
vcom -work work ../hdl/dxdisplay/display_top.vhd
vcom -work work ../hdl/dxdisplay/dx_display.vhd
vcom -work work ../hdl/dxdisplay/dx_display_xmit.vhd
vcom -work work ../hdl/ntp_client.vhd
vcom -work work ../hdl/main_clock.vhd
vcom -work work ../hdl/dxdisplay/display_top_tb.vhd

vcom -work work -2008 ../hdl/uart/uartdump.vhd
vcom -work work -2008 ../hdl/uart/uartdump_nbl.vhd
vcom -work work ../hdl/uart/UART_TX.vhd
vcom -work work ../hdl/uart/UART_RX.vhd
vcom -work work ../hdl/uart/uart_mux.vhd



vlog -nopsl -work work ../ip/axis_switch_0/hdl/axis_switch_v1_1_vl_rfs.v
vlog -nopsl -work work ../ip/axis_switch_0/hdl/axis_infrastructure_v1_1_vl_rfs.v
vlog -nopsl -work work ../ip/axis_switch_0/hdl/axis_register_slice_v1_1_vl_rfs.v
vlog -nopsl -work work ../ip/axis_switch_0/synth/axis_switch_0.v
vcom -nopsl -2008 -work work ../ip/fifo_2048x8/synth/fifo_2048x8.vhd
vcom -nopsl -2008 -work work ../ip/fifo_2048x9/synth/fifo_2048x9.vhd
vcom -nopsl -2008 -work work ../ip/fifo_2048x8_dv/synth/fifo_2048x8_dv.vhd
vcom -nopsl -2008 -work work ../ip/fifo_2048x9_dv/synth/fifo_2048x9_dv.vhd
vcom  -nopsl -2008 -work work  ../ip/clk_wiz_0/clk_wiz_0_sim_netlist.vhdl

vsim work.arty_ntp_client_tb
