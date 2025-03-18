`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 09:27:58 PM
// Design Name: 
// Module Name: imm_gen
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


module imm_gen
    (input [31:0] imem_insn, 
     output reg [31:0] imm_val);
     
     wire [6:0] i_type, lw, sw, lui, auipc, jal, jalr, beq;
     assign i_type = 7'b0010011;
     assign lw = 7'b0000011;
     assign sw = 7'b0100011;
     assign lui = 7'b0110111;
     assign auipc = 7'b0010111;
     assign jal = 7'b1101111;
     assign jalr = 7'b1100111;
     assign beq = 7'b1100011;
    
    always @(*) begin
        case(imem_insn[6:0])
            i_type:
                imm_val = {{20{imem_insn[31]}} , imem_insn[31:20]};    
            lw:
                imm_val = {{20{imem_insn[31]}}, imem_insn[31:20]};
            sw:
                imm_val = {{20{imem_insn[31]}}, imem_insn[31:25], imem_insn[11:7]};
            lui: 
                imm_val = imem_insn[31:12] << 12;
            auipc:
                imm_val = imem_insn[31:12] << 12;
            jal:
                imm_val = {{12{imem_insn[31]}}, imem_insn[19:12], imem_insn[20], imem_insn[30:21], 1'b0};
            jalr:
                imm_val = {{20{imem_insn[31]}}, imem_insn[31:20]};
            beq:
                imm_val = {{19{imem_insn[31]}}, imem_insn[7], imem_insn[30:25], imem_insn[11:8], 1'b0};
            default:
                imm_val = 32'h0;
        endcase
//        $display("immm %d, op: %0b, numl: %d, nums: %d", imm_val, imem_insn[6:0], {{20{imem_insn[31]}}, imem_insn[31:20]}, {{20{imem_insn[31]}}, imem_insn[31:25], imem_insn[11:7]});
    end

endmodule
