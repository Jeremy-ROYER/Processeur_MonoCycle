puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/Assemblage_UT.vhd
vcom -93 tb_Assemblage_UT.vhd

vsim tb_Assemblage_UT

add wave /clk
add wave /reset

add wave /ualsrc
add wave /wrsrc
add wave /regwr
add wave /memwr

add wave -unsigned /rn
add wave -unsigned /rd
add wave -unsigned /rd_m
add wave -decimal /imm
add wave -decimal /testbusw
add wave /flag(31)

add wave -decimal /uut/busa
add wave -decimal /uut/busb
add wave -decimal /uut/muxregout

add wave -decimal /uut/data_memory/memoire(35)

run -a
