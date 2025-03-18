`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2024 07:11:00 PM
// Design Name: 
// Module Name: cpu
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


module cpu(input rst_n, clk, input [31:0] imem_insn, inout [31:0] dmem_data, output dmem_wen, output [3:0] byte_en, output [31:0] imem_addr, dmem_addr);
    wire ALUSrc, MemtoReg, MemRead, MemWrite, Branch, id_ex_RegWrite, Zero, ex_mem_RegWrite, mem_wb_RegWrite, stall, ex_mem_MemtoReg, mem_wb_MemtoReg, id_ex_us, ex_mem_us, ex_mem_MemRead, ex_mem_MemWrite, id_ex_Jump_Return, branch_jump_stall;
    wire [1:0] ALUOp, forwardA_sig, forwardB_sig, id_ex_rw, ex_mem_rw, mem_wb_rw;
    wire [3:0] ALUCtl, id_ex_byte_en;
    wire [4:0] rs1, rs2, id_ex_rd, ex_mem_rd, mem_wb_rd;
    wire [31:0] rd1, rd2, imm_val, target, dmem_data_cpu, mem_wb_ALU_result, write_data, ex_mem_rd2, read_data, ex_mem_imm, mem_wb_imm, pc_d, pc_plus_imm, pc_plus_4, mem_wb_pc_plus_imm, mem_wb_pc_plus_4;
    
    reg prev_stall = 1'b0;
    reg [15:0] clk_counter;
    reg [31:0] prev_pc = 32'hFFFFFFFF;
    
    fetch fetch_cycle
    (.rst_n(rst_n), .clk(clk), .Branch(branch_jump_stall), .stall(stall),
     .target(target), .imem_addr(imem_addr));
    
    decode decode_cycle
    (.rst_n(rst_n), .clk(clk), .stall(stall), .mem_wb_RegWrite(mem_wb_RegWrite), .branch_jump_stall(branch_jump_stall),
     .mem_wb_rd(mem_wb_rd),
     .imem_insn(imem_insn), .wd(write_data), .imem_addr(imem_addr),
     .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .id_ex_RegWrite(id_ex_RegWrite), .id_ex_us(id_ex_us), .id_ex_Jump_Return(id_ex_Jump_Return),
     .ALUOp(ALUOp), .id_ex_rw(id_ex_rw),
     .ALUCtl(ALUCtl), .id_ex_byte_en(id_ex_byte_en),
     .rs1(rs1), .rs2(rs2), .id_ex_rd(id_ex_rd), 
     .rd1(rd1), .rd2(rd2), .imm_val(imm_val), .pc_d(pc_d));
     
    execute execute_cycle
    (.rst_n(rst_n), .clk(clk), .Branch(Branch), .ALUSrc(ALUSrc), .id_ex_RegWrite(id_ex_RegWrite), .id_ex_MemtoReg(MemtoReg), .id_ex_us(id_ex_us), .id_ex_MemRead(MemRead), .id_ex_MemWrite(MemWrite), .id_ex_Jump_Return(id_ex_Jump_Return),
     .ALUOp(ALUOp), .forwardA_ex(forwardA_sig), .forwardB_ex(forwardB_sig), .id_ex_rw(id_ex_rw),
     .ctl(ALUCtl), .id_ex_byte_en(id_ex_byte_en),
     .id_ex_rd(id_ex_rd),
     .rd1(rd1), .rd2(rd2), .imm_val(imm_val), .imem_addr(imem_addr), .wb_result(write_data), .pc_d(pc_d),
     .Zero(Zero), .ex_mem_RegWrite(ex_mem_RegWrite), .ex_mem_MemtoReg(ex_mem_MemtoReg), .ex_mem_us(ex_mem_us), .ex_mem_MemRead(ex_mem_MemRead), .ex_mem_MemWrite(dmem_wen), .branch_jump_stall(branch_jump_stall),
     .ex_mem_rw(ex_mem_rw),
     .ex_mem_byte_en(byte_en),
     .ex_mem_rd(ex_mem_rd),
     .ALU_result(dmem_addr), .target(target), .ex_mem_rd2(ex_mem_rd2), .ex_mem_imm(ex_mem_imm), .pc_plus_imm(pc_plus_imm), .pc_plus_4(pc_plus_4));
     
     memory memory_cycle
     (.rst_n(rst_n), .clk(clk), .ex_mem_RegWrite(ex_mem_RegWrite), .ex_mem_MemtoReg(ex_mem_MemtoReg), .ex_mem_us(ex_mem_us), .ex_mem_MemRead(ex_mem_MemRead), .ex_mem_MemWrite(dmem_wen),
      .ex_mem_rw(ex_mem_rw),
      .byte_en(byte_en),
      .ex_mem_rd(ex_mem_rd),
      .ex_mem_ALU_result(dmem_addr), .ex_mem_rd2(ex_mem_rd2), .ex_mem_imm(ex_mem_imm), .pc_plus_imm(pc_plus_imm), .pc_plus_4(pc_plus_4),
      .dmem_data(dmem_data),
      .mem_wb_RegWrite(mem_wb_RegWrite), .mem_wb_MemtoReg(mem_wb_MemtoReg),
      .mem_wb_rw(mem_wb_rw),
      .mem_wb_rd(mem_wb_rd),
      .mem_wb_ALU_result(mem_wb_ALU_result), .read_data(read_data), .mem_wb_imm(mem_wb_imm), .mem_wb_pc_plus_imm(mem_wb_pc_plus_imm), .mem_wb_pc_plus_4(mem_wb_pc_plus_4));
     
    write_back write_back_cycle
    (.rst_n(rst_n), .clk(clk), .MemtoReg(mem_wb_MemtoReg),
     .mem_wb_rw(mem_wb_rw),
     .read_data(read_data), .mem_wb_ALU_result(mem_wb_ALU_result), .mem_wb_imm(mem_wb_imm), .mem_wb_pc_plus_imm(mem_wb_pc_plus_imm), .mem_wb_pc_plus_4(mem_wb_pc_plus_4),
     .write_data(write_data));
     
    hazard_detection_unit hazard
    (.id_ex_MemRead(MemRead), 
     .rs1(imem_insn[19:15]), .rs2(imem_insn[24:20]), .id_ex_rd(id_ex_rd),
     .stall(stall));
     
    forward_unit forward
    (.ex_mem_RegWrite(ex_mem_RegWrite), .mem_wb_RegWrite(mem_wb_RegWrite),
     .rs1(rs1), .rs2(rs2), .ex_mem_rd(ex_mem_rd), .mem_wb_rd(mem_wb_rd),
     .forwardA(forwardA_sig), .forwardB(forwardB_sig));
     
     integer fd1, fd2;
     
     initial begin
        fd1 = $fopen("C:/Users/KCPC/Downloads/cpu/cpu.srcs/sources_1/imports/Desktop/pc.txt", "w"); 
        fd2 = $fopen("C:/Users/KCPC/Downloads/cpu/cpu.srcs/sources_1/imports/Desktop/updates.txt", "w");
     end
     
     always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            clk_counter <= 32'd1;
        end
        else begin
            clk_counter <= clk_counter + 1;
            if ((prev_pc != pc_d) && ~prev_stall) $fwrite(fd1,"pc: %h\n", pc_d);
            prev_pc <= pc_d;
            prev_stall <= stall || branch_jump_stall;
            //$fwrite(fd2,"clk cycle %d | address: %0d | write_data: %0h\n", clk_counter, dmem_addr, dmem_data);
//            $fwrite(fd2, "clk cycle %d | reg: %0d | write_data: %0h\n", clk_counter, mem_wb_rd, write_data);
            if ((mem_wb_RegWrite || mem_wb_MemtoReg) && mem_wb_rd != 0) $fwrite(fd2, "clk cycle %d | reg: %0d | write_data: %0h\n", clk_counter, mem_wb_rd, write_data);
            if (dmem_wen) $fwrite(fd2, "clk cycle %d | address: %0h | storing: %0h\n", clk_counter, dmem_addr, dmem_data);
            $display("clk cycle %d | write_data: %0h | reg %0d | forwarda: %0h, forwardb: %0h, stall: %0b | rs1: %0h | rs2: %0h ", clk_counter, write_data, mem_wb_rd, forwardA_sig, forwardB_sig, stall, imem_insn[19:15], imem_insn[24:20]);
        end
     end
    
endmodule
