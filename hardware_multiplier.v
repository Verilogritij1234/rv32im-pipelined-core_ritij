module hardware_multiplier (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  funct3,
    output reg  [31:0] result
);
   
    wire signed [31:0] signed_a = a;
    wire signed [31:0] signed_b = b;
    
    //  for calculation  of full 64-bit results:
    wire signed [63:0] mult_ss = signed_a * signed_b;                // signed x signed
    wire        [63:0] mult_uu = a * b;                                  // unsigned x unsigned
    wire signed [63:0] mult_su = signed_a * $signed({1'b0, b});      // signed x unsigned

    always @(*) begin
        case (funct3)
            3'b000: result = mult_ss[31:0];       // MUL    (lower 32 bits, sign not  matter)
            3'b001: result = mult_ss[63:32];   // MULH   (upper 32 bits, ssigned x signed)
            3'b010: result = mult_su[63:32]; // MULHSU (upper 32 bits, signed x unsigned)
            3'b011: result = mult_uu[63:32]; // MULHU  (upper 32 bits, unsigned x Unsigned)
            default: result = 32'b0;
        endcase
    end
endmodule