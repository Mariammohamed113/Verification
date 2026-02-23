vlib work
vlog -f src_files.list -mfcu +cover -covercells
vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all
add wave /top/fif/*
coverage save top.ucdb -onexit
coverage exclude -src FIFO.svh -line 22 -code c
coverage exclude -src FIFO.svh -line 40 -code c
run -all
