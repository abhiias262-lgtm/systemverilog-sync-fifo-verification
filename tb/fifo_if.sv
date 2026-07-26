
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 19:05:24
// Design Name: 
// Module Name: fifo_if
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


interface fifo_if #(parameter DATA_WIDTH = 16);

    logic clk;
    logic rst_n;

    logic wr_en;
    logic rd_en;

    logic [DATA_WIDTH-1:0] wr_data;
    logic [DATA_WIDTH-1:0] rd_data;

    logic full;
    logic empty;

    logic overflow;
    logic underflow;

endinterface
