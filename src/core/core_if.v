// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_if(
	input wire[`InstAddressBus]     pc_addr_in      , // 程序计数器地址

    output wire[`InstAddressBus]    rom_addr_out    , // ROM地址
    input wire[`InstByteBus]        rom_data_in     , // ROM数据

    output wire[`InstAddressBus]    inst_addr_out   , // 指令地址
    output wire[`InstByteBus]       inst_out          // 指令
);

assign rom_addr_out = pc_addr_in;
assign inst_addr_out = pc_addr_in;
assign inst_out = rom_data_in;

endmodule
