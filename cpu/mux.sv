`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 10:03:06 AM
// Design Name: 
// Module Name: mux
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


module mux(input s, input [31:0] a, b, output [31:0] c);

    assign c = ~s ? a : b;

endmodule

module mux4_1 
    (input [1:0] s,
     input [31:0] a, b, c,
     output [31:0] d);
     
     assign d = (s == 2'b01) ? b : (s == 2'b10) ? c : a;
//        $display("rs: %0h, memwb: %0h, alu: %0h, pick: %0h, forward: %0h", a, b, c, d, s);
     
endmodule

module mux_4_1
    (input [1:0] s,
     input [31:0] a, b, c, d,
     output [31:0] e);
     
     assign e = (s == 2'b00) ? a : (s == 2'b01) ? b : (s == 2'b10) ? c : d;
     
endmodule
