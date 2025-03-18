`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 10:35:21 AM
// Design Name: 
// Module Name: pc
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


module pc(input clk, rst_n, stall, input[31:0] pc_next, output reg [31:0] pc);
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n) pc <= 32'h00000000;
        else if (~stall) pc <= pc_next;
    end
    
endmodule
