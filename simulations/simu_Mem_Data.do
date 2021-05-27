puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/Mem_Data.vhd
vcom -93 tb_Mem_Data.vhd

vsim tb_Mem_Data

add wave -hexa *
add wave -hexa /UUT/memoire(3)
run -a
