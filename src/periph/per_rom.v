// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module per_rom(
    input clk,
    input rst,

    // 确定自身是否被选中以及选中的模式
    input wire[`SelectModeBus]              select_as_in,

    input wire[`XSimBusDeviceAddressBus]    addr_in     ,
    input wire[`MemByteBus]                 data_in     ,
    inout wire[`MemByteBus]                 data_out    ,

    inout wire                              rw_inout
);

reg [`MemByteBus] rom[0:63];

reg [`MemByteBus] data;

reg rw;

assign rw_inout = select_as_in == `SelectAsMaster ? rw : 1'bz;
assign data_out = rw_inout == `RWInoutR ? data : `MemByteWidth'bz;

always @(posedge clk) begin
    if (rst) begin
        data <= 0;
        if (select_as_in == `SelectAsMaster)
            rw <= `RWInoutR;
    end else begin
        if (select_as_in == `SelectAsDevice) begin
            if (rw_inout == `RWInoutR)
                data <= rom[addr_in>>2];
            else if(rw_inout == `RWInoutW)
                rom[addr_in>>2] <= data_in;
        end
    end
end

endmodule
