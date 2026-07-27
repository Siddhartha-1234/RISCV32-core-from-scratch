`timescale 1ns/1ps
module tb_data_memory;
    reg clk;
    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_write;
    reg mem_read;
    wire [31:0] read_data;

    data_memory uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .read_data(read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $display("==================================================================================");
        $display("Time | clk | mem_write | mem_read | Address (Dec) | write_data | read_data");
        $display("==================================================================================");
        $monitor("%4t |  %b  |     %b     |    %b     |      %3d      | %10d | %10d",
                 $time, clk, mem_write, mem_read, address, write_data, read_data);

        // Initialize
        clk = 0; mem_write = 0; mem_read = 0; address = 0; write_data = 0;
        #15;

        // ---------------------------------------------------------
        // TEST 1: STORE WORD (sw) - Write the number 500 to address 8
        // ---------------------------------------------------------
        mem_write  = 1;
        mem_read   = 0;
        address    = 32'd8;
        write_data = 32'd500;
        #10; // Wait 1 clock cycle for the write to happen

        // ---------------------------------------------------------
        // TEST 2: LOAD WORD (lw) - Read back the data from address 8
        // ---------------------------------------------------------
        mem_write  = 0;
        mem_read   = 1;
        address    = 32'd8;
        #10;

        // ---------------------------------------------------------
        // TEST 3: SAFETY CHECK - Try to write without mem_write enabled
        // ---------------------------------------------------------
        mem_write  = 0;        // Keeping write OFF!
        mem_read   = 0;
        address    = 32'd12;
        write_data = 32'd9999;
        #10;

        // ---------------------------------------------------------
        // TEST 4: LOAD WORD - Verify address 12 is still 0 (safety worked)
        // ---------------------------------------------------------
        mem_write  = 0;
        mem_read   = 1;
        address    = 32'd12;
        #10;

        $display("==================================================================================");
        $finish;
    end

endmodule