// testbench  for n - bit  ALU
module stimulus;
parameter BUS_WIDTH = 8;
    reg  [BUS_WIDTH-1:0]a;  // operand 1
    reg [BUS_WIDTH-1:0]b;   // operand 2 
    reg  carry_in;  
    reg  [3:0]opcode;  
    wire  [BUS_WIDTH-1:0]y;  
    wire   carry_out;
    wire   borrow;
    wire   zero;
    wire   parity;
    wire  invalid_op;

ALU  uut(a,b,carry_in,opcode,y,carry_out, borrow,zero, parity,invalid_op);
initial begin 
    
    $dumpfile("dump_ALU.vcd");
    $dumpvars(0, stimulus);
    
    $monitor($time,"a =%d,  b = %d, carry_in = %d,  opcode = %d, y = %b, carry_out = %b,  borrow = %b ,  zero = %b,  parity = %b,   invalid_op = %b",
    a,b,carry_in,opcode,y,carry_out, borrow,zero,parity,invalid_op);

// #1; $display("\nTest OP_INVALID");
// opcode = 0; a = 0; b = 0; carry_in = 0; 

// #1; $display("\nTest OP_ADD");
// opcode = 1; a = 9; b = 33; carry_in = 0;

// #1; $display("\nTest OP_ADD_CARRY");
// opcode = 2; a = 9; b = 33; carry_in = 1;

// #1; $display("\nTest OP_SUB");
// opcode = 3; a = 65; b = 64; carry_in = 0;
// #1 opcode = 3; a = 65; b = 66; carry_in = 0;

// #1; $display("\nTest OP_INC");
// opcode = 4; a = 233; b = 68; carry_in = 0;

// #1; $display("\nTest OP_DEC");
// opcode = 5; a = 1; b = 3; carry_in = 0;

// #1; $display("\nTest OP_AND");
// opcode = 6; a = 8'b00000010; b = 8'b00000011; 

//  #1; $display("\nTest OP_NOT");
// opcode = 7; a = 8'b11111110; 

#1; $display("\nTest OP_SOL");   //   shifting toward left  side
opcode = 8; a= 8'b11_00_11_01;  //    10_01_10_10

#1; $display("\nTest OP_SOR");  // shifting toward right side 
opcode = 9; a = 8'b10_01_00_01;   //  01_00_10_00
#50 $finish;
end
endmodule 


// iverilog -o ALU_tb.out ALU.v ALU_tb.v
// vvp ALU_tb.out
// dumpfile("dump.vcd");
// dumpvars(0, stimulus);
// gtkwave dump.vcd








design -reset
read_verilog cpu_top.v
synth -top cpu_top
dfflibmap -liberty /mnt/c/Users/ritiz/Downloads/OpenROAD-master/OpenROAD-master/test/sky130hd/sky130_fd_sc_hd__tt_025C_1v80.lib
abc -liberty /mnt/c/Users/ritiz/Downloads/OpenROAD-master/OpenROAD-master/test/sky130hd/sky130_fd_sc_hd__tt_025C_1v80.lib
write_verilog netlist_sky_cpu_top.v
write_json cpu_top_sky_netlist.json
show
