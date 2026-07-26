`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 11:16:02
// Design Name: 
// Module Name: monitor
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


class monitor;

    transaction tr;
    mailbox mon2scb;
    virtual fifo_if vif;
    bit read_valid;
    bit write_valid;

    function new(mailbox mon2scb,virtual fifo_if vif);

        this.mon2scb = mon2scb;
        this.vif     = vif;

    endfunction

    task run();

    forever begin
        @(posedge vif.clk);
        #1;
    if(vif.wr_en || vif.rd_en) begin
        tr = new();

        tr.wr_en = vif.wr_en;
        tr.rd_en = vif.rd_en;
        tr.full  = vif.full;
        tr.empty = vif.empty;
        tr.wr_data = vif.wr_data;
         @(posedge vif.clk);
        tr.rd_data = vif.rd_data;

        tr.read_valid  = vif.rd_en && !vif.empty;
        tr.write_valid = vif.wr_en && (!vif.full || tr.read_valid);


        $display("[MON] SEND wr=%0b rd=%0b wr_data=%h rd_data=%0h",
                 tr.wr_en,
                 tr.rd_en,
                 tr.wr_data,
                 tr.rd_data);

        mon2scb.put(tr);
        end
    end

endtask

endclass
