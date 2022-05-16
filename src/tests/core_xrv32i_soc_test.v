// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`timescale 1ns/1ns

`include "../core/defines.v"

module xrv32i_soc_test();

reg clk								;
reg rst								;
wire led							;

xrv32i_soc xrv32i_soc_inst(
    .clk(clk),
    .rst(rst),

    .led_out(led)
);

wire[`RegistersByteBus] r27, r28, r29;
wire[1023:0] 	addr_in;
wire[4:0] 		master_id;
wire[31:0] 		addr_in_out;

assign r27 = xrv32i_soc_inst.xrv32i_core.regs_inst.regs[27];
assign r28 = xrv32i_soc_inst.xrv32i_core.regs_inst.regs[28];
assign r29 = xrv32i_soc_inst.xrv32i_core.regs_inst.regs[29];

assign addr_in = xrv32i_soc_test.xrv32i_soc_inst.xsimbus_inst.addr_in;
assign master_id = xrv32i_soc_test.xrv32i_soc_inst.xsimbus_inst.addr_in_inst.who;
assign addr_in_out = xrv32i_soc_test.xrv32i_soc_inst.xsimbus_inst.addr_in_out;

always begin
	clk = ~clk; #1
	if(clk) begin
		$display("r27: %d r28: %d r29: %d", r27, r28, r29);
		// $display("addr_in: %b master_id: %b addr_in_out: %b", addr_in, master_id, addr_in_out);
	end
end

always begin
	#60

	$finish;
end

initial begin
	$dumpfile("wave.vcd"); // 指定用作dumpfile的文件
	$dumpvars; // dump all vars

	$readmemb("rom_data_bin.dat", xrv32i_soc_inst.per_rom_inst.rom); // 读取rom_data.dat中的数据到insts数组中
	rst = `RstEnable; clk = 1'b0; #0; clk = 1'b1; #0;
	rst = `RstDisable;
end

endmodule

