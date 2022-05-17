// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xrv32i_soc(
    input wire clk,
    input wire rst,

    output wire led_out
);

wire[`XSimBusDeviceAddressBus]      bus_device_addr                 ;
wire                                bus_hold_flag_out               ;
wire[`MemByteBus]                   bus_data_out                    ;

wire[`XSimBusDeviceBus]             bus_master_id_out               ;
wire[`XSimBusDeviceBus]             bus_device_id_out               ;

// 各种外设的select_as_in
wire[`SelectModeBus]                rom_select_as_in                ;
wire[`SelectModeBus]                pc_select_as_in                 ;
wire[`SelectModeBus]                xrv32i_select_as_in             ;

// 各种外设的rw
wire                                pc_rw_out                       ;
wire                                xrv32i_rw_out                   ;

// 各种外设的req_out
wire                                xrv32i_core_req_out             ;

// 各种外设的addr_out
wire[`MemAddressBus]                pc_addr_out                     ;
wire[`MemAddressBus]                xrv32i_core_addr_out            ;

// 各种外设的data_out
wire[`MemByteBus]                   xrv32i_core_data_out            ;
wire[`MemByteBus]                   rom_data_out                    ;


xrv32i xrv32i_core(
    .clk(clk),
    .rst(rst),

    .inst_in         (bus_data_out              ), // 指令输入
    .inst_addr_out   (pc_addr_out               ), // 指令地址输出
    .pc_select_as_in (pc_select_as_in           ),
    .pc_rw_out       (pc_rw_out                 ),

    // 主设备总线请求
    .req_out         (xrv32i_core_req_out       ), // 主设备总线请求
    // 确定自身是否被选中以及选中的模式
    .select_as_in    (xrv32i_select_as_in       ),

    .addr_out        (xrv32i_core_addr_out      ),
    .data_in         (bus_data_out              ),
    .data_out        (xrv32i_core_data_out      ),

    .rw_out          (xrv32i_rw_out             ),

    .bus_hold_flag_in(bus_hold_flag_out         )
);

assign led_out = pc_rw_out;
assign bus_data = bus_data_out;

xSimBus xsimbus_inst(
    .clk(clk),
    .rst(rst),

    .devices_in         ({    // 设备请求输入， 用{}聚合，每个设备一个bit，0表示不请求，1表示请求
        `DeviceSelect       , // 31号设备
        `DeviceNotSel       , // 30号设备
        xrv32i_core_req_out , // 29号设备
        `DeviceNotSel       , // 28号设备
        `DeviceNotSel       , // 27号设备
        `DeviceNotSel       , // 26号设备
        `DeviceNotSel       , // 25号设备
        `DeviceNotSel       , // 24号设备
        `DeviceNotSel       , // 23号设备
        `DeviceNotSel       , // 22号设备
        `DeviceNotSel       , // 21号设备
        `DeviceNotSel       , // 20号设备
        `DeviceNotSel       , // 19号设备
        `DeviceNotSel       , // 18号设备
        `DeviceNotSel       , // 17号设备
        `DeviceNotSel       , // 16号设备
        `DeviceNotSel       , // 15号设备
        `DeviceNotSel       , // 14号设备
        `DeviceNotSel       , // 13号设备
        `DeviceNotSel       , // 12号设备
        `DeviceNotSel       , // 11号设备
        `DeviceNotSel       , // 10号设备
        `DeviceNotSel       , // 9号设备
        `DeviceNotSel       , // 8号设备
        `DeviceNotSel       , // 7号设备
        `DeviceNotSel       , // 6号设备
        `DeviceNotSel       , // 5号设备
        `DeviceNotSel       , // 4号设备
        `DeviceNotSel       , // 3号设备
        `DeviceNotSel       , // 2号设备
        `DeviceNotSel       , // 1号设备
        `DeviceNotSel         // 0号设备
    }), 

    // 选中哪台设备了
    .master_id_out      (bus_master_id_out), // 主设备ID
    .device_id_out      (bus_device_id_out), // 从设备ID

    .master_rw_in       ({    // 主设备读写标志位
        pc_rw_out           , // 31号设备
        `RWInoutR           , // 30号设备
        xrv32i_rw_out       , // 29号设备
        `RWInoutR           , // 28号设备
        `RWInoutR           , // 27号设备
        `RWInoutR           , // 26号设备
        `RWInoutR           , // 25号设备
        `RWInoutR           , // 24号设备
        `RWInoutR           , // 23号设备
        `RWInoutR           , // 22号设备
        `RWInoutR           , // 21号设备
        `RWInoutR           , // 20号设备
        `RWInoutR           , // 19号设备
        `RWInoutR           , // 18号设备
        `RWInoutR           , // 17号设备
        `RWInoutR           , // 16号设备
        `RWInoutR           , // 15号设备
        `RWInoutR           , // 14号设备
        `RWInoutR           , // 13号设备
        `RWInoutR           , // 12号设备
        `RWInoutR           , // 11号设备
        `RWInoutR           , // 10号设备
        `RWInoutR           , // 9号设备
        `RWInoutR           , // 8号设备
        `RWInoutR           , // 7号设备
        `RWInoutR           , // 6号设备
        `RWInoutR           , // 5号设备
        `RWInoutR           , // 4号设备
        `RWInoutR           , // 3号设备
        `RWInoutR           , // 2号设备
        `RWInoutR           , // 1号设备
        `RWInoutR             // 0号设备
    }), 
    .master_rw_out      (bus_master_rw_out), // 主设备读写标志

    .device_addr_out    (bus_device_addr), // 从设备地址, 绑定所有设备的地址总线

    .addr_in            ({    // 主设备读写外设地址总线
        pc_addr_out         , // 31号设备
        `CPURstAddress      , // 30号设备
        xrv32i_core_addr_out, // 29号设备
        `CPURstAddress      , // 28号设备
        `CPURstAddress      , // 27号设备
        `CPURstAddress      , // 26号设备
        `CPURstAddress      , // 25号设备
        `CPURstAddress      , // 24号设备
        `CPURstAddress      , // 23号设备
        `CPURstAddress      , // 22号设备
        `CPURstAddress      , // 21号设备
        `CPURstAddress      , // 20号设备
        `CPURstAddress      , // 19号设备
        `CPURstAddress      , // 18号设备
        `CPURstAddress      , // 17号设备
        `CPURstAddress      , // 16号设备
        `CPURstAddress      , // 15号设备
        `CPURstAddress      , // 14号设备
        `CPURstAddress      , // 13号设备
        `CPURstAddress      , // 12号设备
        `CPURstAddress      , // 11号设备
        `CPURstAddress      , // 10号设备
        `CPURstAddress      , // 9号设备
        `CPURstAddress      , // 8号设备
        `CPURstAddress      , // 7号设备
        `CPURstAddress      , // 6号设备
        `CPURstAddress      , // 5号设备
        `CPURstAddress      , // 4号设备
        `CPURstAddress      , // 3号设备
        `CPURstAddress      , // 2号设备
        `CPURstAddress      , // 1号设备
        `CPURstAddress        // 0号设备
    }),

    .data_in            ({    // 主从设备读写数据总线
        `ZeroWord           , // 31号设备
        `ZeroWord           , // 30号设备
        xrv32i_core_data_out, // 29号设备
        `ZeroWord           , // 28号设备
        `ZeroWord           , // 27号设备
        `ZeroWord           , // 26号设备
        `ZeroWord           , // 25号设备
        `ZeroWord           , // 24号设备
        `ZeroWord           , // 23号设备
        `ZeroWord           , // 22号设备
        `ZeroWord           , // 21号设备
        `ZeroWord           , // 20号设备
        `ZeroWord           , // 19号设备
        `ZeroWord           , // 18号设备
        `ZeroWord           , // 17号设备
        `ZeroWord           , // 16号设备
        `ZeroWord           , // 15号设备
        `ZeroWord           , // 14号设备
        `ZeroWord           , // 13号设备
        `ZeroWord           , // 12号设备
        `ZeroWord           , // 11号设备
        `ZeroWord           , // 10号设备
        `ZeroWord           , // 9号设备
        `ZeroWord           , // 8号设备
        `ZeroWord           , // 7号设备
        `ZeroWord           , // 6号设备
        `ZeroWord           , // 5号设备
        `ZeroWord           , // 4号设备
        `ZeroWord           , // 3号设备
        `ZeroWord           , // 2号设备
        `ZeroWord           , // 1号设备
        rom_data_out          // 0号设备
    }), // 总线数据输入
    .data_out           (bus_data_out     ), // 总线数据输入

    .hold_flag_out      (bus_hold_flag_out)  // 是否持有总线
);

bus_device_bluster_select bus_device_bluster_select_inst(
    .master_id_in       (bus_master_id_out),
    .device_id_in       (bus_device_id_out),

    .device0            (rom_select_as_in    ), // 地址范围: 0b00000_000_00_00_00 ~ 0b00000_111_FF_FF_FF (0x00000000 ~ 0x07FFFFFF)
    .device29           (xrv32i_select_as_in ), // 地址范围: 0b11101_000_00_00_00 ~ 0b11101_111_FF_FF_FF (0xE8000000 ~ 0xEFFFFFFF)
    .device31           (pc_select_as_in     )  // 地址范围: 0b11111_000_00_00_00 ~ 0b11111_111_FF_FF_FF (0xF8000000 ~ 0xFFFFFFFF)
);

per_rom per_rom_inst(
    .clk(clk),
    .rst(rst),

    // 确定自身是否被选中以及选中的模式
    .select_as_in   (rom_select_as_in),

    .addr_in        (bus_device_addr),
    .data_in        (bus_data_out   ),
    .data_out       (rom_data_out   ),

    .rw_in          (bus_master_rw_out)
);

endmodule
