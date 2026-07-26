`timescale 1ns / 1ps
module tb_register_file;
    reg         clk;
    reg         reg_write;
    reg  [4:0]  rs1;
    reg  [4:0]  rs2;
    reg  [4:0]  rd;
    reg  [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file uut (
        .clk(clk),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    always #5 clk = ~clk;
    initial begin
        // Initialize everything to 0
        clk = 0; reg_write = 0; rs1 = 0; rs2 = 0; rd = 0; write_data = 0;

        $display("Time | RegWrite | rd | write_data | rs1 | rs2 | read_data1 | read_data2");
        $display("-----------------------------------------------------------------------");
        $monitor("%4t |    %b     | %2d | %10d | %2d  | %2d  | %10d | %10d", 
                 $time, reg_write, rd, write_data, rs1, rs2, read_data1, read_data2);

        // Test 1: Write the number 42 into register x1
        #10;
        reg_write = 1; rd = 5'd1; write_data = 32'd42;

        // Test 2: Write the number 100 into register x2
        #10;
        reg_write = 1; rd = 5'd2; write_data = 32'd100;

        // Test 3: Try to write the number 999 into register x0 (Should be blocked!)
        #10;
        reg_write = 1; rd = 5'd0; write_data = 32'd999;

        // Test 4: Turn off write mode, and read x1 and x2 simultaneously
        #10;
        reg_write = 0; rs1 = 5'd1; rs2 = 5'd2;

        // Test 5: Read x0 and ensure it is still 0
        #10;
        rs1 = 5'd0; rs2 = 5'd0;

        #10 $finish;
    end
endmodule