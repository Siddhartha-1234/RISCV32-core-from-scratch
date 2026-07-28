module instruction_decoder(
    input [31:0] instruction,
    output [6:0] opcode,
    output [4:0] rd,
    output [2:0] funct3,
    output [4:0] rs1,
    output [4:0] rs2,
    output [6:0] funct7,
    output reg [31:0] imm_ext
);
    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign funct7 = instruction[31:25];

    always @(*) begin
        case (opcode)
            7'b0010011, 7'b0000011 : imm_ext = {{20{instruction[31]}}, instruction[31:20]};//immediate genration for I-type instructions represents imm[11:0]
            7'b0100011 : imm_ext = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };//S-type immediate represents imm[11:0](for store instructions)
            7'b1100011 : imm_ext = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };//B-type immediate represents imm[12:1]
            7'b0110111: imm_ext = { instruction[31:12], 12'b0 };// U-Type (LUI - Load Upper Immediate)
            7'b1101111: imm_ext = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0 };// J-type immediate represents imm[20:1]
            default : imm_ext = 32'b0;
        endcase
    end

endmodule