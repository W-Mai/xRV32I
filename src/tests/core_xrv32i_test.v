// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`timescale 1ns/1ns

`include "../core/defines.v"

module pc_reg_test();

	always begin

		$finish;
	end

	initial begin
		$dumpfile("wave.vcd"); // 指定用作dumpfile的文件
		$dumpvars; // dump all vars
	end

endmodule

