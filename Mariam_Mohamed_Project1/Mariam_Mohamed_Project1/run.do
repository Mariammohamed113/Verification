vlib work
vlog FIFO.sv package1.sv package2.sv package3.sv shared_package.sv testbench.sv MONITOR.sv interface.sv TOP.sv  +cover -covercells
vsim -voptargs=+acc work.TOP -cover 
add wave *
coverage exclude -src package3.sv -line 41 -code b
coverage exclude -src package3.sv -line 42 -code s
coverage exclude -src package3.sv -line 43 -code s
coverage exclude -src package3.sv -line 37 -code c
coverage save testbench.ucdb -onexit 
run -all