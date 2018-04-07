onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_2048x9_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_2048x9.udo}

run -all

quit -force
