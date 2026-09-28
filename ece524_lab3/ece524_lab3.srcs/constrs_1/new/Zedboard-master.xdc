## ECE524 Lab 3
## Top-level ports: clk, sw[7:0], btn[3:0], led[7:0],
##                  ssd_seg[6:0], ssd_digit

## 100 MHz PL oscillator (GCLK)
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name sys_clk -period 10.000 -waveform {0.000 5.000} [get_ports clk]

## User DIP switches SW0..SW7
set_property PACKAGE_PIN F22 [get_ports {sw[0]}]
set_property PACKAGE_PIN G22 [get_ports {sw[1]}]
set_property PACKAGE_PIN H22 [get_ports {sw[2]}]
set_property PACKAGE_PIN F21 [get_ports {sw[3]}]
set_property PACKAGE_PIN H19 [get_ports {sw[4]}]
set_property PACKAGE_PIN H18 [get_ports {sw[5]}]
set_property PACKAGE_PIN H17 [get_ports {sw[6]}]
set_property PACKAGE_PIN M15 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[*]}]

## User push buttons:
## BTN0 = BTNC (reset address)
## BTN1 = BTND (increment address)
## BTN2 = BTNL (enable auto-increment)
## BTN3 = BTNR (disable auto-increment)
set_property PACKAGE_PIN P16 [get_ports {btn[0]}]
set_property PACKAGE_PIN R16 [get_ports {btn[1]}]
set_property PACKAGE_PIN N15 [get_ports {btn[2]}]
set_property PACKAGE_PIN R18 [get_ports {btn[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {btn[*]}]

## User LEDs LD0..LD7 BRAM data[7:0]
set_property PACKAGE_PIN T22 [get_ports {led[0]}]
set_property PACKAGE_PIN T21 [get_ports {led[1]}]
set_property PACKAGE_PIN U22 [get_ports {led[2]}]
set_property PACKAGE_PIN U21 [get_ports {led[3]}]
set_property PACKAGE_PIN V22 [get_ports {led[4]}]
set_property PACKAGE_PIN W22 [get_ports {led[5]}]
set_property PACKAGE_PIN U19 [get_ports {led[6]}]
set_property PACKAGE_PIN U14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# Pmod J1 ZedBoard JA pins 1-4
set_property PACKAGE_PIN Y11  [get_ports {ssd_seg[6]}] ;# A
set_property PACKAGE_PIN AA11 [get_ports {ssd_seg[5]}] ;# B
set_property PACKAGE_PIN Y10  [get_ports {ssd_seg[4]}] ;# C
set_property PACKAGE_PIN AA9  [get_ports {ssd_seg[3]}] ;# D

# Pmod J2 ZedBoard JB pins 1-4
set_property PACKAGE_PIN W12  [get_ports {ssd_seg[2]}] ;# E
set_property PACKAGE_PIN W11  [get_ports {ssd_seg[1]}] ;# F
set_property PACKAGE_PIN V10  [get_ports {ssd_seg[0]}] ;# G
set_property PACKAGE_PIN W8   [get_ports ssd_digit]

set_property IOSTANDARD LVCMOS33 [get_ports {ssd_seg[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports ssd_digit]
