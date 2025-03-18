`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 10:49:14 PM
// Design Name: 
// Module Name: alu
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


module alu
    (input [3:0] ctl, 
     input [31:0] a, b, 
     output Zero, 
     output reg [31:0] ALU_result);
     
     assign Zero = (ALU_result == 0);
     
     always @ (*) begin
        case(ctl)
            //number manipulation
            4'b0000: ALU_result = a & b; //and
            4'b0001: ALU_result = a | b; //or 
            4'b0010: ALU_result = $signed(a) + $signed(b); //addition
            4'b0011: ALU_result = a ^ b; //xor
            4'b0100: ALU_result = a << b[4:0]; //left shift
            4'b0101: ALU_result = a >> b[4:0]; //righ shift
            4'b0110: ALU_result = $signed(a) - $signed(b); //subtraction
            4'b0111: ALU_result = $signed(a) >>> b[4:0]; //right shift arithmetic
            
            //comparisons
            4'b1000: ALU_result = (a == b) ? 31'd1 : 32'd0; //equal
            4'b1001: ALU_result = (a != b) ? 32'd1 : 32'd0; //not equal
            4'b1100: ALU_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; //signed less than
            4'b1101: ALU_result = ($signed(a) >= $signed(b)) ? 32'd1 : 32'd0; //signed greater than/equal to
            4'b1110: ALU_result = (a < b) ? 32'd1 : 32'd0; //unsigned less than
            4'b1111: ALU_result = (a >= b) ? 32'd1 : 32'd0; //unsigned greater than/equal to
            
            //jal
            4'b1010: ALU_result = 32'd1;
            
            default:
                ALU_result = 32'd0;
        endcase
//        $display("a: %d, b: %d, result = %h", $signed(a), $signed(b), ALU_result);
     end

endmodule
