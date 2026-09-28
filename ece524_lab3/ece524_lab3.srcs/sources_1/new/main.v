`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2026 04:26:43 PM
// Design Name: 
// Module Name: 
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

module ece524_lab3_top #(
    parameter integer CLK_FREQ_HZ = 100_000_000
) (
    input  wire       clk,
    input  wire [7:0] sw,
    input  wire [3:0] btn,
    output wire [7:0] led,
    output wire [6:0] ssd_seg,
    output wire       ssd_digit
);
    reg [7:0] address = 8'h00;
    reg       manual_override = 1'b0;
    reg       auto_increment = 1'b0;
    reg [31:0] seconds_counter = 32'h0;
    reg [15:0] scan_counter = 16'h0;

    reg [3:0] btn_meta = 4'h0;
    reg [3:0] btn_sync = 4'h0;
    reg [3:0] btn_sync_d = 4'h0;
    wire [3:0] btn_press = btn_sync & ~btn_sync_d;

    wire [7:0] memory_address = (manual_override || auto_increment) ? address : sw;
    wire [7:0] bram_data;
    wire [7:0] display_data = bram_data;

`ifdef XILINX_BRAM
    // Vivado's generated Block Memory Generator instance
    bram_256x8 bram (
        .clka(clk), .ena(1'b1), .wea(1'b0),
        .addra(memory_address), .dina(8'h00), .douta(bram_data)
    );
`else
    // Portable model used by the standalone testbench
    memory_256x8 bram (
        .addr(memory_address),
        .data(bram_data)
    );
`endif

    // Synchronize and edge-detect the mechanical button inputs
    always @(posedge clk) begin
        btn_meta   <= btn;
        btn_sync   <= btn_meta;
        btn_sync_d <= btn_sync;
    end

    always @(posedge clk)
        scan_counter <= scan_counter + 16'h0001;

    // BTN0: reset address
    // BTN1: increment once
    // BTN2/BTN3: auto mode
    always @(posedge clk) begin
        if (btn_press[0]) begin
            address         <= 8'h00;
            manual_override <= 1'b1;
            auto_increment  <= 1'b0;
            seconds_counter <= 32'h0;
        end else begin
            if (btn_press[1]) begin
                manual_override <= 1'b1;
                address <= address + 8'h01;
            end
            if (btn_press[2]) begin
                manual_override  <= 1'b1;
                auto_increment  <= 1'b1;
                seconds_counter <= 32'h0;
            end
            if (btn_press[3]) begin
                auto_increment  <= 1'b0;
                seconds_counter <= 32'h0;
            end

            if (auto_increment) begin
                if (seconds_counter == CLK_FREQ_HZ - 1) begin
                    seconds_counter <= 32'h0;
                    address <= address + 8'h01;
                end else begin
                    seconds_counter <= seconds_counter + 32'h1;
                end
            end else begin
                seconds_counter <= 32'h0;
            end
        end
    end

    assign led = display_data;

    // The PMOD SSD Segment order is {a,b,c,d,e,f,g}.
    function [6:0] hex_to_segments;
        input [3:0] value;
        begin
            case (value)
                4'h0: hex_to_segments = 7'b1111110;
                4'h1: hex_to_segments = 7'b0110000;
                4'h2: hex_to_segments = 7'b1101101;
                4'h3: hex_to_segments = 7'b1111001;
                4'h4: hex_to_segments = 7'b0110011;
                4'h5: hex_to_segments = 7'b1011011;
                4'h6: hex_to_segments = 7'b1011111;
                4'h7: hex_to_segments = 7'b1110000;
                4'h8: hex_to_segments = 7'b1111111;
                4'h9: hex_to_segments = 7'b1111011;
                4'hA: hex_to_segments = 7'b1110111;
                4'hB: hex_to_segments = 7'b0011111;
                4'hC: hex_to_segments = 7'b1001110;
                4'hD: hex_to_segments = 7'b0111101;
                4'hE: hex_to_segments = 7'b1001111;
                default: hex_to_segments = 7'b1000111;
            endcase
        end
    endfunction

    // Both digits are driven with the corresponding nibble.  The Pmod SSD has
    // a shared segment bus, so its C input selects the active digit.
    assign ssd_seg   = (scan_counter[15] == 1'b0) ?
                       hex_to_segments(display_data[3:0]) :
                       hex_to_segments(display_data[7:4]);
    assign ssd_digit = (scan_counter[15] == 1'b0) ? 1'b0 : 1'b1;
endmodule
