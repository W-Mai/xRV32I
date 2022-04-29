// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`timescale 1ns/1ns

`include "../core/core_alu.v"
`include "../core/defines.v"

module pc_reg_test();
    reg eval_en;
	reg[`MemByteBus] opnum1;
	reg[`MemByteBus] opnum2;
	reg[`ALUFuncBus] alufunc;
	wire[`MemByteBus] aluout;

	core_alu core_alu_inst(
		.eval_en		(eval_en),
		.opnum1_in		(opnum1),
		.opnum2_in		(opnum2),
		.func_in		(alufunc),
		.res_out		(aluout)
    );

	always begin
		eval_en = `ALUEnable; #10
		opnum1 = `MemByteWidth'h01;	opnum2 = `MemByteWidth'h02;	alufunc = `ALUFunc_ADD; #1 $display("%b + %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h03;	opnum2 = `MemByteWidth'h04;	alufunc = `ALUFunc_SUB; #1 $display("%b - %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h05;	opnum2 = `MemByteWidth'h06;	alufunc = `ALUFunc_AND; #1 $display("%b & %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h07;	opnum2 = `MemByteWidth'h08;	alufunc = `ALUFunc_OR; 	#1 $display("%b | %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h09;	opnum2 = `MemByteWidth'h0a;	alufunc = `ALUFunc_XOR; #1 $display("%b ^ %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h0b;	opnum2 = `MemByteWidth'h0c;	alufunc = `ALUFunc_SLL; #1 $display("%b << %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h0d;	opnum2 = `MemByteWidth'h2;	alufunc = `ALUFunc_SRL; #1 $display("%b >> %b = %b", opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h0f;	opnum2 = `MemByteWidth'h1;	alufunc = `ALUFunc_SRA; #1 $display("%b >>> %b = %b", opnum1, opnum2, aluout);
		$display("");

		// 测试算数右移和逻辑右移
		$display("### >>> and >>");
		opnum1 = -`MemByteWidth'b1000101;	opnum2 = `MemByteWidth'h02;	alufunc = `ALUFunc_SRA;	#1 $display("%b >>> %b = %b", 	opnum1, opnum2, aluout);
		opnum1 = -`MemByteWidth'b1000101;	opnum2 = `MemByteWidth'h01;	alufunc = `ALUFunc_SRL;	#1 $display("%b >> %b = %b", 	opnum1, opnum2, aluout);
		$display("");

		// 测试比较运算
		$display("### < and U<");
		opnum1 = `MemByteWidth'h01;		opnum2 = `MemByteWidth'h02;	alufunc = `ALUFunc_SLT; 	#1 $display("%b < %b = %b", 	opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h01;		opnum2 = `MemByteWidth'h01;	alufunc = `ALUFunc_SLT; 	#1 $display("%b < %b = %b", 	opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h02;		opnum2 = `MemByteWidth'h01;	alufunc = `ALUFunc_SLT; 	#1 $display("%b < %b = %b", 	opnum1, opnum2, aluout);
		opnum1 = -`MemByteWidth'h60;	opnum2 = `MemByteWidth'h02;	alufunc = `ALUFunc_SLT; 	#1 $display("%b < %b = %b", 	opnum1, opnum2, aluout);
		opnum1 = -`MemByteWidth'h60;	opnum2 = `MemByteWidth'h60;	alufunc = `ALUFunc_SLT; 	#1 $display("%b < %b = %b", 	opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h61;		opnum2 = -`MemByteWidth'h60;alufunc = `ALUFunc_SLT; 	#1 $display("%b < %b = %b", 	opnum1, opnum2, aluout);
		$display("");
		opnum1 = `MemByteWidth'h01;		opnum2 = `MemByteWidth'h02;	alufunc = `ALUFunc_SLTU; 	#1 $display("%bU < %bU = %b", 	opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h01;		opnum2 = `MemByteWidth'h01;	alufunc = `ALUFunc_SLTU; 	#1 $display("%bU < %bU = %b", 	opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h02;		opnum2 = `MemByteWidth'h01;	alufunc = `ALUFunc_SLTU; 	#1 $display("%bU < %bU = %b", 	opnum1, opnum2, aluout);
		opnum1 = -`MemByteWidth'h60;	opnum2 = `MemByteWidth'h02;	alufunc = `ALUFunc_SLTU; 	#1 $display("%bU < %bU = %b", 	opnum1, opnum2, aluout);
		opnum1 = -`MemByteWidth'h60;	opnum2 = `MemByteWidth'h60;	alufunc = `ALUFunc_SLTU; 	#1 $display("%bU < %bU = %b", 	opnum1, opnum2, aluout);
		opnum1 = `MemByteWidth'h61;		opnum2 = -`MemByteWidth'h60;alufunc = `ALUFunc_SLTU; 	#1 $display("%bU < %bU = %b", 	opnum1, opnum2, aluout);

		$finish;
	end

	initial begin
		$dumpfile("wave.vcd"); // 指定用作dumpfile的文件
		$dumpvars; // dump all vars
	end

endmodule

