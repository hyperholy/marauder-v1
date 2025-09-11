module alu (
    input logic [7:0] a, b,
    input logic [2:0] opcode,
    output logic zero, 
    output logic carry,
    output logic [7:0] c );
always_comb begin
    carry = '0;
    case(opcode)
        3'b000: begin
        c = a + b;
        carry = (c < a || c < b) ? 1 : 0;
        end
        3'b001:begin
        c = a - b;
        carry = (c > a || c > b) ? 1 : 0;
        end
        3'b010: c = a & b;
        3'b011: c = a | b;
        3'b100: c = ~(a | b);
        3'b101: c = a ^ b;
        3'b110: c = ~(a ^ b);
        3'b111: c = ~(a & b);
        default: c = 0;
    endcase
    zero = ~|c;
end
endmodule : alu

module xor_shift_reg(
    input logic update,
    output logic [7:0] out = 8'b00000001
);
logic xor_result;
always @(out) begin
    xor_result = (out[7] ^ out[5]) ^ out[3];
end
always_ff @(posedge update) begin
    out <= out << 1;
    out[0] <= xor_result; 
end
endmodule

module alu_regs (
    input logic [7:0] data_in,
    input logic [6:0] wrt_slct,
    input logic [2:0] rd_slct_a, rd_slct_b,
    input logic wrtnbl, clk,
    output logic [7:0] data_out_a, data_out_b
);
logic rng_update_a, rng_update_b;
logic [7:0] rng_out_a, rng_out_b;
logic [7:0] regs_a [0:7];
logic [7:0] regs_b [0:7];
xor_shift_reg rngA(
    .update(rng_update_a),
    .out(rng_out_a)
);
xor_shift_reg rngB(
    .update(rng_update_b),
    .out(rng_out_b)
);
always @(rd_slct_a, rd_slct_b) begin
    if (rd_slct_a == 3'b001)
        rng_update_a = ~rng_update_a;
    if (rd_slct_b == 3'b001)
        rng_update_b = ~rng_update_b;    
end
always_ff @(posedge clk) begin
    if (wrtnbl)//writing stuff
        if(wrt_slct[7:3] == 4'b0000)//a
            regs_a[wrt_slct[2:0]] <= data_in;
        else if(wrt_slct[7:3] == 4'b0001)//b
            regs_b[wrt_slct[2:0]] <= data_in;
    case (rd_slct_a)//reading stuff
        3'b000:  regs_a[0] <= '0;
        3'b001:  regs_a[1] <= rng_out_a;
    endcase
    case (rd_slct_b)
            3'b000:  regs_b[0] <= '0;
            3'b001:  regs_b[1] <= rng_out_b;
    endcase
end
    assign data_out_a = regs_a[rd_slct_a];
    assign data_out_b = regs_b[rd_slct_b];
endmodule : alu_regs