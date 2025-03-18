`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 12:41:34 PM
// Design Name: 
// Module Name: write_back
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


module write_back
    (input rst_n, clk, MemtoReg,
     input [1:0] mem_wb_rw,
     input [31:0] read_data, mem_wb_ALU_result, mem_wb_imm, mem_wb_pc_plus_imm, mem_wb_pc_plus_4, 
     output [31:0] write_data);
     
     reg [31:0] mem_or_alu_result;
     
     mux mem_or_alu(.s(MemtoReg), .a(mem_wb_ALU_result), .b(read_data), .c(mem_or_alu_result));
     mux_4_1 write_back_mux (.s(mem_wb_rw), .a(mem_or_alu_result), .b(mem_wb_pc_plus_4), .c(mem_wb_imm), .d(mem_wb_pc_plus_imm), .e(write_data));
     
endmodule
