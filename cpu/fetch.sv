`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 04:35:22 PM
// Design Name: 
// Module Name: fetch
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


module fetch(input rst_n, clk, Branch, stall, input [31:0] target, output [31:0] imem_addr);
    wire [31:0] PC, PCPlus4, PC_Next;
    
    mux pc_mux(.a(PCPlus4), .b(target), .s(Branch), .c(PC_Next));
    adder pc_adder(.a(PC), .b(32'h00000004), .c(PCPlus4));
    pc pc(.clk(clk), .rst_n(rst_n), .stall(stall), .pc_next(PC_Next), .pc(PC));
    
    assign imem_addr = PC;

endmodule
