module tb;
    logic [7:0] x, y, out;
    logic [2:0] ops;
    logic cout, zero;

    alu alu_1 (
        .a(x), .b(y), .c(out),
        .opcode(ops), .carry(cout), .zero(zero)
    );
    initial begin
        x = 8'b00000110;
        y = 8'b00010101;
        ops = 3'b010;
        #10;
        $display("result iss: %d", out);  
        $display("carry?: %b", cout);
        $display("is zero?: %b", zero);
    end
endmodule : tb

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
    input logic read,
    output logic [7:0] out
);
logic [7:0] shift_reg = 8'b00000001;
always_ff @(posedge read) begin
    
end


endmodule

module alu_regs (
    input logic [7:0] data_in,
    input logic [6:0] wrt_slct,
    input logic [2:0] rd_slct_a, rd_slct_b,
    input logic wrtnbl, clk,
    output logic [7:0] data_out_a, data_out_b;
);
logic [7:0] regs_a [0:7];
assign regs_a[0] '0;//zreg
assign regs_a[1] = //xor_shift_reg ADD THIS!!!!!!!!
logic [7:0] regs_b [0:7];
assign regs_b[0] '0;
always_ff @(posedge clk) begin
    if (wrtnbl)
        if(wrt_slct[7:3] == 4'b0000)//a
            regs_a[wrt_slct[2:0]] <= data_in;
        else if(wrt_slct[7:3] == 4'b0001)//b
            regs_b[wrt_slct[2:0]] <= data_in;
    
    assign data_out_a = regs_a[rd_slct_a];
    assign data_out_b = regs_b[rd_slct_b];
end

endmodule : alu_reg