// `timescale 1ns/1ps

// module stimulus;

//     reg clk;
//     reg reset;
//     wire [31:0] out_data;

//     // Instantiate DUT (Device Under Test)
//     cpu_top uut (
//         .clk(clk),
//         .reset(reset),
//         .out_data(out_data)
//     );

//     // Clock generation: 10ns period
//     initial begin
//         clk = 0;
//         forever #5 clk = ~clk; // toggle every 5ns
//     end

//     // Stimulus
//     initial begin
//         // Apply reset
//         reset = 1;
//         #20;             // hold reset for 20ns
//         reset = 0;

//         // Run for some cycles
//         #200;

//         // Finish simulation
//         $finish;
//     end

//     // Monitor outputs
//     initial begin
//        $monitor("Time=%0t | PC=%d | instr=%h | reg_a=%h | reg_b=%h | out_data=%d",
//           $time, uut.pc, uut.instr, uut.reg_a, uut.reg_b, out_data);
//     end
//     initial begin
//         $dumpfile("cpu_top.vcd");
// $dumpvars(0, stimulus);
//     end

// endmodule


`timescale 1ns / 1ps

module cpu_top_tb;

    // Inputs to the CPU
    reg clk;
    reg reset;

    // Outputs from the CPU
    wire [31:0] out_data;

    // Instantiate the Top-Level CPU
    cpu_top uut (
        .clk(clk),
        .reset(reset),
        .out_data(out_data)
    );

    // Clock Generation: 10 time-unit period
    always #5 clk = ~clk;

    // Monitor changes and print them to the console
  // Monitor changes and print them to the console
    initial begin
        $display("===============================================================================");
        $display(" Time  | IF Stage (PC) | ID Stage (Instr) | EX Stage (ALU) | WB Stage (Final) ");
        $display("===============================================================================");
        
        // Notice how we use uut.if_pc instead of uut.current_pc!
        $monitor("%5t |   %8d   |     %h     |    %8d    |    %8d", 
                 $time, uut.if_pc, uut.id_instr, uut.ex_alu_result, out_data);
    end
    // Simulation Stimulus (Reset and Run)
    initial begin
        // 1. Initialize clock and assert reset
        clk = 0;
        reset = 1;
        
        // 2. Hold reset for a bit to ensure PC starts at 0
        #10;
        reset = 0;

        // 3. Let the CPU run for a while (adjust time based on your program length)
        #2000; 

        $display("=========================================================");
        $display("Simulation finished.");
        $finish;
    end

    // Optional: Dump waves for GTKWave or ModelSim viewing
    initial begin
        $dumpfile("cpu_trace.vcd");
        $dumpvars(0, cpu_top_tb);
    end

endmodule


// iverilog -o cpu_top_tb.out cpu_top.v   alu_control.v program_counter.v  hardware_multiplier.v  memory_interconnect.v  if_id_reg.v ex_mem_reg.v forwarding_unit.v hazard_detection.v id_ex_reg.v mem_wb_reg.v ALU.v control_unit.v parameterized_RAM.v  regfile.v rom.v  cpu_top_tb.v divider.v 
// vvp cpu_top_tb.out 
// dumpfile("dump.vcd");
// dumpvars(0, stimulus);
// gtkwave cpu_trace.vcd

