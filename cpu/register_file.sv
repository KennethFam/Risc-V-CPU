`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 07:24:33 PM
// Design Name: 
// Module Name: register_file
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


module register_file
    (input rst_n, clk, RegWrite, 
     input [4:0] rr1, rr2, wr, 
     input [31:0] wd, 
     output [31:0] rd1, rd2);
     
    reg [31:0] register [31:0];
    
    integer i;
    
    always @ (negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < 32; i = i + 1) register[i] <= 0;
        end
        else if (RegWrite) begin
            if (wr != 0) register[wr] <= wd;
//            $display("wr: %0h, rd1: %0h, regval: %0h, reg5: %0h", wr, rd1, wd, register[5]);
        end
    end
    
    assign rd1 = register[rr1];
    assign rd2 = register[rr2];
    
endmodule
