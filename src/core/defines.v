// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`define InstAddressBusWidth 32
`define InstByteWidth `InstAddressBusWidth/8

`define InstAddressBus (`InstAddressBusWidth-1):0

`define CPURstAddress `InstAddressBusWidth'h0

`define RstEnable 1'b0
`define RstDisable 1'b1
`define ZeroWord 32'h0
`define ZeroReg 5'h0

`define HoldFlagBus   2:0   // 暂停流水总线
`define HoldNone 3'b000     // 不暂停流水总线
`define HoldPc   3'b001     // 暂停PC
`define HoldIf   3'b010     // 暂停IF
`define HoldId   3'b011     // 暂停ID

`define JumpEnable 1'b1
`define JumpDisable 1'b0