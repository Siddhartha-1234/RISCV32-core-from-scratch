module register_file(
    input wire clk,
    input wire reg_write,//1 = write , 0 = no write
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,//destination register address
    input wire [31:0] write_data,//data to be written to the destination register
    output wire [31:0] read_data1,//data read from the first source register
    output wire [31:0] read_data2//data read from the second source register
);

    reg [31:0] registers [31:0];//32 registers of 32 bits each
    // If the requested register is 0, output 0. Otherwise, output the register's data
    assign read_data1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

    // Write data to the destination register on the rising edge of the clock
    always @(posedge clk) begin
        if (reg_write && (rd != 5'b00000)) begin
            registers[rd] <= write_data;
        end
    end
endmodule