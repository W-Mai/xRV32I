// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xrv32i_soc(
    input clk,
    input rst
);

xrv32i xrv32i_core(
    .clk(clk),
    .rst(rst),

    .inst_in         (), // 指令输入

    .inst_addr_out   ()  // 指令地址输出
);

xSimBus xsimbus_inst(
    .clk(clk),
    .rst(rst),

    .devices_in         ({
        `DeviceSelect,  // 31号设备
        `DeviceNotSel,  // 30号设备
        `DeviceNotSel,  // 29号设备
        `DeviceNotSel,  // 28号设备
        `DeviceNotSel,  // 27号设备
        `DeviceNotSel,  // 26号设备
        `DeviceNotSel,  // 25号设备
        `DeviceNotSel,  // 24号设备
        `DeviceNotSel,  // 23号设备
        `DeviceNotSel,  // 22号设备
        `DeviceNotSel,  // 21号设备
        `DeviceNotSel,  // 20号设备
        `DeviceNotSel,  // 19号设备
        `DeviceNotSel,  // 18号设备
        `DeviceNotSel,  // 17号设备
        `DeviceNotSel,  // 16号设备
        `DeviceNotSel,  // 15号设备
        `DeviceNotSel,  // 14号设备
        `DeviceNotSel,  // 13号设备
        `DeviceNotSel,  // 12号设备
        `DeviceNotSel,  // 11号设备
        `DeviceNotSel,  // 10号设备
        `DeviceNotSel,  // 9号设备
        `DeviceNotSel,  // 8号设备
        `DeviceNotSel,  // 7号设备
        `DeviceNotSel,  // 6号设备
        `DeviceNotSel,  // 5号设备
        `DeviceNotSel,  // 4号设备
        `DeviceNotSel,  // 3号设备
        `DeviceNotSel,  // 2号设备
        `DeviceNotSel,  // 1号设备
        `DeviceNotSel   // 0号设备
    }), // 设备请求输入， 用{}聚合，每个设备一个bit，0表示不请求，1表示请求

    // 选中哪台设备了
    .master_id_out      (), // 主设备ID
    .device_id_out      (), // 从设备ID

    .device_addr_out    (), // 从设备地址, 绑定所有设备的地址总线

    .addr_in            (), // 访问地址
    .data_in            (), // 总线数据输入
    .data_out           (), // 总线数据输出

    .hold_flag_out      ()  // 是否持有总线
);


endmodule
