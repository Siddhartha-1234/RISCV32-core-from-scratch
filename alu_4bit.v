module alu_4bit (
    input  wire [3:0] a,          // Operand A
    input  wire [3:0] b,          // Operand B
    input  wire [3:0] alu_sel,    // Operation select
    output reg  [3:0] result,     // ALU result
    output wire       zero,       // 1 if result == 0
    output wire       carry_out,  // carry out of adder
    output wire       overflow    // signed overflow
);

    localparam ALU_ADD  = 4'b0000;   // a + b
    localparam ALU_SUB  = 4'b0001;   // a - b
    localparam ALU_AND  = 4'b0010;   // a & b
    localparam ALU_OR   = 4'b0011;   // a | b
    localparam ALU_XOR  = 4'b0100;   // a ^ b
    localparam ALU_NOR  = 4'b0101;   // ~(a | b)
    localparam ALU_SLL  = 4'b0110;   // a << b[1:0]
    localparam ALU_SRL  = 4'b0111;   // a >> b[1:0]  (logical)
    localparam ALU_SLT  = 4'b1000;   // (a <  b) signed   -> 1 or 0
    localparam ALU_SLTU = 4'b1001;   // (a <  b) unsigned -> 1 or 0
    localparam ALU_PASS = 4'b1010;   // result = a (for LUI-style pass-through)

    // 5-bit wide internal sum so we can grab carry_out cleanly
    reg  [4:0] sum_ext;

    always @(*) begin
        sum_ext = 5'd0;
        case (alu_sel)
            ALU_ADD:  begin
                          sum_ext = {1'b0, a} + {1'b0, b};
                          result  = sum_ext[3:0];
                      end
            ALU_SUB:  begin
                          sum_ext = {1'b0, a} + {1'b0, ~b} + 5'd1; // a + (~b) + 1
                          result  = sum_ext[3:0];
                      end
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_XOR:  result = a ^ b;
            ALU_NOR:  result = ~(a | b);
            ALU_SLL:  result = a << b[1:0];
            ALU_SRL:  result = a >> b[1:0];
            ALU_SLT:  result = ($signed(a) < $signed(b)) ? 4'd1 : 4'd0;
            ALU_SLTU: result = (a < b)                    ? 4'd1 : 4'd0;
            ALU_PASS: result = a;
            default:  result = 4'd0;
        endcase
    end

    assign zero      = (result == 4'd0);
    assign carry_out  = sum_ext[4];

    // when both operands have the same sign but the result's sign differs.
    assign overflow = ((alu_sel == ALU_ADD) && (a[3] == b[3]) && (result[3] != a[3])) ||
                       ((alu_sel == ALU_SUB) && (a[3] != b[3]) && (result[3] != a[3]));

endmodule
