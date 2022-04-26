// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`define RegistersNumWidth           5                           // 寄存器个数宽度为5位
`define InstAddressBusWidth         32                          // 实际指令地址宽度为32位
`define RegisterAddressBusWidth     `RegistersNumWidth          // 寄存器地址宽度为32位
`define InstByteWidth               32                          // 实际指令字节宽度为32位
`define RegistersByteWidth          32                          // 寄存器字节宽度为32位

`define InstAddressBus      (`InstAddressBusWidth-1)        :0   // 实际指令地址描述符
`define InstByteBus         (`InstByteWidth-1)              :0   // 实际指令字节描述符
`define RegistersAddressBus (`RegisterAddressBusWidth-1)    :0   // 寄存器地址描述符
`define RegistersByteBus    (`RegistersByteWidth-1)         :0   // 寄存器字节描述符


`define CPURstAddress `InstAddressBusWidth'h0

`define RstEnable       1'b0
`define RstDisable      1'b1
`define WriteEnable     1'b1
`define WriteDisable    1'b0
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

`define INST_OPCODEBus   6:0
`define INST_REGBus      `RegistersAddressBus
`define INST_FUNC3Bus    2:0
`define INST_FUNC7Bus    6:0
`define INST_IMMBus      (`InstByteWidth-1):0
`define INST_SHAMTBus    4:0

// RV32I指令集 共计 10 + 9 + 5 + 1 + 2 + 2 + 6 + 3 + 6 + 1 + 1 + 1 = 47 条指令
`define INST_TYPE_R         7'b0110011      // 10 条 R-type 指令: add, sub, xor, or, and, sll, srl, sra, slt, sltu
`define INST_TYPE_I         7'b0010011      //  9 条 I-type 指令: addi, xori, ori, andi, slli, srli, srai, slti, sltiu
`define INST_TYPE_IL        7'b0010011      //  5 条 I-type 指令: lb, lh, lw, lbu, lhu
`define INST_TYPE_IJ        7'b1100111      //  1 条 I-type 指令: jalr
`define INST_TYPE_IE        7'b1110011      //  2 条 I-type 指令: ecall, ebreak
`define INST_TYPE_IF        7'b0001111      //  2 条 I-type 指令: fence, fence.i
`define INST_TYPE_IC        7'b1110011      //  6 条 I-type 指令: csrrw, csrrs, csrrc, csrrwi, csrrsi, csrrci
`define INST_TYPE_S         7'b0100011      //  3 条 S-type 指令: sb, sh, sw
`define INST_TYPE_B         7'b1100011      //  6 条 B-type 指令: beq, bne, blt, bge, bltu, bgeu
`define INST_TYPE_U_lui     7'b0110111      //  1 条 U-type 指令: lui
`define INST_TYPE_U_auipc   7'b0010111      //  1 条 U-type 指令: auipc
`define INST_TYPE_J         7'b1101111      //  1 条 J-type 指令: jal
