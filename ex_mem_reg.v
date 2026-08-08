#
# Copyright (c) 2026, Ritij Kaushal
# All rights reserved.
# 


module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,

       // inputs from EX stage
    
    input  wire        ex_reg_write,
    input  wire        ex_mem_write,
    input  wire        ex_mem_to_reg,
    
    input  wire        ex_branch_taken,
    input  wire [31:0] ex_branch_target,

    input  wire [31:0] ex_alu_result, 
    input  wire [31:0] ex_reg_b,      
    input  wire [4:0]  ex_rd,          

  // outputs to MEM stage

    output reg         mem_reg_write,
    output reg         mem_mem_write,
    output reg         mem_mem_to_reg,
    
    output reg         mem_branch_taken,
    output reg  [31:0] mem_branch_target,

    output reg  [31:0] mem_alu_result,
    output reg  [31:0] mem_store_data,
    output reg  [4:0]  mem_rd
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_reg_write     <= 1'b0;
            mem_mem_write     <= 1'b0;
            mem_mem_to_reg    <= 1'b0;
            mem_branch_taken  <= 1'b0;
            mem_branch_target <= 32'b0;
            mem_alu_result    <= 32'b0;
            mem_store_data    <= 32'b0;
            mem_rd            <= 5'b0;
        end 
        else begin
// assigments for data transfer: 
            mem_reg_write     <= ex_reg_write;
            mem_mem_write     <= ex_mem_write;
            mem_mem_to_reg    <= ex_mem_to_reg;
            mem_branch_taken  <= ex_branch_taken;
            mem_branch_target <= ex_branch_target;
            mem_alu_result    <= ex_alu_result; 
            mem_store_data    <= ex_reg_b;
            mem_rd            <= ex_rd;
        end
    end

endmodule
