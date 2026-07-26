module instruction_memory #(
    parameter MEM_DEPTH = 64
)(
    input wire [31:0] pc,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:MEM_DEPTH-1];

    initial begin
        $readmemh("instruction.hex", memory);
    end

    assign instruction = (pc[31:2] < MEM_DEPTH) ? memory[pc[31:2]] : 32'h00000000;

endmodule