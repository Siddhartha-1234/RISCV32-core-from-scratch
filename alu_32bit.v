//same as for 4 bit for 32 bit ALU made for 32 bit operations in RISC-V architecture
module alu_32bit (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_sel,
    output reg  [31:0] result,
    output wire        zero,
    output wire        carry_out,
    output wire        overflow
);

    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_NOR  = 4'b0101;
    localparam ALU_SLL  = 4'b0110;
    localparam ALU_SRL  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_SLTU = 4'b1001;
    localparam ALU_PASS = 4'b1010;

    reg [32:0] sum_ext; // 33 bits wide now, to catch the 32-bit carry

    always @(*) begin
        sum_ext = 33'd0;
        case (alu_sel)
            ALU_ADD:  begin
                          sum_ext = {1'b0, a} + {1'b0, b};
                          result  = sum_ext[31:0];
                      end
            ALU_SUB:  begin
                          sum_ext = {1'b0, a} + {1'b0, ~b} + 33'd1;
                          result  = sum_ext[31:0];
                      end
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_XOR:  result = a ^ b;
            ALU_NOR:  result = ~(a | b);
            ALU_SLL:  result = a << b[4:0];   // RV32 shift amount is 5 bits (0-31)
            ALU_SRL:  result = a >> b[4:0];
            ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            ALU_SLTU: result = (a < b)                    ? 32'd1 : 32'd0;
            ALU_PASS: result = a;
            default:  result = 32'd0;
        endcase
    end

    assign zero      = (result == 32'd0);
    assign carry_out  = sum_ext[32];
    assign overflow = ((alu_sel == ALU_ADD) && (a[31] == b[31]) && (result[31] != a[31])) ||
                       ((alu_sel == ALU_SUB) && (a[31] != b[31]) && (result[31] != a[31]));

endmodule
