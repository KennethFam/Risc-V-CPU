`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 07:15:15 PM
// Design Name: 
// Module Name: decode
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


module decode
    (input rst_n, clk, stall, mem_wb_RegWrite, branch_jump_stall,
     input [4:0] mem_wb_rd,
     input [31:0] imem_insn, wd, imem_addr,
     output ALUSrc, MemtoReg, MemRead, MemWrite, Branch, id_ex_RegWrite, id_ex_us, id_ex_Jump_Return,
     output [1:0] ALUOp, id_ex_rw,
     output [3:0] ALUCtl, id_ex_byte_en,
     output [4:0] rs1, rs2, id_ex_rd,
     output [31:0] rd1, rd2, imm_val, pc_d);
     
    wire ALUSrcD, MemtoRegD, RegWriteD, MemReadD, MemWriteD, BranchD, usD, id_ex_Jump_Return_d;
    wire [1:0] ALUOpD, id_ex_rw_d;
    wire [3:0] ctl, id_ex_byte_en_d;
    wire [31:0] rd1_d, rd2_d, imm_valD;
    
    reg ALUSrc_reg, MemtoReg_reg, MemRead_reg, MemWrite_reg, Branch_reg, RegWrite_reg, us_reg, id_ex_Jump_Return_reg;
    reg [1:0] ALUOp_reg, id_ex_rw_reg;
    reg [3:0] ctl_reg, id_ex_byte_en_reg;
    reg [4:0] rs1_reg, rs2_reg, id_ex_rd_reg;
    reg [31:0] rd1_reg, rd2_reg, imm_val_reg, imem_addr_reg;

    register_file rf
        (.rst_n(rst_n), .clk(clk), .RegWrite(mem_wb_RegWrite), 
         .rr1(imem_insn[19:15]), .rr2(imem_insn[24:20]), .wr(mem_wb_rd), 
         .wd(wd), 
         .rd1(rd1_d), .rd2(rd2_d));
    
    control_unit cu
    (.Funct3(imem_insn[14:12]),
     .opcode(imem_insn[6:0]), 
     .ALUSrc(ALUSrcD), .MemtoReg(MemtoRegD), .RegWrite(RegWriteD), .MemRead(MemReadD), .MemWrite(MemWriteD), .Branch(BranchD), .us(usD), .Jump_Return(id_ex_Jump_Return_d), 
     .ALUOp(ALUOpD), .rw(id_ex_rw_d),
     .id_ex_byte_en_d(id_ex_byte_en_d));
     
    alu_control alu_control
    (.ALUOp(ALUOpD), 
     .Funct3(imem_insn[14:12]), 
     .Funct7(imem_insn[31:25]), 
     .op(ctl));
     
    imm_gen imm_gen_module
    (.imem_insn(imem_insn), 
     .imm_val(imm_valD));
     
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n || stall || branch_jump_stall) begin
            ALUSrc_reg <= 1'b0;
            MemtoReg_reg <= 1'b0;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b0;
            Branch_reg <= 1'b0;
            RegWrite_reg <= 1'b0;
            us_reg <= 1'b0;
            id_ex_Jump_Return_reg <= 1'b0;
            ALUOp_reg <= 2'b00;
            id_ex_rw_reg <= 2'b00;
            ctl_reg <= 4'b0000;
            id_ex_byte_en_reg <= 4'b0000;
            rs1_reg <= 5'b00000;
            rs2_reg <= 5'b00000;
            id_ex_rd_reg <= 5'b00000;
            rd1_reg <= 32'h00000000;
            rd2_reg <= 32'h00000000;
            imm_val_reg <= 32'h00000000;
            imem_addr_reg <= 32'd0;
        end
        else begin
            ALUSrc_reg <= ALUSrcD;
            MemtoReg_reg <= MemtoRegD;
            MemRead_reg <= MemReadD;
            MemWrite_reg <= MemWriteD;
            Branch_reg <= BranchD;
            RegWrite_reg <= RegWriteD;
            us_reg <= usD;
            id_ex_Jump_Return_reg <= id_ex_Jump_Return_d;
            ALUOp_reg <= ALUOpD;
            id_ex_rw_reg <= id_ex_rw_d;
            ctl_reg <= ctl;
            id_ex_byte_en_reg <= id_ex_byte_en_d;
            rs1_reg <= imem_insn[19:15];
            rs2_reg <= imem_insn[24:20];
            id_ex_rd_reg <= imem_insn[11:7];
            rd1_reg <= rd1_d;
            rd2_reg <= rd2_d;
            imm_val_reg <= imm_valD;
            imem_addr_reg <= imem_addr;
//            $display("decode cycle: imm: %d, rw: %b", imm_val, id_ex_rw);
//            $display("Decode cycle: Funct3: %0h, byte_en: %0h, us: %0b", imem_insn[14:12], id_ex_byte_en_d, usD);
//            $display("Decode cycle: RegWrite: %0h", id_ex_RegWrite);
//            $display("ins: %0h, rr1: %0h, imm: %0h, rd: %0h, wd: %0h\n", imem_insn, imem_insn[19:15], imm_valD, reg_addr, wd);
//            $display("%0h", rd1_d);
        end
    end
    
    assign ALUSrc = ALUSrc_reg;
    assign MemtoReg = MemtoReg_reg;
    assign MemRead = MemRead_reg;
    assign MemWrite = MemWrite_reg;
    assign Branch = Branch_reg;
    assign id_ex_RegWrite = RegWrite_reg;
    assign id_ex_us = us_reg;
    assign id_ex_Jump_Return = id_ex_Jump_Return_reg;
    assign ALUOp = ALUOp_reg;
    assign id_ex_rw = id_ex_rw_reg;
    assign ALUCtl = ctl_reg;
    assign id_ex_byte_en = id_ex_byte_en_reg;
    assign rs1 = rs1_reg;
    assign rs2 = rs2_reg;
    assign rd1 = rd1_reg;
    assign rd2 = rd2_reg;
    assign id_ex_rd = id_ex_rd_reg;
    assign imm_val = imm_val_reg;
    assign pc_d = imem_addr_reg;
endmodule
