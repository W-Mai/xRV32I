// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_id(
    input rst,

    // 来自core_if_id的信号
    input wire[`InstByteBus]            inst_in                 , // 指令内容
    input wire[`InstAddressBus]         inst_addr_in            , // 指令地址

    // 从core_regs获取的信号
    input wire[`RegistersByteBus]       read_reg1_data_in       , // 通用寄存器1输入数据
    input wire[`RegistersByteBus]       read_reg2_data_in       , // 通用寄存器2输入数据

    // 向core_regs写入的信号
    output reg[`RegistersAddressBus]    write_reg1_addr_out     , // 读通用寄存器1地址
    output reg[`RegistersAddressBus]    write_reg2_addr_out     , // 读通用寄存器2地址

    // 向core_ex模块写入的信号
        // inst
    output reg[`InstByteBus]            inst_out                , // 指令内容
    output reg[`InstAddressBus]         inst_addr_out           , // 指令地址
        // regs
    output reg                          reg_we_out              , // 写通用寄存器标志
    output reg[`RegistersAddressBus]    reg_write_addr_out      , // 写通用寄存器地址
    output reg[`RegistersByteBus]       reg1_data_out           , // 通用寄存器1数据
    output reg[`RegistersByteBus]       reg2_data_out           , // 通用寄存器2数据
        // data
    output reg                          eval_en                 , // 计算使能
    output reg[`MemByteBus]             opnum1_out              , // 操作数1
    output reg[`MemByteBus]             opnum2_out              , // 操作数2
    output reg[`ALUFuncBus]             func_out                , // ALU功能
        // decoded signals
    output reg[`INST_OPCODEBus]         opcode_out              , // 指令操作码
    output reg[`INST_FUNC3Bus]          func3_out               , // func3
    output reg[`INST_FUNC7Bus]          func7_out               , // func7
    output reg[`INST_REGBus]            rs1_out                 , // rs1
    output reg[`INST_REGBus]            rs2_out                 , // rs2
    output reg[`INST_REGBus]            rd_out                  , // rd
    output reg[`INST_IMMBus]            immI_out                , // 指令立即数I型
    output reg[`INST_IMMBus]            immS_out                , // 指令立即数S型
    output reg[`INST_IMMBus]            immB_out                , // 指令立即数B型
    output reg[`INST_IMMBus]            immU_out                , // 指令立即数U型
    output reg[`INST_IMMBus]            immJ_out                , // 指令立即数J型
    output reg[`INST_SHAMTBus]          shamt_out                 // 指令移位数
);

// 解码后的信号
wire[`INST_OPCODEBus]   opcode;                         // 指令操作码
wire[`INST_FUNC3Bus]    func3;                          // func3
wire[`INST_FUNC7Bus]    func7;                          // func7
wire[`INST_REGBus]      rs1, rs2, rd;                   // 指令操作数
wire[`INST_IMMBus]      immI, immS, immB, immU, immJ;   // 指令立即数
wire[`INST_SHAMTBus]    shamt;                          // 指令移位数

// 这一大坨对着手册写了半个多小时，看吐了🤮
assign opcode   =       inst_in[6:0];                                                           // [6:0]
assign func3    =       inst_in[14:12];                                                         // [14:12]
assign func7    =       inst_in[31:25];                                                         // [31:25]
assign rs1      =       inst_in[19:15];                                                         // [19:15]
assign rs2      =       inst_in[24:20];                                                         // [24:20]
assign rd       =       inst_in[11:7];                                                          // [11:7]
assign immI     =       {{20{inst_in[31]}}, inst_in[31:20]};                                    // [31:20]
assign immS     =       {{20{inst_in[31]}}, inst_in[31:25], inst_in[11:7]};                     // [31:25, 11:7]
assign immB     =       {{20{inst_in[12]}}, inst_in[11], inst_in[30:25], inst_in[11:8], 1'b0};  // [12, 11, 30:25, 11:8]
assign immU     =       inst_in[31:12];                                                         // [31:12]
assign immJ     =       {{12{inst_in[31]}}, inst_in[19:12], inst_in[20], inst_in[30:21], 1'b0}; // [31, 19:12, 20, 30:21]
assign shamt    =       {27'b0, inst_in[24:20]};                                                // [24:20]

// 一个巨大的组合逻辑电路用来解析指令
always @(*) begin
    inst_out            = inst_in;
    inst_addr_out       = inst_addr_in;
    reg1_data_out       = read_reg1_data_in;
    reg2_data_out       = read_reg2_data_in;
    opnum1_out          = `ZeroWord;
    opnum2_out          = `ZeroWord;

    // 输出解码后的信号
    opcode_out          = opcode;
    func3_out           = func3;
    func7_out           = func7;
    rs1_out             = rs1;
    rs2_out             = rs2;
    rd_out              = rd;
    immI_out            = immI;
    immS_out            = immS;
    immB_out            = immB;
    immU_out            = immU;
    immJ_out            = immJ;
    shamt_out           = shamt;

    // 判断指令操作码
    case(opcode)
        `INST_TYPE_R      : begin
            case (func3)
                `INST_FUNC3_ADD  : begin
                    reg_we_out          = `WriteEnable;
                    reg_write_addr_out  = rd;
                    write_reg1_addr_out = rs1;
                    write_reg2_addr_out = rs2;
                    
                    opnum1_out = rs1;
                    opnum2_out = rs2;
                end
                default : begin
                    reg_we_out          = `WriteDisable;
                    reg_write_addr_out  = `ZeroReg;
                    write_reg1_addr_out = `ZeroReg;
                    write_reg2_addr_out = `ZeroReg;
                end

            endcase
        end

        `INST_TYPE_I      : begin
            case (func3)
                `INST_FUNC3_ADDI  : begin
                    reg_we_out          = `WriteEnable;
                    reg_write_addr_out  = rd;
                    write_reg1_addr_out = rs1;
                    write_reg2_addr_out = `ZeroReg;
                    
                    opnum1_out = rs1;
                    opnum2_out = immI;
                end
                default : begin
                    reg_we_out          = `WriteDisable;
                    reg_write_addr_out  = `ZeroReg;
                    write_reg1_addr_out = `ZeroReg;
                    write_reg2_addr_out = `ZeroReg;
                end

            endcase
        end

        default : begin
            reg_we_out          = `WriteDisable;
            reg_write_addr_out  = `ZeroReg;
            write_reg1_addr_out = `ZeroReg;
            write_reg2_addr_out = `ZeroReg;
        end
    endcase
end


// 输出ALU控制信号
always @(*) begin
    case (opcode)
        `INST_TYPE_R, `INST_TYPE_I      : begin
            eval_en  = `ALUEnable;
            case (func3)
                `INST_FUNC3_ADD, `INST_FUNC3_ADDI, `INST_FUNC3_SUB : begin
                    func_out = func7 == `INST_FUNC7_ADD ? `ALUFunc_ADD : `ALUFunc_SUB;
                end


                default : begin
                    func_out = `ALUFunc_ADD;
                end
            endcase
        end
        default : begin
            eval_en  = `ALUDisable;
            func_out = `ALUFunc_ADD;
        end
    endcase
end

endmodule
