`timescale 1ns/1ps

// Simulation/synthesis model of the 256 x 8 memory used by the lab.
// The Vivado project-generation script also creates the equivalent
// Block Memory Generator IP and initializes it with memory_init.coe.
module memory_256x8 (
    input  wire [7:0] addr,
    output wire [7:0] data
);
    reg [7:0] mem [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 8'h00;
        mem[8'h00] = 8'h01;
        mem[8'h01] = 8'h02;
        mem[8'h02] = 8'h03;
        mem[8'h03] = 8'h04;
        mem[8'h04] = 8'h05;
        mem[8'h05] = 8'h0A;
        mem[8'h06] = 8'h0F;
        mem[8'h07] = 8'h10;
        mem[8'h08] = 8'h1A;
        mem[8'h09] = 8'h1F;
        mem[8'h0A] = 8'h2B;
        mem[8'h0B] = 8'h2C;
        mem[8'h0C] = 8'h3D;
        mem[8'h0D] = 8'h4E;
        mem[8'h0E] = 8'h5F;
        mem[8'h0F] = 8'h6A;
    end

    assign data = mem[addr];
endmodule
