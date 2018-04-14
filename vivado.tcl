
set project_name "arty_ntp_client"
set proj_dir "D:/FPGA/Xilinx/arty_ntp_client"


create_project ${project_name} ${proj_dir}/vivado -part xc7a35ticsg324-1L

add_files -fileset sim_1 [ glob ${proj_dir}/hdl/sim/*.vhd ] 

add_files -fileset constrs_1 ${proj_dir}/constraints/arty.xdc

add_files [ glob ${proj_dir}/hdl/*.vhd]
add_files [ glob ${proj_dir}/hdl/dxdisplay/*.vhd]
add_files [ glob ${proj_dir}/hdl/uart/*.vhd]

add_files ${proj_dir}/ip/clk_wiz_0/clk_wiz_0.xci
add_files ${proj_dir}/ip/axis_switch_0/axis_switch_0.xci
add_files ${proj_dir}/ip/fifo_2048x8/fifo_2048x8.xci
add_files ${proj_dir}/ip/fifo_2048x8_dv/fifo_2048x8_dv.xci
add_files ${proj_dir}/ip/fifo_2048x9/fifo_2048x9.xci
add_files ${proj_dir}/ip/fifo_2048x9_dv/fifo_2048x9_dv.xci

set_property target_language VHDL [current_project]
set_property top arty_ntp_client [current_fileset]


update_compile_order -fileset sources_1
update_compile_order -fileset sim_1


launch_runs synth_1 -jobs 4
wait_on_run synth_1

set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1 


