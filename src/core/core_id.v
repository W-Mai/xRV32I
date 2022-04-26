// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_id(
    input rst;

    // 来自core_if_id的信号
    input wire[`InstByteBus]            inst_in,                // 指令内容
    input wire[`InstAddressBus]         inst_addr_in,           // 指令地址

    // 从core_regs获取的信号
    input wire[`RegistersByteBus]       read_reg1_data_in,      // 通用寄存器1输入数据
    input wire[`RegistersByteBus]       read_reg2_data_in,      // 通用寄存器2输入数据

    // 向core_regs写入的信号
    output reg[`RegistersAddressBus]    write_reg1_addr_out,    // 读通用寄存器1地址
    output reg[`RegistersAddressBus]    write_reg2_addr_out,    // 读通用寄存器2地址

    // 向core_ex模块写入的信号
        // inst
    output reg[`InstByteBus]            inst_out,               // 指令内容
    output reg[`InstAddressBus]         inst_addr_out,          // 指令地址
        // regs
    output reg                          reg_we_out,             // 写通用寄存器标志
    output reg[`RegistersAddressBus]    reg_write_addr_out,     // 写通用寄存器地址
    output reg[`RegistersByteBus]       reg1_data_out,          // 通用寄存器1数据
    output reg[`RegistersByteBus]       reg2_data_out           // 通用寄存器2数据
);




endmodule
