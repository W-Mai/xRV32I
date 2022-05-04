// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`timescale 1ns/1ns

`include "../core/defines.v"
`include "../core/xrv32i.v"

module pc_reg_test();

reg clk								;
reg rst								;
wire[`InstByteBus]    inst      	;
wire[`MemAddressBus]  inst_addr		;

reg[`InstByteBus]	  insts[0:3]     ;

assign inst = insts[inst_addr>>2];

xrv32i xrv32i_inst(
    .clk(clk),
    .rst(rst),

    .inst_in         (inst), // 指令输入
    .inst_addr_out   (inst_addr)  // 指令地址输出
);

wire[`RegistersByteBus] r27, r28, r29;

assign r27 = xrv32i_inst.regs_inst.regs[27];
assign r28 = xrv32i_inst.regs_inst.regs[28];
assign r29 = xrv32i_inst.regs_inst.regs[29];

	always begin
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);
		clk = 1'b0; #10; clk = 1'b1; #10 $display("r27: %d r28: %d r29: %d", r27, r28, r29);


		$finish;
	end

	initial begin
        rst = `RstEnable; #10; clk = 1'b0; #10; clk = 1'b1; #10;
        rst = `RstDisable;

		$dumpfile("wave.vcd"); // 指定用作dumpfile的文件
		$dumpvars; // dump all vars

        $readmemb("rom_data_bin.dat", insts); // 读取rom_data.dat中的数据到insts数组中
	end

endmodule

