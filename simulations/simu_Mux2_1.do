puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/Mux2_1.vhd
vcom -93 tb_Mux2_1.vhd

vsim tb_Mux2_1

add wave -decimal *
run -a
