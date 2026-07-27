`timescale 1ns / 1ps
module tb_alu_control_unit;
    reg  [1:0] alu_op;
    reg  [2:0] funct3;
    reg        funct7_bit;

    wire [3:0] alu_sel;
    alu_control_unit uut (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_bit(funct7_bit),
        .alu_sel(alu_sel)
    );
    reg [63:0] alu_op_name;
    always @(*) begin
        case (alu_sel)
            4'b0000: alu_op_name = "ALU_ADD ";
            4'b0001: alu_op_name = "ALU_SUB ";
            4'b0010: alu_op_name = "ALU_AND ";
            4'b0011: alu_op_name = "ALU_OR  ";
            4'b0100: alu_op_name = "ALU_XOR ";
            4'b0101: alu_op_name = "ALU_NOR ";
            4'b0110: alu_op_name = "ALU_SLL ";
            4'b0111: alu_op_name = "ALU_SRL ";
            4'b1000: alu_op_name = "ALU_SLT ";
            4'b1001: alu_op_name = "ALU_SLTU";
            default: alu_op_name = "UNKNOWN ";
        endcase
    end
    initial begin
        $display("==========================================================================");
        $display("Time | ALUOp | funct3 | funct7_bit || alu_sel (Bin) | Decoded Operation");
        $display("==========================================================================");

        // Use %0s to print the string variable
        $monitor("%4t |   %2b  |  %3b   |      %b     ||     %4b      | %0s",
                 $time, alu_op, funct3, funct7_bit, alu_sel, alu_op_name);

        // ---------------------------------------------------------
        // TEST 1: Load/Store Operations
        // ALUOp = 00. Should ignore funct fields and force ALU_ADD.
        // ---------------------------------------------------------
        alu_op = 2'b00; funct3 = 3'bxxx; funct7_bit = 1'bx;
        #10;

        // ---------------------------------------------------------
        // TEST 2: Branch Operations
        // ALUOp = 01. Should ignore funct fields and force ALU_SUB.
        // ---------------------------------------------------------
        alu_op = 2'b01; funct3 = 3'bxxx; funct7_bit = 1'bx;
        #10;

        // ---------------------------------------------------------
        // TEST 3: R-Type / I-Type (ALUOp = 10)
        // Testing various math and logic operations.
        // ---------------------------------------------------------

        // A. ADD (funct3 = 000, funct7_bit = 0)
        alu_op = 2'b10; funct3 = 3'b000; funct7_bit = 1'b0;
        #10;

        // B. SUB (funct3 = 000, funct7_bit = 1)
        alu_op = 2'b10; funct3 = 3'b000; funct7_bit = 1'b1;
        #10;

        // C. SLL - Shift Left Logical (funct3 = 001, funct7 doesn't matter)
        alu_op = 2'b10; funct3 = 3'b001; funct7_bit = 1'b0;
        #10;

        // D. SLT - Set Less Than (funct3 = 010, funct7 doesn't matter)
        alu_op = 2'b10; funct3 = 3'b010; funct7_bit = 1'b0;
        #10;

        // E. XOR (funct3 = 100, funct7 doesn't matter)
        alu_op = 2'b10; funct3 = 3'b100; funct7_bit = 1'b0;
        #10;

        // F. OR (funct3 = 110, funct7 doesn't matter)
        alu_op = 2'b10; funct3 = 3'b110; funct7_bit = 1'b0;
        #10;

        // G. AND (funct3 = 111, funct7 doesn't matter)
        alu_op = 2'b10; funct3 = 3'b111; funct7_bit = 1'b0;
        #10;

        $display("==========================================================================");
        $finish;
    end

endmodule