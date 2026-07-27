module data_memory #(
    parameter RAM_DEPTH = 64
)(
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);
    reg [31:0] ram [0:RAM_DEPTH-1];//create a 32-bit wide RAM with depth of 64 words
    //setting all the memory locations to 0 at the start
    integer i;
    initial begin
        for (i = 0; i < RAM_DEPTH; i = i + 1)
            ram[i] = 32'b0;
    end
    //write only happensa at positive edge of the clock
    always @(posedge clk) begin
        if (mem_write) begin
            ram[address[31:2]] <= write_data;
        end
    end
    //read operation when mem_read is 1
    always @(*) begin
        if (mem_read) begin
            read_data = ram[address[31:2]];
        end else begin
            read_data = 32'b0;
        end
    end
endmodule