`timescale 1ns / 1ps

module tb_instruction_memory;

    reg  [31:0] pc;
    wire [31:0] instruction;

    instruction_memory uut (
        .pc(pc),
        .instruction(instruction)
    );

    initial begin
        $display("Time | PC Address | Word Index | Fetched Instruction");
        $display("------------------------------------------------------");

        $monitor("%4t | 0x%08h |      %2d    | 0x%08h", $time, pc, pc[31:2], instruction);
        pc = 32'd0;
        #10;
        pc = 32'd4;
        #10;
        pc = 32'd8;
        #10;
        pc = 32'd256;
        #10;
        $finish;
    end
endmodule