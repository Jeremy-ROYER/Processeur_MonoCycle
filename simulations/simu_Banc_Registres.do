puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/Banc_Registres.vhd
vcom -93 tb_Banc_Registres.vhd

vsim tb_Banc_Reg

add wave -decimal *
add wave -decimal /tb_Banc_Reg/UUT/banc
run -a
