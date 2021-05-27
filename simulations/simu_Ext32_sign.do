puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/Mux2_1.vhd
vcom -93 tb_Ext32_sign.vhd

vsim tb_Ext32_Sign

add wave -decimal *
add wave -hexa /uut/extension
run -a
