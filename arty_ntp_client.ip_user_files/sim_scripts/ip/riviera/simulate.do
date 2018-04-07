onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+fifo_2048x9 -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_2048x9 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {fifo_2048x9.udo}

run -all

endsim

quit -force
