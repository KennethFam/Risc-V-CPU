`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 10:22:17 PM
// Design Name: 
// Module Name: alu_control
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


module alu_control
    (input[1:0] ALUOp, 
     input [2:0] Funct3, 
     input [6:0] Funct7, 
     output [3:0] op);
     
    assign op[0] =  ((ALUOp==2'b10) && (Funct3==3'b110)) || // r/i-or
                    ((ALUOp==2'b10) && (Funct3==3'b100)) || // r/i-xor
                    ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0000000)) || // r/i->>
                    ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0100000)) || // r/i->>>
                    ((ALUOp==2'b01) && (Funct3==3'b001)) || // bne
                    ((ALUOp==2'b01) && (Funct3==3'B101)) || // bge
                    ((ALUOp==2'b01) && (Funct3==3'b111));   // bgeu
    
    assign op[1] =  (ALUOp==2'b00) ||   // sw/auipc/jalr-add
                    ((ALUOp==2'b10) && (Funct3==3'b000)) || // r/i-add
                    ((ALUOp==2'b10) && (Funct3==3'b100)) || // R\I-xor
                    ((ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b000)) ||  // r-sub
                    ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0100000)) || // r/i->>>
                    (ALUOp==2'b11) ||   // jal/lui: return 1
                    ((ALUOp==2'b10) && (Funct3==3'b011)) || // sltiu, sltu: <u
                    ((ALUOp==2'b01) && (Funct3==3'b110)) || // bltu
                    ((ALUOp==2'b01) && (Funct3==3'b111));   // bgeu
    
    assign op[2] =  ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0000000)) || // r/i->>
                    ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0100000)) || // r/i->>>
                    ((ALUOp==2'b10) && (Funct3==3'b001)) || // r/i-<<
                    ((ALUOp==2'b10) && (Funct7==7'b0100000) && (Funct3==3'b000)) ||  // r-sub
                    ((ALUOp==2'b10) && (Funct3==3'b010)) || // r/i-<
                    ((ALUOp==2'b10) && (Funct3==3'b011)) || // sltiu, sltu: <u
                    ((ALUOp==2'b01) && (Funct3==3'b110)) || // bltu
                    ((ALUOp==2'b01) && (Funct3==3'b100)) || // blt
                    ((ALUOp==2'b01) && (Funct3==3'B101)) || // bge
                    ((ALUOp==2'b01) && (Funct3==3'b111));   // bgeu
    
    assign op[3]=   (ALUOp==2'b01) || // bne, beq, blt, bge, bltu, bgeu
                    (ALUOp==2'b11) ||   // jal/lui: return 1
                    ((ALUOp==2'b10) && (Funct3==3'b010)) || // r/i-<
                    ((ALUOp==2'b10) && (Funct3==3'b011));   // sltiu, sltu: <u

endmodule
