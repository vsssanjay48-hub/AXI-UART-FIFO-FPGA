##clock
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

set_property PACKAGE_PIN P16 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property PACKAGE_PIN T18 [get_ports wi_en]
set_property IOSTANDARD LVCMOS33 [get_ports wi_en]

set_property PACKAGE_PIN F22 [get_ports {data_in[0]}]
set_property PACKAGE_PIN G22 [get_ports {data_in[1]}]
set_property PACKAGE_PIN H22 [get_ports {data_in[2]}]
set_property PACKAGE_PIN F21 [get_ports {data_in[3]}]
set_property PACKAGE_PIN H19 [get_ports {data_in[4]}]
set_property PACKAGE_PIN H18 [get_ports {data_in[5]}]
set_property PACKAGE_PIN H17 [get_ports {data_in[6]}]
set_property PACKAGE_PIN M15 [get_ports {data_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in[*]}]

set_property PACKAGE_PIN T22 [get_ports full]
set_property IOSTANDARD LVCMOS33 [get_ports full]

set_property PACKAGE_PIN T21 [get_ports empty]
set_property IOSTANDARD LVCMOS33 [get_ports empty]

set_property PACKAGE_PIN U21 [get_ports tx_out]
set_property IOSTANDARD LVCMOS33 [get_ports tx_out]

set_property PACKAGE_PIN U22 [get_ports tx_busy_led]
set_property IOSTANDARD LVCMOS33 [get_ports tx_busy_led]










