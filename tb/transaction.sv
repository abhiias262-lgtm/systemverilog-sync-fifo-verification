`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 18:44:37
// Design Name: 
// Module Name: transaction
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

class transaction;

    rand bit wr_en;
    rand bit rd_en;
    rand logic [7:0] rd_data;
    rand logic [7:0] wr_data;

    bit full;
    bit empty;
    bit overflow;
    bit underflow;
    bit read_valid;
    bit write_valid;

endclass
