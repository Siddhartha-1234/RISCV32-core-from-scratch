module alu_control_unit (
    input wire [1:0] alu_op,
    input wire [2:0] funct3,
    input wire funct7_bit,
    output reg [3:0] alu_sel
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_sel = 4'b0000;// ALUOp = 00: Load/Store (Force ADD for memory address calculation)
            2'b01: alu_sel = 4'b0001;// ALUOp = 01: Branch (Force SUB for comparison)
            2'b10: begin // ALUOp = 10: R and I-type instructions
                case (funct3)
                    3'b000: begin
                        if (funct7_bit) begin
                            alu_sel = 4'b0001; // SUB
                        end else begin
                            alu_sel = 4'b0000; // ADD
                        end
                    end
                    3'b001: alu_sel = 4'b0110; // SLL
                    3'b010: alu_sel = 4'b1000; // SLT
                    3'b011: alu_sel = 4'b1001; // SLTU
                    3'b100: alu_sel = 4'b0100; // XOR
                    3'b101: alu_sel = funct7_bit ? 4'b0111 : 4'b0111; // SRL/SRA (SRA not implemented, using SRL)
                    3'b110: alu_sel = 4'b0011; // OR
                    3'b111: alu_sel = 4'b0010; // AND
                    default: alu_sel = 4'b0000;
                endcase
            end
            2'b11: begin // ALUOp = 11: I-type instructions
                case (funct3)
                    3'b000: alu_sel = 4'b0000; // ADDI
                    3'b010: alu_sel = 4'b1000; // SLTI
                    3'b011: alu_sel = 4'b1001; // SLTIU
                    3'b100: alu_sel = 4'b0100; // XORI
                    3'b110: alu_sel = 4'b0011; // ORI
                    3'b111: alu_sel = 4'b0010; // ANDI
                    default: alu_sel = 4'b0000;
                endcase
            end
            default: alu_sel = 4'b0000; // Default case to avoid latches
        endcase
    end
endmodule