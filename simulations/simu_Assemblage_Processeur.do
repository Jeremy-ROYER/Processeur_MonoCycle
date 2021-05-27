puts "Simulation script for ModelSim "

vlib work
vcom -93 ../src/Assemblage_Processeur.vhd
vcom -93 tb_Assemblage_Processeur.vhd

vsim tb_Processeur

add wave -decimal /uut/unite_traitement/data_memory/memoire(38)
add wave -decimal /uut/unite_traitement/data_memory/memoire(37)
add wave -decimal /uut/unite_traitement/data_memory/memoire(36)
add wave -decimal /uut/unite_traitement/data_memory/memoire(35)
add wave -decimal /uut/unite_traitement/data_memory/memoire(34)
add wave -decimal /uut/unite_traitement/data_memory/memoire(33)
add wave -decimal /uut/unite_traitement/data_memory/memoire(32)
add wave -hexa *
add wave -decimal /uut/unite_traitement/reg16_32/banc

run -a