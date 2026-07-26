`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2026 22:42:08
// Design Name: 
// Module Name: fifo_sva
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

module fifo_sva #(

    parameter int DATA_WIDTH = 16,
    parameter int DEPTH = 8,
    localparam int ADDR_WIDTH    = $clog2(DEPTH),
    localparam int COUNTER_WIDTH = $clog2(DEPTH+1)

)(
    input logic clk,
    input logic rst_n,

    input logic wr_en,
    input logic rd_en,

    input logic full,
    input logic empty,

    input logic overflow,
    input logic underflow,

    input logic write_valid,
    input logic read_valid,

    input logic [COUNTER_WIDTH-1:0] data_count,
    input logic [ADDR_WIDTH-1:0] wr_ptr,
    input logic [ADDR_WIDTH-1:0] rd_ptr
);

    // ------------------------
    // Properties
    // ------------------------

    property p_empty_flag;
        @(posedge clk)
        disable iff(!rst_n)
        (data_count==0) |-> empty;
    endproperty 
    
    assert property(p_empty_flag)
    else
        $error("ASSERTION FAILED : Empty flag mismatch");
        

    property p_empty_flag_rev;
        @(posedge clk)
        disable iff(!rst_n)
       empty |-> !data_count;
    endproperty 
    
    assert property(p_empty_flag_rev)
    else
        $error("ASSERTION FAILED : Empty flag mismatch reverse");
        
    
    property p_full_flag;
        @(posedge clk)
        disable iff(!rst_n)
        (data_count==DEPTH) |-> full;
    endproperty 
    
    assert property(p_full_flag)
    else
        $error("ASSERTION FAILED : full flag mismatch");
        
    
    property p_count;
        @(posedge clk)
        disable iff(!rst_n)
        data_count <= DEPTH;
    endproperty 
    
    assert property(p_count)
    else
        $error("ASSERTION FAILED : counter exceeded depth");
        
        
 
   property p_full_empty;
        @(posedge clk)
        disable iff(!rst_n)
        !(full && empty);
    endproperty 
    
    assert property(p_full_empty)
    else
        $error("ASSERTION FAILED : fifo cannot be full and empty together ");    
        
        
    property p_underflow;
        @(posedge clk)
        disable iff(!rst_n)
        (rd_en && empty) |-> underflow;
    endproperty 
    
    assert property(p_underflow)
    else
        $error("ASSERTION FAILED : underflow condition");   
 
 
     property p_overflow;
        @(posedge clk)
        disable iff(!rst_n)
       (wr_en && full && !read_valid) |-> overflow;
    endproperty 
    
    assert property(p_overflow)
    else
        $error("ASSERTION FAILED : overflow condition");       
        
        
    property p_read_ptr;
        @(posedge clk)
        disable iff(!rst_n)
        rd_ptr < DEPTH;
    endproperty 
    
    assert property(p_read_ptr)
    else
        $error("ASSERTION FAILED : read pointer exceeded depth");      


    property p_write_ptr;
        @(posedge clk)
        disable iff(!rst_n)
        wr_ptr < DEPTH;
    endproperty 
    
    assert property(p_write_ptr)
    else
        $error("ASSERTION FAILED : write pointer exceeded depth");  
        
        
   property p_read_write;
        @(posedge clk)
        disable iff(!rst_n)
        (write_valid && read_valid)|=> data_count == $past(data_count);
    endproperty 
    
    assert property(p_read_write)
    else
        $error("ASSERTION FAILED : count changed when read and write are valid simultaneously "); 

endmodule 

//=========================================
// Bind Statement
//=========================================

bind sync_fifo fifo_sva #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
) fifo_sva_inst (

    .clk(clk),
    .rst_n(rst_n),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .full(full),
    .empty(empty),

    .overflow(overflow),
    .underflow(underflow),

    .write_valid(write_valid),
    .read_valid(read_valid),

    .data_count(data_count),

    .wr_ptr(wr_ptr),
    .rd_ptr(rd_ptr)
);
