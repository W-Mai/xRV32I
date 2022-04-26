// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`define RegistersNumWidth           5                           // 寄存器个数宽度为5位
`define InstAddressBusWidth         32                          // 实际指令地址宽度为32位
`define RegisterAddressBusWidth     1 << `RegistersNumWidth     // 寄存器地址宽度为32位
`define InstByteWidth               32                          // 实际指令字节宽度为32位
`define RegistersByteWidth          32                          // 寄存器字节宽度为32位

`define InstAddressBus      (`InstAddressBusWidth-1)        :0   // 实际指令地址描述符
`define InstByteBus         (`InstByteWidth-1)              :0   // 实际指令字节描述符
`define RegistersAddressBus (`RegisterAddressBusWidth-1)    :0   // 寄存器地址描述符
`define RegistersByteBus    (`RegistersByteWidth-1)         :0   // 寄存器字节描述符


`define CPURstAddress `InstAddressBusWidth'h0

`define RstEnable       1'b0
`define RstDisable      1'b1
`define ZeroWord        32'h0
`define ZeroReg         5'h0

`define HoldFlagBus     2:0        // 暂停流水总线
`define HoldNone        3'b000     // 不暂停流水总线
`define HoldPc          3'b001     // 暂停PC
`define HoldIf          3'b010     // 暂停IF
`define HoldId          3'b011     // 暂停ID

`define JumpEnable  1'b1
`define JumpDisable 1'b0


`define INST_NOP    32'h00000013
