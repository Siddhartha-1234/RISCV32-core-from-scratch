`timescale 1ns/1ps
`include "alu_4bit.v"

module alu_4bit_tb;

    reg  [3:0] a, b, alu_sel;
    wire [3:0] result;
    wire       zero, carry_out, overflow;

    integer errors = 0;
    integer tests  = 0;

    alu_4bit dut (
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .result(result),
        .zero(zero),
        .carry_out(carry_out),
        .overflow(overflow)
    );
    initial begin
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, alu_4bit_tb);
    end
    task check(
        input [3:0] in_a,
        input [3:0] in_b,
        input [3:0] sel,
        input [3:0] expected,
        input [8*32-1:0] name   // human-readable label for the test (up to 32 chars)
    );
        begin
            a = in_a; b = in_b; alu_sel = sel;
            #5; // allow combinational logic to settle
            tests = tests + 1;
            if (result !== expected) begin
                errors = errors + 1;
                $display("[FAIL] %0s : a=%b b=%b sel=%b -> got %b, expected %b",
                          name, in_a, in_b, sel, result, expected);
            end else begin
                $display("[PASS] %0s : a=%b b=%b sel=%b -> %b",
                          name, in_a, in_b, sel, result);
            end
        end
    endtask
//testcases created by AI for all the ALU operations
    initial begin
        $display("---------------------------------------------------");
        $display(" Starting 4-bit ALU self-checking testbench");
        $display("---------------------------------------------------");

        // ADD: 3 + 4 = 7
        check(4'd3, 4'd4, 4'b0000, 4'd7,  "ADD 3+4");
        // ADD with overflow wraparound: 15 + 2 = 17 -> wraps to 1 (mod 16)
        check(4'd15, 4'd2, 4'b0000, 4'd1, "ADD wraparound 15+2");

        // SUB: 9 - 5 = 4
        check(4'd9, 4'd5, 4'b0001, 4'd4,  "SUB 9-5");
        // SUB negative result: 2 - 5 = -3 -> two's complement 4-bit = 1101
        check(4'd2, 4'd5, 4'b0001, 4'b1101, "SUB negative 2-5");

        // AND
        check(4'b1100, 4'b1010, 4'b0010, 4'b1000, "AND");
        // OR
        check(4'b1100, 4'b1010, 4'b0011, 4'b1110, "OR");
        // XOR
        check(4'b1100, 4'b1010, 4'b0100, 4'b0110, "XOR");
        // NOR
        check(4'b1100, 4'b0011, 4'b0101, 4'b0000, "NOR");

        // SLL: 1 << 2 = 4
        check(4'd1, 4'd2, 4'b0110, 4'd4, "SLL 1<<2");
        // SRL: 8 >> 2 = 2
        check(4'd8, 4'd2, 4'b0111, 4'd2, "SRL 8>>2");

        // SLT signed: -1 < 1  -> true (1)
        check(4'b1111, 4'b0001, 4'b1000, 4'd1, "SLT signed -1<1");
        // SLT signed: 3 < 1 -> false (0)
        check(4'd3, 4'd1, 4'b1000, 4'd0, "SLT signed 3<1");

        // SLTU: unsigned 15 < 1 -> false (0), since 1111=15 unsigned
        check(4'b1111, 4'b0001, 4'b1001, 4'd0, "SLTU 15<1 (unsigned)");

        // PASS
        check(4'd6, 4'd0, 4'b1010, 4'd6, "PASS a");

        $display("---------------------------------------------------");
        if (errors == 0)
            $display(" ALL %0d TESTS PASSED", tests);
        else
            $display(" %0d / %0d TESTS FAILED", errors, tests);
        $display("---------------------------------------------------");

        $finish;
    end

endmodule
