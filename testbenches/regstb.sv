`timescale 1ns/1ps
`include "..\maraudersv\marauder.sv"

module regstb;
    logic [7:0] data_in;
    logic [6:0] wrt_slct;
    logic [2:0] rd_slct_a, rd_slct_b;
    logic wrtnbl, clk;
    logic [7:0] data_out_a, data_out_b;;
    

    alu_regs regs_1 (
        .*
    );

    always begin
        #5;
        clk = ~clk;
    end

    initial begin
        $display("REG A%b = %b", rd_slct_a, data_out_a);
        $display("REG B%b = %b", rd_slct_b, data_out_b);
        clk = '0;
        data_in = 8'b00000000;
        wrt_slct = 7'b00000;
        rd_slct_a = 3'b000;
        rd_slct_b = 3'b000;
        wrtnbl = '0;
        #10
        data_in = 8'h01;
        wrt_slct = 7'b0000110;
        wrtnbl = '1;
        @(posedge clk);
        
        #10
        rd_slct_a = 3'b110;
        rd_slct_b = 3'b110;
        #10

        $display("REG A%b = %b", rd_slct_a, data_out_a);
        $display("REG B%b = %b", rd_slct_b, data_out_b);
        $finish;
    end
endmodule