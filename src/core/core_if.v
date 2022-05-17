// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_if(
    input rst,

	input wire[`InstAddressBus]     pc_addr_in      , // 程序计数器地址

    input wire[`SelectModeBus]      select_as_in    , 
    output wire[`InstAddressBus]    rom_addr_out    , // ROM地址
    input wire[`InstByteBus]        rom_data_in     , // ROM数据
    output reg                      pc_rw_out       ,

    // 从core_ctrl输入的信号
    input wire[`HoldFlagBus]        hold_flag_in    , // 流水线暂停标志

    output wire[`InstAddressBus]    inst_addr_out   , // 指令地址
    output wire[`InstByteBus]       inst_out          // 指令
);

assign rom_addr_out = pc_addr_in;
assign inst_addr_out = pc_addr_in;
assign inst_out = (hold_flag_in >= `HoldPc || rst == `RstEnable) ? `INST_NOP : rom_data_in;

always @(*)
    if (select_as_in == `SelectAsMaster) begin
        pc_rw_out = `RWInoutR;
    end else
    	pc_rw_out = 'bz;
endmodule
