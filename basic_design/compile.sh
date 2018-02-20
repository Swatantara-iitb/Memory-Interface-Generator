ghdl -a ahir_system.vhd bridge.vhd top.vhd tb_top.vhd
ghdl -e tb_top
ghdl -r tb_top --vcd=top.vcd --stop-time=150ns
