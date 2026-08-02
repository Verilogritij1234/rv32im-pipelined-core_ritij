module program_counter 
#(parameter WIDTH = 32)
(
    input  wire             clk,
    input  wire             reset,         // asynchronous reset to start at address 0
    input  wire             enable,      //  1 = count normally  and for 0 = Stall or (freeze)
    input  wire             load_en,     // 1 for branching/jumping 0 for normal execution
    input  wire [WIDTH-1:0] load_addr,     // The target address if a branch/jump is taken
    output reg  [WIDTH-1:0] pc     // The current instruction Address
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= {WIDTH{1'b0}};         // reset PC to 0
        end 
        else if (load_en) begin
            pc <= load_addr;             // Jump/Branch to a new address
        end 
        else if (enable) begin           //  only increment if enabled by the hazard unit
            pc <= pc + 3'd4;                 // normal execution
        end
        
    end

endmodule