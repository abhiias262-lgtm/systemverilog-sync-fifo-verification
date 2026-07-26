`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2026 18:29:46
// Design Name: 
// Module Name: scoreboard
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


class scoreboard;


    mailbox  mon2scb;

    transaction tr;

    bit [7:0] model_queue[$];
    bit [7:0] expected;


    function new(mailbox  mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    //----------------------------------------
    // Run Task
    //----------------------------------------
    task run();

        forever begin

            // Wait for monitor transaction
            mon2scb.get(tr);

            //-------------------------------------------------
            // WRITE Operation
            //-------------------------------------------------
            if(tr.write_valid) begin

                model_queue.push_back(tr.wr_data);

                $display("[SCB] WRITE : %0h pushed into Reference Queue",
                         tr.wr_data);

            end

            //-------------------------------------------------
            // READ Operation
            //-------------------------------------------------
            if(tr.read_valid) begin

                if(model_queue.size()==0) begin

                    $error("[SCB] Reference Model Underflow");

                end
                else begin

                    expected = model_queue.pop_front();

                    if(expected == tr.rd_data)

                        $display("[SCB] PASS  Expected=%0h Actual=%0h",
                                  expected,
                                  tr.rd_data);

                    else

                        $error("[SCB] FAIL  Expected=%0h Actual=%0h",
                                expected,
                                tr.rd_data);

                end
            end

            //-------------------------------------------------
            // Debug Information
            //-------------------------------------------------
            $display("-----------------------------------------");
            $display("[SCB] Queue Size = %0d", model_queue.size());
            $display("-----------------------------------------");

        end

    endtask

endclass