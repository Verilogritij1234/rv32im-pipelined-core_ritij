#
# Copyright (c) 2026, Ritij Kaushal
# All rights reserved.
# 

module parameterized_RAM #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32 // accept the full 32-bit cpu address
)(
    input wire clk,
    input wire we,
    input wire [ADDR_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] mem [255:0];
    wire [7:0] word_index = address[9:2];

initial begin
    $readmemh("instruction_set.hex", mem); 
end
    always @(posedge clk) begin
        if (we) begin
            mem[word_index] <= data_in;  
            
        end
    end

    assign data_out = mem[word_index]; 
    always @(posedge clk) begin
        
        if (we && address == 32'h1000) begin
            $write("%c", data_in[7:0]); 
            
            // yosys:
            `ifdef SIMULATION
                $fflush();
            `endif
        end
    end 
endmodule
