// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_id_ex(
    input clk,
    input rst,

    // 从core_ctrl取得的信号
    input wire hold_flag_in,

    // 从core_id接收的信号
        // inst
    input wire[`InstByteBus]           inst_in                , // 指令内容
    input wire[`InstAddressBus]        inst_addr_in           , // 指令地址
        // regs
    input wire                         reg_we_in              , // 写通用寄存器标志
    input wire[`RegistersAddressBus]   reg_write_addr_in      , // 写通用寄存器地址
    input wire[`RegistersByteBus]      reg1_data_in           , // 通用寄存器1数据
    input wire[`RegistersByteBus]      reg2_data_in           , // 通用寄存器2数据
        // data
    input wire                         eval_en_in             , // 计算使能
    input wire[`MemByteBus]            opnum1_in              , // 操作数1
    input wire[`MemByteBus]            opnum2_in              , // 操作数2
    input wire[`ALUFuncBus]            func_in                , // ALU功能
        // decoded signals
    input wire[`INST_OPCODEBus]        opcode_in              , // 指令操作码
    input wire[`INST_FUNC3Bus]         func3_in               , // func3
    input wire[`INST_FUNC7Bus]         func7_in               , // func7
    input wire[`INST_REGBus]           rs1_in                 , // rs1
    input wire[`INST_REGBus]           rs2_in                 , // rs2
    input wire[`INST_REGBus]           rd_in                  , // rd
    input wire[`INST_IMMBus]           immI_in                , // 指令立即数I型
    input wire[`INST_IMMBus]           immS_in                , // 指令立即数S型
    input wire[`INST_IMMBus]           immB_in                , // 指令立即数B型
    input wire[`INST_IMMBus]           immU_in                , // 指令立即数U型
    input wire[`INST_IMMBus]           immJ_in                , // 指令立即数J型
    input wire[`INST_SHAMTBus]         shamt_in               , // 指令移位数

////////////////////////////////////////////////////////////////////////////////////
    
    // 向core_id等后级发送的信号
    output wire[`InstByteBus]          inst_out               , // 指令内容
    output wire[`InstAddressBus]       inst_addr_out          , // 指令地址
        // regs
    output wire                        reg_we_out             , // 写通用寄存器标志
    output wire[`RegistersAddressBus]  reg_write_addr_out     , // 写通用寄存器地址
    output wire[`RegistersByteBus]     reg1_data_out          , // 通用寄存器1数据
    output wire[`RegistersByteBus]     reg2_data_out          , // 通用寄存器2数据
        // data
    output wire                        eval_en_out            , // 计算使能
    output wire[`MemByteBus]           opnum1_out             , // 操作数1
    output wire[`MemByteBus]           opnum2_out             , // 操作数2
    output wire[`ALUFuncBus]           func_out               , // ALU功能
        // decoded signals
    output wire[`INST_OPCODEBus]       opcode_out             , // 指令操作码
    output wire[`INST_FUNC3Bus]        func3_out              , // func3
    output wire[`INST_FUNC7Bus]        func7_out              , // func7
    output wire[`INST_REGBus]          rs1_out                , // rs1
    output wire[`INST_REGBus]          rs2_out                , // rs2
    output wire[`INST_REGBus]          rd_out                 , // rd
    output wire[`INST_IMMBus]          immI_out               , // 指令立即数I型
    output wire[`INST_IMMBus]          immS_out               , // 指令立即数S型
    output wire[`INST_IMMBus]          immB_out               , // 指令立即数B型
    output wire[`INST_IMMBus]          immU_out               , // 指令立即数U型
    output wire[`INST_IMMBus]          immJ_out               , // 指令立即数J型
    output wire[`INST_SHAMTBus]        shamt_out                // 指令移位数
);

gen_ff #(`InstByteWidth)        inst_ff_inst(clk, rst, hold_flag_in,       `INST_NOP,      inst_in,            inst_out            );
gen_ff #(`InstAddressBusWidth)  inst_ff_addr(clk, rst, hold_flag_in,       `CPURstAddress, inst_addr_in,       inst_addr_out       );
gen_ff #(1)                     reg_we_ff(clk, rst, hold_flag_in,          `WriteDisable,  reg_we_in,          reg_we_out          );
gen_ff #(`RegistersNumWidth)    reg_write_addr_ff(clk, rst, hold_flag_in,  `ZeroReg,       reg_write_addr_in,  reg_write_addr_out  );
gen_ff #(`RegistersByteWidth)   reg1_data_ff(clk, rst, hold_flag_in,       `ZeroWord,      reg1_data_in,       reg1_data_out       );
gen_ff #(`RegistersByteWidth)   reg2_data_ff(clk, rst, hold_flag_in,       `ZeroWord,      reg2_data_in,       reg2_data_out       );

// ALU相关，重置之后不计算，并且默认按照ADD指令输出即NOP
gen_ff #(1)                     eval_en_ff(clk, rst, hold_flag_in,         `ALUDisable,    eval_en_in,         eval_en_out         );
gen_ff #(`MemByteWidth)         opnum1_ff(clk, rst, hold_flag_in,          `ZeroWord,      opnum1_in,          opnum1_out          );
gen_ff #(`MemByteWidth)         opnum2_ff(clk, rst, hold_flag_in,          `ZeroWord,      opnum2_in,          opnum2_out          );
gen_ff #(`ALUFuncBusWidth)      func_ff(clk, rst, hold_flag_in,            `ALUFunc_ADD,   func_in,            func_out            );

// 重置后为NOP指令，以下输出NOP指令相关即可
gen_ff #(`INST_OPCODEWidth)     opcode_ff(clk, rst, hold_flag_in,      `INST_TYPE_I,           opcode_in,      opcode_out          );
gen_ff #(`INST_FUNC3Width)      func3_ff(clk, rst, hold_flag_in,       `INST_FUNC3_ADDI,       func3_in,       func3_out           );
gen_ff #(`INST_FUNC7Width)      func7_ff(clk, rst, hold_flag_in,       `INST_FUNC7Width'b0,    func7_in,       func7_out           );
gen_ff #(`INST_REGBusWidth)     rs1_ff(clk, rst, hold_flag_in,         `ZeroReg,               rs1_in,         rs1_out             );
gen_ff #(`INST_REGBusWidth)     rs2_ff(clk, rst, hold_flag_in,         `ZeroReg,               rs2_in,         rs2_out             );
gen_ff #(`INST_REGBusWidth)     rd_ff(clk, rst, hold_flag_in,          `ZeroReg,               rd_in,          rd_out              );
gen_ff #(`INST_IMMBusWidth)     immI_ff(clk, rst, hold_flag_in,        `ZeroWord,              immI_in,        immI_out            );
gen_ff #(`INST_IMMBusWidth)     immS_ff(clk, rst, hold_flag_in,        `ZeroWord,              immS_in,        immS_out            );
gen_ff #(`INST_IMMBusWidth)     immB_ff(clk, rst, hold_flag_in,        `ZeroWord,              immB_in,        immB_out            );
gen_ff #(`INST_IMMBusWidth)     immU_ff(clk, rst, hold_flag_in,        `ZeroWord,              immU_in,        immU_out            );
gen_ff #(`INST_IMMBusWidth)     immJ_ff(clk, rst, hold_flag_in,        `ZeroWord,              immJ_in,        immJ_out            );
gen_ff #(`INST_SHAMTWidth)      shamt_ff(clk, rst, hold_flag_in,       `INST_SHAMTWidth'b0,    shamt_in,       shamt_out           );

endmodule
