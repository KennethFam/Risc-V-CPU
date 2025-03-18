`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 03:36:38 PM
// Design Name: 
// Module Name: forward_unit
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


module forward_unit
    (input ex_mem_RegWrite, mem_wb_RegWrite,
     input [4:0] rs1, rs2, ex_mem_rd, mem_wb_rd,
     output [1:0] forwardA, forwardB);
     
    //think of these as if and else-if statements
    assign forwardA = ((ex_mem_RegWrite) && (ex_mem_rd != 0) && (ex_mem_rd == rs1)) ? 2'b10 :
                   ((mem_wb_RegWrite) && (mem_wb_rd != 0) && (mem_wb_rd == rs1)) ? 2'b01 : 2'b00;
    
    assign forwardB = ((ex_mem_RegWrite) && (ex_mem_rd != 0) && (ex_mem_rd == rs2)) ? 2'b10 :
                   ((mem_wb_RegWrite) && (mem_wb_rd != 0) && (mem_wb_rd == rs2)) ? 2'b01 : 2'b00;
    
    //$display("ex_mem_RegWrite: %0h | mem_wb_RegWrite: %0h | rs1: %0h | rs2: %0h | ex_mem_rd: %0h | mem_wb_rd: %0h", ex_mem_RegWrite, mem_wb_RegWrite, rs1, rs2, ex_mem_rd, mem_wb_rd);
     
endmodule
