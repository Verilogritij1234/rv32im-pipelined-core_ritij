`timescale 1ns / 1ps

module tb_regfile;

    // inputs
    reg clk;
    reg we;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] wd;

    // outputs
    wire [31:0] rd1;
    wire [31:0] rd2;

    // instantiation of  regfile block
    regfile uut (
        .clk(clk), 
        .we(we), 
        .rs1(rs1), 
        .rs2(rs2), 
        .rd(rd), 
        .wd(wd), 
        .rd1(rd1), 
        .rd2(rd2)
    );


    always #5 clk = ~clk;

    // Monitor 
    initial begin
        $display("Time | clk | we | rs1 | rs2 | rd |    wd    |   rd1    |   rd2    ");
        $display("------------------------------------------------------------------");
        $monitor("%4t |  %b  |  %b | %3d | %3d | %2d | %8h | %8h | %8h", 
                 $time, clk, we, rs1, rs2, rd, wd, rd1, rd2);
    end

    // Stimulus
    initial begin
        // 1. Initialize Inputs
        clk = 0;
        we = 0;
        rs1 = 0; rs2 = 0; rd = 0; wd = 0;
        #10; // Wait for 1 clock cycle

        $display("\n--- Test 1: Write to R1 and R2 ---");
        we = 1; rd = 5'd1; wd = 32'hAAAA_BBBB; // Write to R1
        #10; 
        we = 1; rd = 5'd2; wd = 32'h1111_2222; // Write to R2
        #10;

        $display("\n--- Test 2: Read from R1 and R2 simultaneously ---");
        we = 0; // Turn off write enable
        rs1 = 5'd1; // Read R1
        rs2 = 5'd2; // Read R2
        #10;

        $display("\n--- Test 3: Attempt to overwrite R0 (Should fail) ---");
        we = 1; rd = 5'd0; wd = 32'hDEAD_BEEF; // Try to write to R0
        #10;
        
        we = 0; rs1 = 5'd0; // Read R0 to verify it is still 0
        #10;

        $display("\n--- Test 4: Write Enable (WE) test ---");
        we = 0; rd = 5'd3; wd = 32'hFFFF_FFFF; // Try to write with WE=0
        #10;
        
        rs1 = 5'd3; // Read R3 to verify it is still 0 (write didn't happen)
        #10;

        $display("\n--- Simulation Complete ---");
        $finish;
    end
endmodule




// iverilog -o regfile_tb.out regfile.v regfile_tb.v
// vvp regfile_tb.out
// dumpfile("dump.vcd");
// dumpvars(0, stimulus);
// gtkwave dump.vcd
