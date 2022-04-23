// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`timescale 1ns/1ns

`include "../core/pc_reg.v"
`include "../core/defines.v"

module pc_reg_test();
	reg clk,rst_n;
    reg jump_flag;
    reg [`InstAddressBus] jump_addr;

    wire [`InstAddressBus] pc;
    reg [`HoldFlagBus] hold_flag;

	pc_reg pc_reg_inst(
        .clk(clk),
        .rst(rst_n),

        .jump_flag_in(jump_flag),
        .jump_addr_in(jump_addr),	

        .pc_out(pc),	


        .hold_flag_in(hold_flag)
    );

	always begin
		rst_n = `RstEnable;
		clk = 0;
		#10 clk = 1;
		rst_n = `RstDisable;

		jump_flag = `JumpDisable;
		hold_flag = `HoldNone;

		#10 clk = 0;
		#10 clk = 1;
		#10 clk = 0;
		#10 clk = 1;
		#10 clk = 0;
		#10 clk = 1;

		jump_flag = `JumpEnable;
		jump_addr = `InstAddressBusWidth'h100;
		#10 clk = 0; jump_flag = `JumpDisable;
		#10 clk = 1;
		#10 clk = 0;
		#10 clk = 1;

		rst_n = `RstEnable;
		#10 clk = 0; rst_n = `RstDisable;
		#10 clk = 1;
		#10 clk = 0;
		#10 clk = 1;
	

		$finish;
	end

	initial begin
		#10 rst_n = 0;
		#10 rst_n = 1;

		$dumpfile("wave.vcd"); // 指定用作dumpfile的文件
		$dumpvars; // dump all vars
	end

endmodule

