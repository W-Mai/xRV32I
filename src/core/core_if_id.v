// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_if_id(
	input wire clk,
	input wire rst,

    // 从core_ctrl取得的信号
    input wire[`HoldFlagBus]        hold_flag_in    , // 流水线暂停信号

    input wire[`InstAddressBus]     inst_addr_in    , // 指令地址
    input wire[`InstByteBus]        inst_in         , // 指令

    output wire[`InstAddressBus]    inst_addr_out   , // 指令地址
    output wire[`InstByteBus]       inst_out          // 指令
);

assign hold_flag = hold_flag_in >= `HoldIf;

gen_ff #(32) inst_addr_ff	(clk, rst, hold_flag,  `CPURstAddress, 	inst_addr_in, 	inst_addr_out);

gen_ff #(32) inst_ff		(clk, rst, hold_flag,  `INST_NOP, 		inst_in,		inst_out);


endmodule
