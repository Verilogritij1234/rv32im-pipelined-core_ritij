#
# Copyright (c) 2026, Ritij Kaushal
# All rights reserved.
# 

module id_ex_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        flush,    
    input  wire        stall,    

input  wire [6:0] id_opcode,
output reg  [6:0] ex_opcode,

       // control signals:
    input  wire        id_reg_write,
    input  wire        id_mem_write,
    input  wire        id_mem_to_reg,
    input  wire        id_branch,
    input  wire        id_alu_src,
    input  wire [1:0]  id_alu_op,

    // data and addresses:
    input  wire [31:0] id_pc,
    input  wire [31:0] id_reg_a,
    input  wire [31:0] id_reg_b,
    input  wire [31:0] id_imm,


    input  wire [4:0]  id_rs1,
    input  wire [4:0]  id_rs2,
    input  wire [4:0]  id_rd,
    input  wire [2:0]  id_funct3,
    input  wire [6:0]  id_funct7,

      // outputs to EX stage:
    output reg         ex_reg_write,
    output reg         ex_mem_write,
    output reg         ex_mem_to_reg,
    output reg         ex_branch,
    output reg         ex_alu_src,
    output reg  [1:0]  ex_alu_op,

    output reg  [31:0] ex_pc,
    output reg  [31:0] ex_reg_a,
    output reg  [31:0] ex_reg_b,
    output reg  [31:0] ex_imm,

    output reg  [4:0]  ex_rs1,
    output reg  [4:0]  ex_rs2,
    output reg  [4:0]  ex_rd,
    output reg  [2:0]  ex_funct3,
    output reg  [6:0]  ex_funct7
);
always @(posedge clk or posedge reset) begin
    if (reset) begin
           //  asynchronous  reset: 
        ex_opcode     <= 7'b0000000;
        ex_reg_write  <= 1'b0;
        ex_mem_write  <= 1'b0;
        ex_mem_to_reg <= 1'b0;
        ex_branch     <= 1'b0;
        ex_alu_src    <= 1'b0;
        ex_alu_op     <= 2'b00;
        ex_pc         <= 32'b0;
        ex_reg_a      <= 32'b0;
        ex_reg_b      <= 32'b0;
        ex_imm        <= 32'b0;
        ex_rs1        <= 5'b0;
        ex_rs2        <= 5'b0;
        ex_rd         <= 5'b0;
        ex_funct3     <= 3'b0;
        ex_funct7     <= 7'b0;
    end 
    else if (!stall) begin 
        if (flush) begin
         
            ex_opcode     <= 7'b0000000; 
            ex_reg_write  <= 1'b0;
            ex_mem_write  <= 1'b0;
            ex_mem_to_reg <= 1'b0;
            ex_branch     <= 1'b0;
            ex_alu_src    <= 1'b0;
            ex_alu_op     <= 2'b00;
            ex_pc         <= 32'b0;
            ex_reg_a      <= 32'b0;
            ex_reg_b      <= 32'b0;
            ex_imm        <= 32'b0;
            ex_rs1        <= 5'b0;
            ex_rs2        <= 5'b0;
            ex_rd         <= 5'b0;
            ex_funct3     <= 3'b0;
            ex_funct7     <= 7'b0;
        end
        else begin
            // for normal operation:
            ex_opcode     <= id_opcode;  
            ex_reg_write  <= id_reg_write;
            ex_mem_write  <= id_mem_write;
            ex_mem_to_reg <= id_mem_to_reg;
            ex_branch     <= id_branch;
            ex_alu_src    <= id_alu_src;
            ex_alu_op     <= id_alu_op;
            ex_pc         <= id_pc;
            ex_reg_a      <= id_reg_a;
            ex_reg_b      <= id_reg_b;
            ex_imm        <= id_imm;
            ex_rs1        <= id_rs1;
            ex_rs2        <= id_rs2;
            ex_rd         <= id_rd;
            ex_funct3     <= id_funct3;
            ex_funct7     <= id_funct7;
        end
    end
 
end

endmodule 
