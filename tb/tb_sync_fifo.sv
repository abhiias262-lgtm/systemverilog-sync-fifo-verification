
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 14:04:37
// Design Name: 
// Module Name: tb_sync_fifo
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


`timescale 1ns/1ps

module tb_sync_fifo;


    fifo_if vif();


    test t;

    //---------------------------------------------------
    // Clock Generation
    //---------------------------------------------------
    initial begin
        vif.clk = 0;
        forever #5 vif.clk = ~vif.clk;
    end
    

    //---------------------------------------------------
    // Reset Generation
    //---------------------------------------------------
    initial begin

        vif.rst_n = 0;

        vif.wr_en   = 0;
        vif.rd_en   = 0;
        vif.wr_data = 0;

        repeat(2) @(posedge vif.clk);

        vif.rst_n = 1;

    end
    
    //---------------------------------------------------
    // DUT Instantiation
    //---------------------------------------------------
    sync_fifo dut(

        .clk       (vif.clk),
        .rst_n     (vif.rst_n),

        .wr_en     (vif.wr_en),
        .rd_en     (vif.rd_en),

        .wr_data   (vif.wr_data),
        .rd_data   (vif.rd_data),

        .full      (vif.full),
        .empty     (vif.empty),

        .overflow  (vif.overflow),
        .underflow (vif.underflow)

    );

    //---------------------------------------------------
    // Test Execution
    //---------------------------------------------------
    initial begin

        t = new(vif);

        t.build();

        t.run();

    end


    //---------------------------------------------------
    // Timeout
    //---------------------------------------------------
    initial begin
        #5000;
        $display("------------------------------------");
        $display("Simulation Timeout");
        $display("------------------------------------");
        $finish;
    end

endmodule
/*
module tb_sync_fifo#( 
    parameter int DATA_WIDTH=16,
    parameter int DEPTH=8,
    localparam  int ADDR_WIDTH = $clog2(DEPTH),
    localparam  int COUNTER_WIDTH = $clog2(DEPTH+1)
    );
    
    logic clk;
    logic rst_n;
    logic rd_en,wr_en;
    logic [DATA_WIDTH-1:0] wr_data;
    logic [DATA_WIDTH-1:0] rd_data;
    logic underflow,overflow;
    logic full,empty;
    logic [COUNTER_WIDTH-1:0] data_count;
    
   
    logic [DATA_WIDTH-1:0] expected_data;
    logic [DATA_WIDTH-1:0] ref_q[$];
    
    int unsigned total_tests;
    int unsigned test_passed;
    int unsigned test_failed;
    int unsigned error;
    bit status;
        
        
    sync_fifo DUT(.clk(clk),
                  .rst_n(rst_n),
                  .rd_en(rd_en),
                  .wr_en(wr_en),
                  .wr_data(wr_data),
                  .rd_data(rd_data),
                  .underflow(underflow),
                  .overflow(overflow),
                  .full(full),
                  .empty(empty),
                  .data_count(data_count));
                  

     //clock generation
    initial begin
            clk=0;
            forever #5 clk=~clk;
    end
    
    //initializing
    initial begin
        wr_en   = 0;
        rd_en   = 0;
//        wr_data = 0;
        rst_n = 1;
    test_passed = 0;
    test_failed = 0;
    total_tests =0;
        
    end
    
    covergroup fifo_cg @(posedge clk);
    
    option.per_instance = 1;
    option.name = "FIFO Functional Coverage";
    
    cp_wr_en : coverpoint wr_en;
    cp_rd_en : coverpoint rd_en;
    
    cp_full  : coverpoint full;
    cp_empty : coverpoint empty;
    
    cp_overflow : coverpoint overflow;
    cp_underflow : coverpoint underflow;
    
    cp_data_count : coverpoint data_count
    {
        bins EMPTY  = {0};
        bins PARTIAL = {[1:DEPTH-1]};
        bins FULL ={DEPTH};
    }
    
    cross_wr_rd  : cross cp_wr_en, cp_rd_en;
    cross_wr_full  : cross cp_wr_en, cp_full;
    cross_rd_empty  : cross cp_rd_en, cp_empty;
    
    
    endgroup
    
    
        
    fifo_cg cg;

    initial begin
    cg = new();
    end
    
    
   //----------------------------------------------------------
    //reset generator
   //----------------------------------------------------------
    task fifo_reset;
    begin
        rst_n=0;
        repeat(2)@(posedge clk);
        rst_n=1;
        $display("fifo reset successfull");
    end    
    endtask
    
    
    //----------------------------------------------------------  
    //task write
    //----------------------------------------------------------
    task fifo_write(input logic [DATA_WIDTH-1:0] data);
        begin
            wr_data = data;
            wr_en   = 1;
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);
        end
    endtask
    
    
     //---------------------------------------------------------- 
    //task read
    //----------------------------------------------------------  
    task fifo_read();
        begin
        rd_en = 1;
        @(posedge clk);
        rd_en = 0;
        @(posedge clk);
        end
    endtask
    
   //---------------------------------------------------------- 
   //queued input
   //----------------------------------------------------------

    always @(posedge clk)
    begin
        if(DUT.write_valid)
            begin
                ref_q.push_back(wr_data);

                $display("[%0t] REF WRITE : %0h",
                 $time, wr_data);
            end
    end
    
    
   //---------------------------------------------------------- 
   //scoreboard
   //----------------------------------------------------------
    always @(posedge clk)
    begin
  
    if(rst_n && DUT.read_valid)
    begin
        total_tests=total_tests+1;
        if(ref_q.size()==0)
        begin
            $display("[%0t] Scoreboard Error : Queue Empty!",
                    $time);
            error=error+1;
        end
        else
        begin

            expected_data = ref_q.pop_front();

            if(DUT.rd_data == expected_data)
            begin
                $display("[%0t] PASS  Expected=%0h Actual=%0h",
                         $time,
                         expected_data,
                         DUT.rd_data);
                test_passed=test_passed+1;
            end
            else
            begin
                $display("[%0t] FAIL Expected=%0h Actual=%0h",
                       $time,
                       expected_data,
                       DUT.rd_data);
               test_failed=test_failed +1;
            end

        end
    end
    end
    
    
    
    
    
    //----------------------------------------------------------------
    // task random test generator
    //----------------------------------------------------------------
    task random_input();
    begin
        case($urandom_range(0,2))
            0:fifo_write($urandom);

            1:fifo_read();

            2:
            begin
                @(posedge clk);
                wr_en   <= 1;
                rd_en   <= 1;
                wr_data <= $urandom;

                @(posedge clk);
                wr_en <= 0;
                rd_en <= 0;
            end
        endcase
    end
    endtask 
    
//    event test_done;
    initial begin
    fifo_reset();
  
    repeat(50)
    begin
        random_input();
    end
    repeat(10) @(posedge clk);
    status = (test_failed == 0);
    
    repeat(2) @(posedge clk);
//    -> test_done;
    end
    
    initial begin
//    @test_done;
    #5000;
    $display("------------------------------");
    $display("  FIFO VERIFICATION REPORT    ");
    $display("------------------------------");   
    
    $display("Total Tests : %0d",total_tests);   
    
    $display("Tests Passed : %0d",test_passed);

    $display("Tests Failed : %0d",test_failed);
    
    $display("STATUS : %s", status ? "PASS" : "FAIL");
    
    $display("Coverage = %0.2f%%", cg.get_inst_coverage());
    
    #20;
    $finish;
    end

    


endmodule
*/































