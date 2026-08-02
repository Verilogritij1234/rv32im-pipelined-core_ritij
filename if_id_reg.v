module if_id_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        stall,           // 1 = freeze the register
    input  wire        flush,     // 1 = clear the instruction (branch taken)
    
    // inputs  from the Fetch stage 
    input  wire [31:0] if_pc,
    input  wire [31:0] if_instr,
    
      // outputs to the Decode stage 
    output reg  [31:0] id_pc,
    output reg  [31:0] id_instr
);


    localparam NOP_INSTR = 32'h00000013;  //  no operation declaration 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            id_pc    <= 32'b0;
            id_instr <= NOP_INSTR;
        end 
        else if (flush) begin
            id_pc    <= 32'b0;
            id_instr <= NOP_INSTR; // kill the bad instruction
        end 
        else if (!stall) begin
            id_pc    <= if_pc;     // Pass the PC forward
            id_instr <= if_instr;  // Pass the Instruction forward
        end
                   // if stall is 1 keep holding the old values)
    end

endmodule