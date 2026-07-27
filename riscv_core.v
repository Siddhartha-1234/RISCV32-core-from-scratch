`include "alu_control_unit.v"
`include "alu_32bit.v"
`include "control_unit.v"
`include "data_memory.v"
`include "instruction_decoder.v"
`include "program_counter.v"
`include "register_file.v"
`include "instruction_memory.v"
module riscv_core(
    input wire clk,
    input wire rst
);

    //PC and instruction wires
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire [31:0] instruction;

    //decoder wires
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_ext;

    //control unit wires
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    wire [1:0] alu_op;
    wire [3:0] alu_sel;
    wire pc_src;//AND gate output for PC source selection

    //Regiter file wires
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] final_write_data;

    //ALU wires
    wire [31:0] operand_b;
    wire [31:0] alu_result;
    wire zero, carry, overflow;

    //data memory wires
    wire [31:0] mem_read_data;

    //PC routing
    assign pc_plus_4 = pc + 32'd4;
    assign branch_target = pc + imm_ext;
    assign pc_src = branch & zero;
    assign next_pc = (pc_src) ? branch_target : pc_plus_4;

    // ALU Input Routing (Register or Immediate?)
    assign operand_b     = (alu_src) ? imm_ext : read_data2;

    //write back data routing (ALU or Memory?)
    assign final_write_data = (mem_to_reg) ? mem_read_data : alu_result;

    //Module Instantiations

    //fetch stage
    program_counter u_pc (
        .clk(clk),
        .reset(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory u_imem (
        .pc(pc),
        .instruction(instruction)
    );

    //decode stage
    instruction_decoder u_decoder (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm_ext(imm_ext)
    );

    control_unit u_control (
        .opcode(opcode),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    register_file u_regfile (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(final_write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    alu_control_unit u_alu_control (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7_bit(funct7[5]), // Bit 30 of the instruction decides Add vs Sub
        .alu_sel(alu_sel)
    );

    //execute stage
    alu_32bit u_alu (
        .a(read_data1),
        .b(operand_b),     // From ALUSrc MUX
        .alu_sel(alu_sel),
        .result(alu_result),
        .zero(zero),
        .carry_out(carry),
        .overflow(overflow)
    );

    //memory stage
    data_memory u_dmem (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .address(alu_result), // ALU calculates the memory address
        .write_data(read_data2), // Data to save comes straight from Register rs2
        .read_data(mem_read_data)
    );
endmodule