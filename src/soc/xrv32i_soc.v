// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xrv32i_soc(
    input wire clk,
    input wire rst
);

wire[`XSimBusDeviceAddressBus]      bus_device_addr                 ;
wire[`MemAddressBus]                bus_addr_in                     ;
wire[`MemByteBus]                   bus_data_in                     ;
wire[`MemByteBus]                   bus_data_out                    ;
wire                                bus_master_rw_inout             ;
wire                                bus_hold_flag_out               ;

wire[`XSimBusDeviceBus]             bus_master_id_out               ;
wire[`XSimBusDeviceBus]             bus_device_id_out               ;

// 各种外设的select_as_in
wire[`SelectModeBus]                rom_select_as_in                ;
wire[`SelectModeBus]                pc_select_as_in                 ;
wire[`SelectModeBus]                xrv32i_select_as_in             ;

// xrv32i_core
wire[`InstByteBus]                  xrv32i_core_inst_in             ;
wire[`MemAddressBus]                xrv32i_core_inst_addr_out       ;
wire                                xrv32i_core_req_out             ;
wire[`MemAddressBus]                xrv32i_core_addr_out            ;


xrv32i xrv32i_core(
    .clk(clk),
    .rst(rst),

    .inst_in         (xrv32i_core_inst_in       ), // 指令输入
    .inst_addr_out   (xrv32i_core_inst_addr_out ), // 指令地址输出
    .pc_select_as_in (pc_select_as_in           ),
    .pc_rw_inout     (bus_master_rw_inout       ),

    // 主设备总线请求
    .req_out         (xrv32i_core_req_out       ), // 主设备总线请求
    // 确定自身是否被选中以及选中的模式
    .select_as_in    (xrv32i_select_as_in       ),

    .addr_out        (bus_addr_in               ),
    .data_in         (bus_data_out              ),
    .data_out        (bus_data_in               ),

    // .rw_inout        (bus_master_rw_inout       ),

    .bus_hold_flag_in(bus_hold_flag_out         )
);

xSimBus xsimbus_inst(
    .clk(clk),
    .rst(rst),

    .devices_in         ({
        `DeviceSelect,  // 31号设备
        `DeviceNotSel,  // 30号设备
        xrv32i_core_req_out,  // 29号设备
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
    .master_id_out      (bus_master_id_out), // 主设备ID
    .device_id_out      (bus_device_id_out), // 从设备ID
    // .master_rw_inout    (bus_master_rw_inout), // 主设备读写标志

    .device_addr_out    (bus_device_addr), // 从设备地址, 绑定所有设备的地址总线

    .addr_in            (bus_addr_in ), // 访问地址
    .data_in            (bus_data_in ), // 总线数据输入
    .data_out           (bus_data_out), // 总线数据输出

    .hold_flag_out      (bus_hold_flag_out)  // 是否持有总线
);

reg[`SelectModeBus] bus_device_bluster_select_as_in[0:31] ;

assign rom_select_as_in = bus_device_bluster_select_as_in[0];
assign pc_select_as_in  = bus_device_bluster_select_as_in[31];

integer i;

always @(*) begin
    for (i = 0; i<32 ; i=i+1) begin
        bus_device_bluster_select_as_in[i] =    bus_master_id_out == i ? `SelectAsMaster : 
        										bus_device_id_out == i ? `SelectAsDevice : `SelectAsNone;
    end
end

per_rom per_rom_inst(
    .clk(clk),
    .rst(rst),

    // 确定自身是否被选中以及选中的模式
    .select_as_in   (rom_select_as_in),

    .addr_in        (bus_device_addr),
    .data_in        (bus_data_out   ),
    .data_out       (bus_data_in    ),

    .rw_inout       (bus_master_rw_inout)
);

endmodule
