puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/UG_instruct.vhd
vcom -93 tb_UG_instruct.vhd

vsim tb_UG_instruct

add wave -hexa *
run -a
