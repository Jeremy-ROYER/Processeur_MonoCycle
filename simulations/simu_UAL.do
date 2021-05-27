puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/UAL.vhd
vcom -93 tb_UAL.vhd

vsim tb_UAL

add wave -decimal *
run -a
