#
# Copyright (c) 2026, Ritij Kaushal
# All rights reserved.
# 


module control_unit (
    input  wire [6:0] opcode,
    
    output reg        branch,      // 1 if Branch instruction
    output reg        mem_to_reg,  // 1 = Write RAM data to Reg, 0 = Write ALU data
    output reg [1:0]  alu_op,      // Tells ALU Decoder what instruction category this is
    output reg        mem_write,   // 1 = Write to RAM
    output reg        alu_src,     // 0 = Reg B, 1 = Immediate
    output reg        reg_write    // 1 = Write to Register File
);

    always @(*) begin
       
        branch     = 1'b0; 
        mem_to_reg = 1'b0; 
        alu_op     = 2'b00;
        mem_write  = 1'b0; 
        alu_src    = 1'b0; 
        reg_write  = 1'b0;

        case(opcode)
            7'b0110011: begin     //   for R Type  instructions
                reg_write = 1'b1;
                alu_op    = 2'b10;
            end
            
            7'b0010011: begin  //  for  I Type (immidiate type instructions)
                alu_src   = 1'b1;
                reg_write = 1'b1;
                alu_op    = 2'b11;
            end
            
            7'b0000011: begin    //   for load  instruction
                alu_src    = 1'b1;
                mem_to_reg = 1'b1;
                reg_write  = 1'b1;
                alu_op     = 2'b00; 
            end
            
            7'b0100011: begin     //   for  Store instruction (SW)
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00; 
            end
            
            7'b1100011: begin  //  for branching operations
                branch = 1'b1;
                alu_op = 2'b01;   
            end
            
        
            7'b1101111: begin //   for jump  and  link (JAL) operations 
                reg_write = 1'b1;
            end

            7'b1100111: begin //   for jump and  link  register(JALR)
                reg_write = 1'b1; 
            end

            7'b0110111: begin   // load upper immediate
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end

            7'b0010111: begin // add upper immediate to PC 
                reg_write = 1'b1;
                alu_src   = 1'b1;
            end
        endcase
    end
endmodule


