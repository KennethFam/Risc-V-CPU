`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 08:18:21 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit
    (input [2:0] Funct3,
     input [6:0] opcode, 
     output ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, us, Jump_Return, 
     output [1:0] ALUOp, rw,
     output [3:0] id_ex_byte_en_d);
     
     wire [6:0] r_type, lw, sw, beq, i_type, lui, auipc, jal, jalr;
     assign r_type = 7'b0110011;
     assign lw = 7'b0000011;
     assign sw = 7'b0100011;
     assign beq = 7'b1100011;
     assign i_type = 7'b0010011;
     assign lui = 7'b0110111;
     assign auipc = 7'b0010111;
     assign jal = 7'b1101111;
     assign jalr = 7'b1100111;
     
     assign ALUSrc = (opcode == lw || opcode == sw || opcode == i_type || opcode == jalr);
     assign MemtoReg = (opcode == lw);
     assign RegWrite = (opcode == r_type || opcode == lw || opcode == i_type || opcode == lui || opcode == auipc || opcode ==  jalr || opcode == jal);
     assign MemRead = (opcode == lw);
     assign MemWrite = (opcode == sw);
     assign Branch = (opcode == beq || opcode == jal);
     assign Jump_Return = (opcode == jalr);
     assign us = (Funct3 == 3'b100 || Funct3 == 3'b101) ? 1'b1 : 1'b0;
     assign ALUOp[1] = (opcode == r_type || opcode == i_type || opcode == lui || opcode == jal);
     assign ALUOp[0] = (opcode == beq || opcode == lui || opcode == jal);
     assign id_ex_byte_en_d = (Funct3 == 3'b000 || Funct3 == 3'b100) ? 4'b0001 : (Funct3 == 3'b001 || Funct3 == 3'b101) ? 4'b0011 : 4'b1111;
     assign rw[1] = (opcode == lui || opcode == auipc);
     assign rw[0] = (opcode == auipc || opcode == jal || opcode == jalr);
     
endmodule
