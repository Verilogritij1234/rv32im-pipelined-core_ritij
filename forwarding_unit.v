module forwarding_unit (
   
    input  wire [4:0] ex_rs1,
    input  wire [4:0] ex_rs2,

    
    input  wire       mem_reg_write,
    input  wire [4:0] mem_rd,


    input  wire       wb_reg_write,
    input  wire [4:0] wb_rd,

    
    output reg  [1:0] forward_a,
    output reg  [1:0] forward_b
);

    always @(*) begin
        // default:
        forward_a = 2'b00;
        forward_b = 2'b00;

        
// EX hazard:(priority 1)
   
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1)) begin
            forward_a = 2'b10;
        end
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2)) begin
            forward_b = 2'b10;
        end

       
        // MEM hazard: (priority 2)
        
        if (wb_reg_write && (wb_rd != 0) && (wb_rd == ex_rs1) && 
            !(mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1))) begin
            forward_a = 2'b01;
        end
        if (wb_reg_write && (wb_rd != 0) && (wb_rd == ex_rs2) && 
            !(mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2))) begin
            forward_b = 2'b01;
        end
    end

endmodule