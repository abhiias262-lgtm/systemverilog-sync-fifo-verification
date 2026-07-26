`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 18:49:33
// Design Name: 
// Module Name: environment
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


class environment;

    generator gen;

    driver drv;

    monitor mon;

    scoreboard scb;

    mailbox gen2drv;

    mailbox mon2scb;

    virtual fifo_if vif;

    function new(virtual fifo_if vif);

        this.vif = vif;

    endfunction

    task build();

        gen2drv = new();

        mon2scb = new();

        gen = new(gen2drv);

        drv = new(gen2drv,vif);

        mon = new(mon2scb,vif);

        scb = new(mon2scb);

    endtask

    task run();
         $display("ENV START");
        fork

            gen.run();

            drv.run();

            mon.run();

            scb.run();

        join_none

//        disable fork;

    endtask

endclass