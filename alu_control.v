module alu_control (
    input  wire [1:0] alu_op,      // 2-bit code from Main Control Unit
    input  wire [2:0] funct3,      // From instruction[14:12]
    input  wire [6:0] funct7,      // From instruction[31:25]
    output reg  [3:0] alu_opcode   // 4-bit opcode to feed into your ALU
);

    // Your ALU's Opcodes (From the ALU we built earlier)
    localparam OP_ADD = 4'd1;
    localparam OP_SUB = 4'd3;
    localparam OP_AND = 4'd6;
    localparam OP_SOL = 4'd8;  // Shift Left Logical
    localparam OP_SOR = 4'd9;  // Shift Right Logical
    localparam OP_OR  = 4'd10;
    localparam OP_XOR = 4'd11;
    localparam OP_SRA = 4'd14; // Shift Right Arithmetic
    localparam OP_SLT = 4'd15; // Set Less Than

    always @(*) begin
        case (alu_op)
            2'b00: alu_opcode = OP_ADD; // Memory (LOAD/STORE) needs to ADD the offset
            
            2'b01: alu_opcode = OP_SUB; // Branches (BEQ/BNE) need to SUBTRACT to compare
            
            default: begin              // R-Type (10) and I-Type (11) Math
                case (funct3)
                    3'b000: begin
                        // If it's an R-Type (alu_op==10) AND the 6th bit of funct7 is 1, it's a SUBTRACT
                        if (alu_op == 2'b10 && funct7[5] == 1'b1)
                            alu_opcode = OP_SUB;
                        else
                            alu_opcode = OP_ADD; // Otherwise, standard ADD or ADDI
                    end
                    3'b111: alu_opcode = OP_AND;
                    3'b110: alu_opcode = OP_OR;
                    3'b100: alu_opcode = OP_XOR;
                    3'b001: alu_opcode = OP_SOL; // Shift Left
                    3'b101: begin
                        // Check funct7 to decide between Logical or Arithmetic Right Shift
                        if (funct7[5] == 1'b1)
                            alu_opcode = OP_SRA;
                        else
                            alu_opcode = OP_SOR;
                    end
                    3'b010: alu_opcode = OP_SLT; // Set Less Than
                    
                    default: alu_opcode = 4'd0;  // Default safety state
                endcase
            end
        endcase
    end
endmodule