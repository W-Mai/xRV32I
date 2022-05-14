// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xSimBus(
    input clk,
    input rst,

    input wire[31:0]        devices_in         , // 设备请求输入， 用{}聚合，每个设备一个bit，0表示不请求，1表示请求

    // 选中哪台设备了
    output reg[4:0]         master_id_out      , // 主设备ID
    output reg[4:0]         device_id_out      , // 从设备ID

    output reg[26:0]        device_addr_out    , // 从设备地址, 绑定所有设备的地址总线

    input  wire[31:0]       addr_in            , // 访问地址
    input  wire[31:0]       data_in            , // 总线数据输入
    output reg[31:0]        data_out           , // 总线数据输出

    output reg              hold_flag_out        // 是否持有总线
);

wire[4:0]  master_id;

// 总线仲裁
xencdr xencdr_inst(
    .val_in (devices_in),

    .val_out(master_id)
);


always @(posedge clk) begin
    if (rst == `RstEnable) begin
        data_out        <= `ZeroWord;
        device_addr_out <= 0;
        device_id_out   <= 0;
        master_id_out   <= 0;
        hold_flag_out   <= `HoldDisable;
    end else begin
        data_out        <= data_in;
        device_addr_out <= addr_in[26:0];
        device_id_out   <= addr_in[31:27];
        master_id_out   <= master_id;

        hold_flag_out   <= master_id == 31 ? `HoldDisable : `HoldEnable;
    end
end

endmodule
