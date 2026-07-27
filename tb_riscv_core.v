`timescale 1ns / 1ps

module tb_riscv_core;
    reg clk;
    reg rst;

    riscv_core uut (
        .clk(clk),
        .rst(rst)
    );

    wire signed [31:0] view_alu_result = uut.alu_result;
    wire [31:0] view_x1= uut.u_regfile.registers[1];
    wire [31:0] view_x2 = uut.u_regfile.registers[2];
    wire [31:0] view_x3 = uut.u_regfile.registers[3];
    wire [31:0] view_x4 = uut.u_regfile.registers[4];
    wire [31:0] view_ram0 = uut.u_dmem.ram[0];

    always #5 clk = ~clk;

    initial begin
        $display("==========================================================================================");
        $display("Time | clk | Reset |    PC    | Instruction | ALU Result | x1 | x2 | x3 | x4 | RAM[0]");
        $display("==========================================================================================");
        $monitor("%4t |  %b  |   %b   | %08h |  %08h   | %10d | %2d | %2d | %2d | %2d |  %2d",
                 $time, clk, rst, uut.pc, uut.instruction,
                 view_alu_result,
                 view_x1,
                 view_x2,
                 view_x3,
                 view_x4,
                 view_ram0);

        clk = 0;
        rst = 1;
        #15 rst = 0;
        #100;
        $display("==========================================================================================");
        $display("SIMULATION COMPLETE.");
        $finish;
    end

endmodule