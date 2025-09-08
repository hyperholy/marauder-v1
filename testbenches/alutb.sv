`include "..\maraudersv\marauder.sv" 

module alutb;
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
endmodule : alutb