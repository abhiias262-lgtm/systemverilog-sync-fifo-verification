`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 10:57:13
// Design Name: 
// Module Name: driver
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

class driver;

    transaction tr;
    mailbox gen2drv;
    virtual fifo_if vif;


    function new(mailbox gen2drv,virtual fifo_if vif);
        this.gen2drv = gen2drv;
        this.vif     = vif;
    endfunction


    task run();

        forever begin
            $display("[%0t] DRIVER WAITING", $time);
            gen2drv.get(tr);
            $display("[%0t] DRIVER GOT TRANSACTION", $time);
            
            @(posedge vif.clk) begin
                vif.wr_en   <= tr.wr_en;
                vif.rd_en   <= tr.rd_en;
                vif.wr_data <= tr.wr_data;
            end
            $display("[DRV] wr=%0d rd=%0d wr_data=%0h",tr.wr_en,tr.rd_en,tr.wr_data);

            @(posedge vif.clk)begin
            vif.wr_en <= 0;
            vif.rd_en <= 0;
            end
            
           
            
            
        end

    endtask

endclass