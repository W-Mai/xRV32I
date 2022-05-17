// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_pc_reg(
	input wire clk,
	input wire rst,

	input wire 					jump_flag_in 	, // 跳转标志
	input wire[`InstAddressBus] jump_addr_in 	, // 跳转地址
	
	output reg[`InstAddressBus] pc_out 			, // 当前程序计数器

	// 其他杂项
	input wire[`HoldFlagBus]	hold_flag_in	  // 暂停标志
);

always @(posedge clk) begin
	// 复位
	if (rst == `RstEnable) begin
		pc_out <= `CPURstAddress;
	// 跳转
	end else if (jump_flag_in == `JumpEnable) begin
		pc_out <= jump_addr_in;
	// 暂停
	end else if (hold_flag_in >= `HoldPc) begin
		pc_out <= pc_out;
	end else begin
		pc_out <= pc_out + (`InstByteWidth / 8);
	end
end

endmodule
