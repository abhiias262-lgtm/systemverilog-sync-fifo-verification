`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 10:26:03
// Design Name: 
// Module Name: generator
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


class generator;
    transaction tr;
    mailbox gen2drv;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        repeat(30) begin
            tr = new();
            assert(tr.randomize())
            else
                $fatal(1,"Randomization Failed");

            $display("[GEN] wr=%0d rd=%0d data=%0h",
                     tr.wr_en, tr.rd_en, tr.wr_data);

            gen2drv.put(tr);
            $display("[%0t] GENERATOR SENT", $time);

        end
    endtask
endclass
