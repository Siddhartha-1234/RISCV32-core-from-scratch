`timescale 1ns / 1ps
module tb_main_control_unit;
    reg  [6:0] opcode;
    wire       branch;
    wire       mem_read;
    wire       mem_to_reg;
    wire [1:0] alu_op;
    wire       mem_write;
    wire       alu_src;
    wire       reg_write;
    control_unit uut (
        .opcode(opcode),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    reg [63:0] instr_name;
    always @(*) begin
        case (opcode)
            7'b0110011: instr_name = "R-TYPE  ";
            7'b0010011: instr_name = "I-MATH  ";
            7'b0000011: instr_name = "LOAD    ";
            7'b0100011: instr_name = "STORE   ";
            7'b1100011: instr_name = "BRANCH  ";
            default:    instr_name = "UNKNOWN ";
        endcase
    end

    // 4. Test Sequence
    initial begin
        $display("=====================================================================================");
        $display("Time | Instr Type | Opcode  || ALUSrc | MemToReg | RegWrite | MemRead | MemWrite | Branch | ALUOp");
        $display("=====================================================================================");
        $monitor("%4t |  %0s  | %7b ||   %b    |    %b     |    %b     |    %b    |    %b     |   %b    |  %2b", 
                 $time, instr_name, opcode, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op);

        // TEST 1: R-Type (e.g., ADD, SUB)
        opcode = 7'b0110011;
        #10;

        // TEST 2: I-Type Math (e.g., ADDI)
        opcode = 7'b0010011;
        #10;

        // TEST 3: Load (e.g., LW)
        opcode = 7'b0000011;
        #10;

        // TEST 4: Store (e.g., SW)
        opcode = 7'b0100011;
        #10;

        // TEST 5: Branch (e.g., BEQ)
        opcode = 7'b1100011;
        #10;

        // TEST 6: Invalid/Unknown Opcode (To verify our safety defaults)
        opcode = 7'b1111111;
        #10;

        $display("=====================================================================================");
        $finish;
    end

endmodule