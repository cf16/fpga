gui_open_window Wave
gui_sg_create clk_125_tx_group
gui_list_add_group -id Wave.1 {clk_125_tx_group}
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.test_phase}
gui_set_radix -radix {ascii} -signals {clk_125_tx_tb.test_phase}
gui_sg_addsignal -group clk_125_tx_group {{Input_clocks}} -divider
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.CLK_IN1}
gui_sg_addsignal -group clk_125_tx_group {{Output_clocks}} -divider
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.dut.clk}
gui_list_expand -id Wave.1 clk_125_tx_tb.dut.clk
gui_sg_addsignal -group clk_125_tx_group {{Status_control}} -divider
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.RESET}
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.LOCKED}
gui_sg_addsignal -group clk_125_tx_group {{Counters}} -divider
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.COUNT}
gui_sg_addsignal -group clk_125_tx_group {clk_125_tx_tb.dut.counter}
gui_list_expand -id Wave.1 clk_125_tx_tb.dut.counter
gui_zoom -window Wave.1 -full
