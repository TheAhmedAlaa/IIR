vlib work
vlog iir.v iir_tb.v
vsim -voptargs=+acc work.iir_tb
add wave *
add wave -r sim:/iir/DUT/*
run -all
#quit -sim