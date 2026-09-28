`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2026 04:28:48 PM
// Design Name: 
// Module Name: ece524_lab3_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ece524_lab3_tb;
    reg clk = 1'b0;
    reg [7:0] sw = 8'h00;
    reg [3:0] btn = 4'h0;
    wire [7:0] led;
    wire [6:0] ssd_seg;
    wire ssd_digit;

    // Four clock cycles represent one simulated second.
    ece524_lab3_top #(.CLK_FREQ_HZ(4)) dut (
        .clk(clk), .sw(sw), .btn(btn), .led(led),
        .ssd_seg(ssd_seg), .ssd_digit(ssd_digit)
    );

    always #5 clk = ~clk;

    task press_button;
        input integer number;
        begin
            @(negedge clk); btn[number] = 1'b1;
            @(negedge clk); btn[number] = 1'b0;
            repeat (3) @(negedge clk);
        end
    endtask

    task check_value;
        input [7:0] expected;
        begin
            #1;
            if (led !== expected) begin
                $display("FAIL: expected %02h, got %02h at address %02h", expected, led, dut.address);
                $fatal(1);
            end
            $display("PASS: address %02h -> data %02h", dut.address, led);
        end
    endtask

    initial begin
        repeat (2) @(negedge clk);
        sw = 8'h0A;
        check_value(8'h2B);

        press_button(0);
        check_value(8'h01);

        press_button(1);
        check_value(8'h02);
        press_button(1);
        check_value(8'h03);

        press_button(0);
        check_value(8'h01);

        press_button(2);
        repeat (5) @(negedge clk);
        check_value(8'h02);
        press_button(3);
        $display("All ECE524 Lab 3 tests passed.");
        $finish;
    end
endmodule
