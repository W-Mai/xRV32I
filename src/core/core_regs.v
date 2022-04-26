// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_regs(
    input clk,
    input rst,

    // core_ex传入
    input wire                          we_in,          // 写寄存器使能
    input wire[`RegistersAddressBus]    write_addr_in,  // 写寄存器地址
    input wire[`RegistersByteBus]       write_data_in,  // 写寄存器数据

    // core_id传入
    input wire[`RegistersAddressBus]    read_addr1_in,  // 读寄存器地址1
    input wire[`RegistersAddressBus]    read_addr2_in,  // 读寄存器地址2

    // 传到core_id
    output reg[`RegistersByteBus]       read_data1_out, // 读寄存器1数据
    output reg[`RegistersByteBus]       read_data2_out  // 读寄存器2数据
);

reg[`RegistersByteBus] regs[0:`RegisterAddressBusWidth-1];

// 写寄存器
always @(posedge clk) begin
    if (rst == `RstDisable) begin
        if (we_in == `WriteEnable && write_addr_in != `ZeroReg) begin
            regs[write_addr_in] <= write_data_in;
        end
    end
end

// 读寄存器1
always @(*) begin
    if (read_addr1_in == `ZeroReg)
        read_data1_out = `ZeroWord;
    else if (read_addr1_in == write_addr_in && we_in == `WriteEnable)
    // 写寄存器地址和读寄存器1地址相同，且写寄存器使能，则直接把写寄存器数据读出
        read_data1_out = write_data_in;
    else
        read_data1_out = regs[read_addr1_in];
end

// 读寄存器2
always @(*) begin
    if (read_addr2_in == `ZeroReg)
        read_data2_out = `ZeroWord;
    else if (read_addr2_in == write_addr_in && we_in == `WriteEnable)
    // 写寄存器地址和读寄存器2地址相同，且写寄存器使能，则直接把写寄存器数据读出
        read_data2_out = write_data_in;
    else
        read_data2_out = regs[read_addr2_in];
end

endmodule
