// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`define RegistersNumWidth           5                           // 寄存器个数宽度为5位
`define InstAddressBusWidth         32                          // 实际指令地址宽度为32位
`define RegisterAddressBusWidth     `RegistersNumWidth          // 寄存器地址宽度为32位
`define InstByteWidth               32                          // 实际指令字节宽度为32位
`define RegistersByteWidth          32                          // 寄存器字节宽度为32位
`define MemAddressBusWidth          32                          // 内存地址宽度为32位
`define MemByteWidth                32                          // 内存字节宽度为32位
`define ALUFuncBusWidth             5                           // ALU功能宽度为5位

`define InstAddressBus      (`InstAddressBusWidth-1)        :0   // 实际指令地址描述符
`define InstByteBus         (`InstByteWidth-1)              :0   // 实际指令字节描述符
`define RegistersAddressBus (`RegisterAddressBusWidth-1)    :0   // 寄存器地址描述符
`define RegistersByteBus    (`RegistersByteWidth-1)         :0   // 寄存器字节描述符
`define MemAddressBus       (`MemAddressBusWidth-1)         :0   // 内存地址描述符
`define MemByteBus          (`MemByteWidth-1)               :0   // 数据字节描述符
`define ALUFuncBus          (`ALUFuncBusWidth-1)            :0   // ALU功能描述符

`define CPURstAddress `InstAddressBusWidth'h0

`define RstEnable       1'b0
`define RstDisable      1'b1
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ALUEnable       1'b1
`define ALUDisable      1'b0
`define ZeroWord        32'h0
`define ZeroReg         5'h0

`define HoldFlagBus     2:0        // 暂停流水总线
`define HoldNone        3'b000     // 不暂停流水总线
`define HoldPc          3'b001     // 暂停PC
`define HoldIf          3'b010     // 暂停IF
`define HoldId          3'b011     // 暂停ID

`define JumpEnable  1'b1
`define JumpDisable 1'b0

`define INST_OPCODEWidth    7
`define INST_REGBusWidth    `RegisterAddressBusWidth
`define INST_FUNC3Width     3
`define INST_FUNC7Width     7
`define INST_IMMBusWidth    `InstByteWidth
`define INST_SHAMTWidth     5

`define INST_NOP    32'h00000013

`define INST_OPCODEBus   (`INST_OPCODEWidth-1)  :0
`define INST_REGBus      (`INST_REGBusWidth-1)     :0
`define INST_FUNC3Bus    (`INST_FUNC3Width-1)   :0
`define INST_FUNC7Bus    (`INST_FUNC7Width-1)   :0
`define INST_IMMBus      (`INST_IMMBusWidth-1)     :0
`define INST_SHAMTBus    (`INST_SHAMTWidth-1)   :0


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

// R-type 指令
`define INST_FUNC3_ADD      3'b000
`define INST_FUNC3_SUB      3'b000
`define INST_FUNC3_XOR      3'b100
`define INST_FUNC3_OR       3'b110
`define INST_FUNC3_AND      3'b111
`define INST_FUNC3_SLL      3'b001
`define INST_FUNC3_SRL      3'b101
`define INST_FUNC3_SRA      3'b101
`define INST_FUNC3_SLT      3'b010
`define INST_FUNC3_SLTU     3'b011

`define INST_FUNC7_ADD      7'b000_0000
`define INST_FUNC7_SUB      7'b010_0000
`define INST_FUNC7_XOR      7'b000_0000
`define INST_FUNC7_OR       7'b000_0000
`define INST_FUNC7_AND      7'b000_0000
`define INST_FUNC7_SLL      7'b000_0000
`define INST_FUNC7_SRL      7'b000_0000
`define INST_FUNC7_SRA      7'b010_0000
`define INST_FUNC7_SLT      7'b000_0000
`define INST_FUNC7_SLTU     7'b000_0000

// I-type 指令
`define INST_FUNC3_ADDI     3'b000
`define INST_FUNC3_XORI     3'b100
`define INST_FUNC3_ORI      3'b110
`define INST_FUNC3_ANDI     3'b111
`define INST_FUNC3_SLLI     3'b001
`define INST_FUNC3_SRLI     3'b101
`define INST_FUNC3_SRAI     3'b101
`define INST_FUNC3_SLTI     3'b010
`define INST_FUNC3_SLTIU    3'b011


// ############################## ALU Begin #####################################

`define ALUFunc_ADD         5'b00000
`define ALUFunc_SUB         5'b00001
`define ALUFunc_XOR         5'b00010
`define ALUFunc_OR          5'b00011
`define ALUFunc_AND         5'b00100
`define ALUFunc_SLL         5'b00101
`define ALUFunc_SRL         5'b00110
`define ALUFunc_SRA         5'b00111
`define ALUFunc_SLT         5'b01000
`define ALUFunc_SLTU        5'b01001

// ############################## ALU End #######################################
