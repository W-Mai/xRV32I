// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xSimBus(
    input clk,
    input rst,

    input wire[`XSimBusDeviceNum-1:0]       devices_in         , // 设备请求输入， 用{}聚合，每个设备一个bit，0表示不请求，1表示请求

    // 选中哪台设备了
    output reg[`XSimBusDeviceBus]           master_id_out      , // 主设备ID
    output reg[`XSimBusDeviceBus]           device_id_out      , // 从设备ID
    input  wire[`XSimBusRWInBus]            master_rw_in       , // 主设备读写标志
    output wire                             master_rw_out      , // 主设备读写标志

    output reg[`XSimBusDeviceAddressBus]    device_addr_out    , // 从设备地址, 绑定所有设备的地址总线

    input  wire[`XSimBusAddrBus]            addr_in            , // 访问地址
    input  wire[`XSimBusDataBus]            data_in            , // 总线数据输入
    output wire[`MemByteBus]                data_out           , // 总线数据输出

    output reg                              hold_flag_out        // 是否持有总线
);          

wire[4:0]               master_id;
wire[`MemAddressBus]    addr_in_out;

// 总线仲裁
xencdr xencdr_inst(
    .val_in (devices_in),

    .val_out(master_id)
);


xmuln #(`XSimBusDeviceWidth) rw_inst (
    .who    (master_id),

    .val_in (master_rw_in),
    .val_out(master_rw_out)
);

xmulnm #(`XSimBusDeviceWidth, `MemAddressBusWidth) addr_in_inst (
    .who    (master_id),

    .val_in (addr_in),
    .val_out(addr_in_out)
);

xmulnm #(`XSimBusDeviceWidth, `MemAddressBusWidth) data_in_inst (
    .who    (master_id),

    .val_in (data_in),
    .val_out(data_out)
);

always @(posedge clk) begin
    if (rst == `RstEnable) begin
        device_addr_out <= 0;
        device_id_out   <= 0;
        master_id_out   <= 0;
        hold_flag_out   <= `HoldDisable;
    end else begin
        device_addr_out <= addr_in_out[`XSimBusDeviceAddressBus];
        device_id_out   <= addr_in_out[`XSimBusDeviceNum-1:`XSimBusDeviceAddressWidth];
        master_id_out   <= master_id;

        hold_flag_out   <= master_id == 31 ? `HoldDisable : `HoldEnable;
    end
end

endmodule
