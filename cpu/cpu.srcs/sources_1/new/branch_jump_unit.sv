`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2024 06:47:01 AM
// Design Name: 
// Module Name: branch_jump_unit
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


module branch_jump_unit
    (input branch, jalr,
     input [31:0] pc_d, imm_val, alu_result,
     output branch_jump_stall,
     output [31:0] pc_plus_imm, pc_plus_4, pc_branch);
     
     wire take_branch;
     
     assign take_branch = branch && alu_result[0];
     
     assign pc_plus_imm = pc_d + imm_val;
     assign pc_plus_4 = pc_d + 32'd4;
     
     assign pc_branch = (take_branch) ? pc_plus_imm : (jalr) ? alu_result : 32'd0;
     
     assign branch_jump_stall = take_branch || jalr;
     
endmodule
