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

// assign master_rw_inout = master_rw;

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
    .who    (master_rw_out == `RWInoutW ? master_id : device_id_out),

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

module bus_device_bluster_select(
    input wire[`XSimBusDeviceBus] master_id_in  ,
    input wire[`XSimBusDeviceBus] device_id_in  ,

	output wire[`SelectModeBus] device0         ,
    output wire[`SelectModeBus] device1         ,
    output wire[`SelectModeBus] device2         ,
    output wire[`SelectModeBus] device3         ,
    output wire[`SelectModeBus] device4         ,
    output wire[`SelectModeBus] device5         ,
    output wire[`SelectModeBus] device6         ,
    output wire[`SelectModeBus] device7         ,
    output wire[`SelectModeBus] device8         ,
    output wire[`SelectModeBus] device9         ,
    output wire[`SelectModeBus] device10        ,
    output wire[`SelectModeBus] device11        ,
    output wire[`SelectModeBus] device12        ,
    output wire[`SelectModeBus] device13        ,
    output wire[`SelectModeBus] device14        ,
    output wire[`SelectModeBus] device15        ,
    output wire[`SelectModeBus] device16        ,
    output wire[`SelectModeBus] device17        ,
    output wire[`SelectModeBus] device18        ,
    output wire[`SelectModeBus] device19        ,
    output wire[`SelectModeBus] device20        ,
    output wire[`SelectModeBus] device21        ,
    output wire[`SelectModeBus] device22        ,
    output wire[`SelectModeBus] device23        ,
    output wire[`SelectModeBus] device24        ,
    output wire[`SelectModeBus] device25        ,
    output wire[`SelectModeBus] device26        ,
    output wire[`SelectModeBus] device27        ,
    output wire[`SelectModeBus] device28        ,
    output wire[`SelectModeBus] device29        ,
    output wire[`SelectModeBus] device30        ,
    output wire[`SelectModeBus] device31        
);

reg [`SelectModeBus] bus_device_bluster_select_as_in[0:31] ;

assign device0  = bus_device_bluster_select_as_in[0]    ;
assign device1  = bus_device_bluster_select_as_in[1]    ;
assign device2  = bus_device_bluster_select_as_in[2]    ;
assign device3  = bus_device_bluster_select_as_in[3]    ;
assign device4  = bus_device_bluster_select_as_in[4]    ;
assign device5  = bus_device_bluster_select_as_in[5]    ;
assign device6  = bus_device_bluster_select_as_in[6]    ;
assign device7  = bus_device_bluster_select_as_in[7]    ;
assign device8  = bus_device_bluster_select_as_in[8]    ;
assign device9  = bus_device_bluster_select_as_in[9]    ;
assign device10 = bus_device_bluster_select_as_in[10]   ;
assign device11 = bus_device_bluster_select_as_in[11]   ;
assign device12 = bus_device_bluster_select_as_in[12]   ;
assign device13 = bus_device_bluster_select_as_in[13]   ;
assign device14 = bus_device_bluster_select_as_in[14]   ;
assign device15 = bus_device_bluster_select_as_in[15]   ;
assign device16 = bus_device_bluster_select_as_in[16]   ;
assign device17 = bus_device_bluster_select_as_in[17]   ;
assign device18 = bus_device_bluster_select_as_in[18]   ;
assign device19 = bus_device_bluster_select_as_in[19]   ;
assign device20 = bus_device_bluster_select_as_in[20]   ;
assign device21 = bus_device_bluster_select_as_in[21]   ;
assign device22 = bus_device_bluster_select_as_in[22]   ;
assign device23 = bus_device_bluster_select_as_in[23]   ;
assign device24 = bus_device_bluster_select_as_in[24]   ;
assign device25 = bus_device_bluster_select_as_in[25]   ;
assign device26 = bus_device_bluster_select_as_in[26]   ;
assign device27 = bus_device_bluster_select_as_in[27]   ;
assign device28 = bus_device_bluster_select_as_in[28]   ;
assign device29 = bus_device_bluster_select_as_in[29]   ;
assign device30 = bus_device_bluster_select_as_in[30]   ;
assign device31 = bus_device_bluster_select_as_in[31]   ;

integer i;
always @(*) begin
    for (i = 0; i<32 ; i=i+1) begin
        bus_device_bluster_select_as_in[i] = master_id_in == i ? `SelectAsMaster : 
        							         device_id_in == i ? `SelectAsDevice : 
                                             `SelectAsNone;
    end
end

endmodule