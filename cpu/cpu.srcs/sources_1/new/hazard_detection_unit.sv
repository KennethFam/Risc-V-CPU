`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 03:27:47 PM
// Design Name: 
// Module Name: hazard_detection_unit
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


module hazard_detection_unit
    (input id_ex_MemRead,
     input [4:0] rs1, rs2, id_ex_rd, 
     output reg stall);
     
     assign stall = id_ex_MemRead ? ((id_ex_rd == rs1) || (id_ex_rd == rs2)) : 0;
     
endmodule
