`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2024 05:54:03 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory
    (input rst_n, clk, MemWrite, MemRead, us,
     input [3:0] byte_en,
     input [31:0] address, write_data, 
     inout [31:0] dmem_data,
     output reg [31:0] read_data);
     
     reg [7:0] memory [2047:0];
     
     wire [31:0] wd;
     integer i;
     
     always @ (*) begin
        if (~rst_n) read_data = 32'd0;
        else if (MemRead) begin
            if (byte_en == 4'b0001) begin
                if (us) begin
                    read_data = {{24{1'b0}}, dmem_data[7:0]};
                end
                else begin
                    read_data = {{24{dmem_data[7]}}, dmem_data[7:0]};
                end
            end
            else if (byte_en == 4'b0011) begin 
                if (us) begin
                    read_data = {{16{1'b0}}, dmem_data[15:0]};
                end
                else begin
                    read_data = {{16{dmem_data[15]}}, dmem_data[15:0]};
                end
            end
            else if (byte_en == 4'b1111) read_data = dmem_data;
//            $display("data_memory: read_data: %0h, mem_read: %b, byte_en: %0b, address: %0h, mod: %h, memval: %0h, us: %b, testing: %0h", read_data, MemRead, byte_en, address, address % 2048, memory[address % 2048], us, memory[32'h1001000c % 2048]);
        end
        else read_data = 32'd0;
     end
     
     assign dmem_data = (MemWrite) ? write_data : 32'bz;

endmodule
