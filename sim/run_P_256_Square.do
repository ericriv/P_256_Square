# ================================
# SPI Master Simulation Run Script (run.do)
# Run from the sim/ directory
# ================================

# Clean and recreate work directory
#vdel -all
vlib work

# Compile RTL, assertions, and testbench
vlog -sv ../rtl/P_256_Square.v
vlog -sv ../rtl/P_256_Reducer.v
vlog -sv ../rtl/Rad4_mul_256.v
vlog -sv ../rtl/CSA.v
vlog -sv ../rtl/CPA.v
vlog -sv ../rtl/FA.v
vlog -sv ../rtl/CLA256.v
vlog -sv ../rtl/CLA64.v
vlog -sv ../rtl/CLA16.v
vlog -sv ../rtl/CLA4.v
vlog -sv ../rtl/GPFA.v
vlog -sv ../rtl/CLA_generator4.v
vlog -sv ../tb/P_256_Square_tb.sv

# Run simulation (with limited optimization for waveform viewing)
vsim -voptargs=+acc work.P_256_Square_tb 

# Record sim log
transcript file sim_output.log

# Plot waveform
add wave -r P_256_Square_tb/*

# Run until completion
run -all

#quit -sim
