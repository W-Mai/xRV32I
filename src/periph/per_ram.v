// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module per_ram(
    input clk,
    input rst,

    // 确定自身是否被选中以及选中的模式
    input wire[`SelectModeBus]              select_as_in,

    input wire[`XSimBusDeviceAddressBus]    addr_in     ,
    input wire[`MemByteBus]                 data_in     ,
    output reg[`MemByteBus]                 data_out    ,

    input wire                              rw_in
);

reg [`MemByteBus] ram[0:63];

//wire[`XSimBusDeviceAddressBus] real_addr;
//assign real_addr = {2'b0, addr_in[`XSimBusDeviceAddressWidth-1:2]};

// 暂时就64个地址吧……没那么多空间
wire[5:0] real_addr;
assign real_addr = addr_in[7:2];

always @(*) begin
	if (rst == `RstEnable) begin
    	data_out = `ZeroWord;
    end else if (rw_in == `RWInoutR)
    	data_out = ram[real_addr];
    else
        data_out = `ZeroWord;
end

always @(posedge clk) begin
    if (select_as_in == `SelectAsDevice) begin
        if(rw_in == `RWInoutW)
            ram[real_addr] <= data_in;
    end
end

endmodule
