`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 10:04:34 PM
// Design Name: 
// Module Name: execute
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


module execute
    (input rst_n, clk, Branch, ALUSrc, id_ex_RegWrite, id_ex_MemtoReg, id_ex_us, id_ex_MemRead, id_ex_MemWrite, id_ex_Jump_Return,
     input [1:0] ALUOp, forwardA_ex, forwardB_ex, id_ex_rw,
     input [3:0] ctl, id_ex_byte_en,
     input [4:0] id_ex_rd,
     input[31:0] rd1, rd2, imm_val, imem_addr, wb_result, mem_wb_MemtoReg, pc_d,
     output Zero, ex_mem_RegWrite, ex_mem_MemtoReg, ex_mem_us, ex_mem_MemRead, ex_mem_MemWrite, branch_jump_stall,
     output [1:0] ex_mem_rw,
     output [3:0] ex_mem_byte_en,
     output [4:0] ex_mem_rd,
     output [31:0] ALU_result, target, ex_mem_rd2, ex_mem_imm, pc_plus_imm, pc_plus_4);
     
     wire Zero_e;
     wire [31:0] operand, ALU_result_e, a_src, b_src, pc_plus_imm_e, pc_plus_4_e;
     
     reg ex_mem_RegWrite_reg, Zero_reg, ex_mem_MemtoReg_reg, ex_mem_us_reg, ex_mem_MemRead_reg, ex_mem_MemWrite_reg;
     reg [1:0] ex_mem_rw_reg;
     reg [3:0] ex_mem_byte_en_reg;
     reg [4:0] ex_mem_rd_reg;
     reg[31:0] ALU_result_reg, ex_mem_rd2_reg, ex_mem_imm_reg, pc_plus_imm_reg, pc_plus_4_reg;
     
     mux4_1 a_mux
    (.s(forwardA_ex),
     .a(rd1), .b(wb_result), .c(ALU_result),
     .d(a_src));
     
     mux4_1 b_mux
    (.s(forwardB_ex),
     .a(rd2), .b(wb_result), .c(ALU_result),
     .d(b_src));
     
     mux alu_mux(.s(ALUSrc), .a(b_src), .b(imm_val), .c(operand));
     
     alu alu
    (.ctl(ctl), 
     .a(a_src), .b(operand), 
     .Zero(Zero_e), 
     .ALU_result(ALU_result_e));
     
     branch_jump_unit branching_unit
    (.branch(Branch), .jalr(id_ex_Jump_Return),
     .pc_d(pc_d), .imm_val(imm_val), .alu_result(ALU_result_e),
     .branch_jump_stall(branch_jump_stall),
     .pc_plus_imm(pc_plus_imm_e), .pc_plus_4(pc_plus_4_e), .pc_branch(target));
     
     always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            Zero_reg <= 1'b0;
            ex_mem_RegWrite_reg <= 1'b0;
            ex_mem_MemtoReg_reg <= 1'b0;
            ex_mem_us_reg <= 1'b0;
            ex_mem_MemRead_reg <= 1'b0;
            ex_mem_MemWrite_reg <= 1'b0;
            ex_mem_rw_reg <= 2'b00;
            ex_mem_byte_en_reg <= 4'b0000;
            ex_mem_rd_reg <= 5'b00000;
            ALU_result_reg <= 32'd0;
            ex_mem_rd2_reg <= 32'd0;
            ex_mem_imm_reg <= 32'd0;
            pc_plus_imm_reg <= 32'd0;
            pc_plus_4_reg <= 32'd0;
        end
        else begin
            Zero_reg <= Zero_e;
            ex_mem_RegWrite_reg <= id_ex_RegWrite;
            ex_mem_MemtoReg_reg <= id_ex_MemtoReg;
            ex_mem_us_reg <= id_ex_us;
            ex_mem_MemRead_reg <= id_ex_MemRead;
            ex_mem_MemWrite_reg <= id_ex_MemWrite;
//            branch_jump_stall_reg <= branch_jump_stall_e;
            ex_mem_rw_reg <= id_ex_rw;
            ex_mem_byte_en_reg <= id_ex_byte_en;
            ex_mem_rd_reg <= id_ex_rd;
            ALU_result_reg <= ALU_result_e;
//            target_reg <= target_e;
            ex_mem_rd2_reg <= b_src;
            ex_mem_imm_reg <= imm_val;
            pc_plus_imm_reg <= pc_plus_imm_e;
            pc_plus_4_reg <= pc_plus_4_e;
            $display("execute: pc: %0h, imm val: %0h, branch stall: %b, target: %0h", pc_d, imm_val, branch_jump_stall, target);
//            $display("execute cycle: MemWrite: %0h", ex_mem_MemWrite_reg);
//            $display("execute cycle: RegWrite: %0h", ex_mem_RegWrite);
//            $display("a_mux result: %h, fowarda: %0h, wd: %0h, ALU_result: %0h\n", rd1, forwardA_ex, wb_result, ALU_result);
        end
     end
     
     assign ALU_result = (ex_mem_rw == 2'b10) ? ex_mem_imm : (ex_mem_rw == 2'b11) ? pc_plus_imm : ALU_result_reg;
     assign ex_mem_us = ex_mem_us_reg;
     assign ex_mem_MemRead = ex_mem_MemRead_reg;
     assign ex_mem_MemWrite = ex_mem_MemWrite_reg;
     assign ex_mem_rw = ex_mem_rw_reg;
     assign ex_mem_byte_en = ex_mem_byte_en_reg;
     assign ex_mem_rd = ex_mem_rd_reg;
     assign ex_mem_MemtoReg = ex_mem_MemtoReg_reg;
     assign Zero = Zero_reg;
     assign ex_mem_RegWrite = ex_mem_RegWrite_reg;
     assign ex_mem_rd2 = ex_mem_rd2_reg;
     assign ex_mem_imm = ex_mem_imm_reg;
     assign pc_plus_imm = pc_plus_imm_reg;
     assign pc_plus_4 = pc_plus_4_reg;
     
endmodule
