`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 06:29:06 PM
// Design Name: 
// Module Name: memory
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


module memory
    (input rst_n, clk, ex_mem_RegWrite, ex_mem_MemtoReg, ex_mem_us, ex_mem_MemRead, ex_mem_MemWrite,
     input [1:0] ex_mem_rw,
     input [3:0] byte_en,
     input [4:0] ex_mem_rd,
     input [31:0] ex_mem_ALU_result, ex_mem_rd2, ex_mem_imm, pc_plus_imm, pc_plus_4,
     inout [31:0] dmem_data,
     output mem_wb_RegWrite, mem_wb_MemtoReg,
     output [1:0] mem_wb_rw,
     output [4:0] mem_wb_rd,
     output [31:0] mem_wb_ALU_result, read_data, mem_wb_imm, mem_wb_pc_plus_imm, mem_wb_pc_plus_4);
     
     wire [31:0] read_data_m;
     
     reg mem_wb_RegWrite_reg, mem_wb_MemtoReg_reg;
     reg [1:0] mem_wb_rw_reg;
     reg [4:0] mem_wb_rd_reg;
     reg [31:0] mem_wb_ALU_result_reg, read_data_reg, mem_wb_imm_reg, mem_wb_pc_plus_imm_reg, mem_wb_pc_plus_4_reg;
     
     data_memory dmem
     (.rst_n(rst_n), .clk(clk), .MemWrite(ex_mem_MemWrite), .MemRead(ex_mem_MemRead), .us(ex_mem_us),
      .byte_en(byte_en),
      .address(ex_mem_ALU_result), .write_data(ex_mem_rd2), 
      .dmem_data(dmem_data),
      .read_data(read_data_m));
     
     always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mem_wb_RegWrite_reg <= 1'b0;
            mem_wb_MemtoReg_reg <= 1'b0;
            mem_wb_rw_reg <= 2'b00;
            mem_wb_rd_reg <= 5'b00000;
            mem_wb_ALU_result_reg <= 32'd0;
            read_data_reg <= 32'd0;
            mem_wb_imm_reg <= 32'd0;
            mem_wb_pc_plus_imm_reg <= 32'd0;
            mem_wb_pc_plus_4_reg <= 32'd0;
        end
        else begin
            mem_wb_RegWrite_reg <= ex_mem_RegWrite;
            mem_wb_MemtoReg_reg <= ex_mem_MemtoReg;
            mem_wb_rw_reg <= ex_mem_rw;
            mem_wb_rd_reg <= ex_mem_rd;
            mem_wb_ALU_result_reg <= ex_mem_ALU_result;
            read_data_reg <= read_data_m;
            mem_wb_imm_reg <= ex_mem_imm;
            mem_wb_pc_plus_imm_reg <= pc_plus_imm;
            mem_wb_pc_plus_4_reg <= pc_plus_4;
//            $display("memory cycle: byte_en: %0h, us: %0b, memread: %0b, memwrite: %0b, rd2: %0h", byte_en, ex_mem_us, ex_mem_MemRead, ex_mem_MemWrite, ex_mem_rd2);
//            $display("memory cycle: RegWrite: %0h", mem_wb_RegWrite);
//            $display("ex_mem_ALU_result: %0h", mem_wb_ALU_result);
//            $display("mem_cycle: imm: %0h, rw: %b", mem_wb_imm, ex_mem_rw);
        end
     end
     
     assign mem_wb_RegWrite = mem_wb_RegWrite_reg;
     assign mem_wb_MemtoReg = mem_wb_MemtoReg_reg;
     assign mem_wb_rw = mem_wb_rw_reg;
     assign mem_wb_rd = mem_wb_rd_reg;
     assign mem_wb_ALU_result = mem_wb_ALU_result_reg;
     assign read_data = read_data_reg;
     assign mem_wb_imm = mem_wb_imm_reg;
     assign mem_wb_pc_plus_imm = mem_wb_pc_plus_imm_reg;
     assign mem_wb_pc_plus_4 = mem_wb_pc_plus_4_reg;
     
endmodule
