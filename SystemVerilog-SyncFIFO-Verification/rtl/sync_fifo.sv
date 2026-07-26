
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 22:04:05
// Design Name: 
// Module Name: sync_fifo
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


module sync_fifo #(
    parameter int DATA_WIDTH = 16,
    parameter int DEPTH      = 8,

    localparam int ADDR_WIDTH    = $clog2(DEPTH),
    localparam int COUNTER_WIDTH = $clog2(DEPTH + 1)
)(
    input  logic                     clk,
    input  logic                     rst_n,

    input  logic                     wr_en,
    input  logic                     rd_en,
    input  logic [DATA_WIDTH-1:0]    wr_data,

    output logic [DATA_WIDTH-1:0]    rd_data,

    output logic                     full,
    output logic                     empty,
    output logic                     overflow,
    output logic                     underflow,

    output logic [COUNTER_WIDTH-1:0] data_count
);

    //---------------------------------------------------------
    // Internal Signals
    //---------------------------------------------------------
    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr;

    logic write_valid;
    logic read_valid;

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    //---------------------------------------------------------
    // Flag Generation
    //---------------------------------------------------------
    always_comb begin
        empty = (data_count == 0);
        full  = (data_count == DEPTH);
    end

    //---------------------------------------------------------
    // Read / Write Acceptance Logic
    //---------------------------------------------------------
    always_comb begin
        read_valid  = rd_en && !empty;
        write_valid = wr_en && (!full || read_valid);
    end

    //---------------------------------------------------------
    // Overflow / Underflow
    //---------------------------------------------------------
    always_comb begin
        overflow  = wr_en && full  && !read_valid;
        underflow = rd_en && empty;
    end

    //---------------------------------------------------------
    // Memory Write
    //---------------------------------------------------------
    always_ff @(posedge clk) begin
        if (write_valid)begin
                $display("[WRITE] wr_ptr=%0d data=%h",
                 wr_ptr, wr_data); 
            mem[wr_ptr] <= wr_data;
//            wr_ptr<=wr_ptr+1;
       end     
    end

    //---------------------------------------------------------
    // Memory Read
    //---------------------------------------------------------
    always_ff @(posedge clk) begin
        if (read_valid)begin
                $display("[READ] rd_ptr=%0d mem=%h",
                 rd_ptr, mem[rd_ptr]);
            rd_data <= mem[rd_ptr];
//            rd_ptr<=rd_ptr+1;
            end
    end

    //---------------------------------------------------------
    // Pointer & Counter Update
    //---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr     <= '0;
            rd_ptr     <= '0;
            data_count <= '0;
        end
        else begin
            unique case ({read_valid, write_valid})
                2'b00:begin
                end
//                // Write Only
                2'b01: begin
                    wr_ptr     <= wr_ptr + 1;
                    data_count <= data_count + 1;
                end

//                // Read Only
                2'b10: begin
                    rd_ptr     <= rd_ptr + 1;
                    data_count <= data_count - 1;
                end

//                // Simultaneous Read & Write
                2'b11: begin
                    wr_ptr <= wr_ptr + 1;
                    rd_ptr <= rd_ptr + 1;
//                    // data_count remains unchanged
                end

                default: begin
//                    // No Operation
                end

            endcase
        end
    end
    always @(posedge clk) begin
    $display("[FIFO] wr_ptr=%0d rd_ptr=%0d count=%0d empty=%0b full=%0b rd_data=%h",
              wr_ptr, rd_ptr, data_count, empty, full, rd_data);
        end
    

endmodule
