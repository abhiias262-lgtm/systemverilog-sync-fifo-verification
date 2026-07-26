`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 21:27:31
// Design Name: 
// Module Name: test
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


class test;

    environment env;

    virtual fifo_if vif;

    function new(virtual fifo_if vif);

        this.vif = vif;

    endfunction

    task build();

        env = new(vif);

        env.build();

    endtask

    task run();

        env.run();

    endtask

endclass
