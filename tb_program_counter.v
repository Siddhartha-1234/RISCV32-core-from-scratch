`timescale 1ns / 1ps
module tb_program_counter;
    reg         clk;
    reg         reset;
    reg  [31:0] next_pc;
    wire [31:0] pc;
    program_counter uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("program_counter.vcd");
        $dumpvars(0, tb_program_counter);
        clk = 0;
        reset = 1;
        next_pc = 32'h00000000;

        $display("Time | Reset |    PC Output | Next PC Input");
        $display("-------------------------------------------");
        $monitor("%4t |   %b   | %h | %h", $time, reset, pc, next_pc);
        #15 reset = 0;
        #10 next_pc = pc + 4;
        #10 next_pc = pc + 4;
        #10 next_pc = pc + 4;
        #10 next_pc = 32'h00001040;
        #10 next_pc = pc + 4;
        #10 next_pc = pc + 4;
        #10 $finish;
    end
endmodule