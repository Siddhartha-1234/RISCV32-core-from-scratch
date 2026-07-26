module program_counter (
    input wire clk,
    input wire reset,
    input wire [31:0] next_pc,
    output reg [31:0] pc
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0; //PC to 0
        end else begin
            pc <= next_pc; //Update PC 
        end
    end
endmodule