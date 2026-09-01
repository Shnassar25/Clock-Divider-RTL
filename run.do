vlib work
vlog *.v
vsim -voptargs=+acc work.tb_Clk_div
do wave.do
run -all