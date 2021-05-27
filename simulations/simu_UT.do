puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/UT.vhd
vcom -93 tb_UT.vhd

vsim tb_UT

add wave -hexa *
add wave -hexa /uut/c0/a
add wave -hexa /uut/c0/b
run -a
