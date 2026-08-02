`timescale 1ns / 1ps

module stimulus;

    // Parameters
    parameter BUS_WIDTH = 32;

    // Testbench Signals
    reg  [BUS_WIDTH-1:0] a;
    reg  [BUS_WIDTH-1:0] b;
    reg                  carry_in;
    reg  [3:0]           opcode;
    
    wire [BUS_WIDTH-1:0] y;
    wire                 carry_out;
    wire                 borrow;
    wire                 zero;
    wire                 parity;
    wire                 invalid_op;

    // Opcodes (Matching the ALU module)
    localparam OP_PASS_A     = 4'd0; 
    localparam OP_ADD        = 4'd1;
    localparam OP_ADD_CARRY  = 4'd2;
    localparam OP_SUB        = 4'd3;
    localparam OP_INC        = 4'd4;
    localparam OP_DEC        = 4'd5;
    localparam OP_AND        = 4'd6;
    localparam OP_NOT        = 4'd7;
    localparam OP_SOL        = 4'd8; 
    localparam OP_SOR        = 4'd9; 
    localparam OP_OR         = 4'd10;
    localparam OP_XOR        = 4'd11;
    localparam OP_NOR        = 4'd12;
    localparam OP_SUB_BORROW = 4'd13;
    localparam OP_SRA        = 4'd14; 
    localparam OP_SLT        = 4'd15;

    // Instantiate the Device Under Test (DUT)
    ALU #(BUS_WIDTH) dut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .opcode(opcode),
        .y(y),
        .carry_out(carry_out),
        .borrow(borrow),
        .zero(zero),
        .parity(parity),
        .invalid_op(invalid_op)
    );

    // Monitor changes and print them
    initial begin
        $display("Time | OP |      A     |      B     | Cin |      Y     | Cout | Bor | Z | P | Inv");
        $display("-----------------------------------------------------------------------------------");
        $monitor("%4t | %2d | %10d | %10d |  %b  | %10d |  %b   |  %b  | %b | %b |  %b", 
                //  $time, opcode, $signedO(a), $signed(b), carry_in, $signed(y), carry_out, borrow, zero, parity, invalid_op);
                 $time, opcode, a  ,b  , carry_in, y, carry_out, borrow, zero, parity, invalid_op);
    end

    // Stimulus Block
    initial begin
        // Initialize Inputs
        a = 0; b = 0; carry_in = 0; opcode = OP_PASS_A;
        #10;

        // 1. Test Basic Arithmetic
        a = 15; b = 10; opcode = OP_ADD; // Expected Y: 25
        #10;
        
        a = 15; b = 10; opcode = OP_SUB; // Expected Y: 5, Borrow: 0
        #10;
        
        a = 10; b = 15; opcode = OP_SUB; // Expected Y: -5 (Two's comp), Borrow: 1
        #10;

        // 2. Test Increment/Decrement
        a = 100; opcode = OP_INC;        // Expected Y: 101
        #10;
        
        a = 0; opcode = OP_DEC;          // Expected Y: -1, Borrow: 1
        #10;

        // 3. Test Bitwise Logic
        a = 32'h0000FFFF; b = 32'h0FFF0000; opcode = OP_AND; // Expected Y: 0
        #10;
        
        a = 32'h0000FFFF; b = 32'h0FFF0000; opcode = OP_OR;  // Expected Y: 0x0FFFFFFF
        #10;
        
        a = 32'hAAAAAAAA; b = 32'h55555555; opcode = OP_XOR; // Expected Y: 0xFFFFFFFF (-1)
        #10;

        // 4. Test Shifts
        a = 32'd1; b = 32'd4; opcode = OP_SOL; // Shift Left 4 (1 * 16) -> Y: 16
        #10;
        
        a = 32'd16; b = 32'd2; opcode = OP_SOR; // Logical Shift Right 2 (16 / 4) -> Y: 4
        #10;
        
        a = -32'd16; b = 32'd2; opcode = OP_SRA; // Arith Shift Right 2 -> Y: -4 (preserves sign)
        #10;

        // 5. Test Set Less Than (SLT) - Signed Comparison
        a = 10; b = 20; opcode = OP_SLT;   // 10 < 20? Yes -> Y: 1
        #10;
        
        a = 20; b = 10; opcode = OP_SLT;   // 20 < 10? No -> Y: 0
        #10;
        
        a = -5; b = 5; opcode = OP_SLT;    // -5 < 5? Yes -> Y: 1
        #10;

        // 6. Test Zero Flag
        a = 5; b = 5; opcode = OP_SUB;     // 5 - 5 = 0 -> Expected Y: 0, Zero: 1
        #10;

        // End Simulation
        $display("Simulation Complete.");
        $finish;
    end

    initial begin 
    
    $dumpfile("Updated_ALU.vcd");
    $dumpvars(0, stimulus);
    end

endmodule



// iverilog -o ALU_tb_2.out ALU.v ALU_tb_2.v
// vvp ALU_tb_2.out
// dumpfile("dump.vcd");
// dumpvars(0, stimulus);
// gtkwave dump.vcd