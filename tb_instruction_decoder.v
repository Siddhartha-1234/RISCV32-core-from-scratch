`timescale 1ns / 1ps

module tb_instruction_decoder;

    reg  [31:0] instruction;
    wire [6:0]  opcode;
    wire [4:0]  rd;
    wire [2:0]  funct3;
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [6:0]  funct7;
    wire [31:0] imm_ext;
    wire signed [31:0] signed_imm;
    assign signed_imm = imm_ext;

    instruction_decoder uut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_ext(imm_ext)
    );
    initial begin
        // Set up the console output formatting
        $display("=====================================================================================================");
        $display("Time | Instr (Hex) | Opcode  | rs1 | rs2 | rd | f3 |   f7    | Imm (Hex)  | Imm (Dec)");
        $display("=====================================================================================================");

        $monitor("%4t |  %08h | %7b | %2d  | %2d  | %2d |  %b | %7b |  %08h  | %5d",
                 $time, instruction, opcode, rs1, rs2, rd, funct3, funct7, imm_ext, signed_imm);
        // TEST 1: R-Type (ADD x1, x2, x3)
        // Opcode: 0110011. Should fall to 'default' case (imm_ext = 0)
        instruction = 32'h003100B3;
        #10;
        // TEST 2: I-Type, Positive Immediate (ADDI x4, x5, 15)
        // Opcode: 0010011. Should sign-extend 15 into 0x0000000F
        instruction = 32'h00F28213;
        #10;
        // TEST 3: I-Type, Negative Immediate (ADDI x4, x5, -1)
        // Opcode: 0010011. Should sign-extend -1 into 0xFFFFFFFF
        instruction = 32'hFFF28213;
        #10;
        // TEST 4: S-Type (SW x6, 12(x7))
        // Opcode: 0100011. The immediate "12" is split inside the instruction!
        instruction = 32'h0063A623;
        #10;
        // TEST 5: B-Type (BEQ x8, x9, -16)
        // Opcode: 1100011. Immediate bits are scrambled and end in a hardcoded 0.
        instruction = 32'hFE9408E3;
        #10;
        // End simulation
        $display("=====================================================================================================");
        $finish;
    end

endmodule