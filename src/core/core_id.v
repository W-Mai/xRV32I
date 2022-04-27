// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_id(
    input rst,

    // 来自core_if_id的信号
    input wire[`InstByteBus]            inst_in,                // 指令内容
    input wire[`InstAddressBus]         inst_addr_in,           // 指令地址

    // 从core_regs获取的信号
    input wire[`RegistersByteBus]       read_reg1_data_in,      // 通用寄存器1输入数据
    input wire[`RegistersByteBus]       read_reg2_data_in,      // 通用寄存器2输入数据

    // 向core_regs写入的信号
    output reg[`RegistersAddressBus]    write_reg1_addr_out,    // 读通用寄存器1地址
    output reg[`RegistersAddressBus]    write_reg2_addr_out,    // 读通用寄存器2地址

    // 向core_ex模块写入的信号
        // inst
    output reg[`InstByteBus]            inst_out,               // 指令内容
    output reg[`InstAddressBus]         inst_addr_out,          // 指令地址
        // regs
    output reg                          reg_we_out,             // 写通用寄存器标志
    output reg[`RegistersAddressBus]    reg_write_addr_out,     // 写通用寄存器地址
    output reg[`RegistersByteBus]       reg1_data_out,          // 通用寄存器1数据
    output reg[`RegistersByteBus]       reg2_data_out           // 通用寄存器2数据
);

wire[`INST_OPCODEBus]   opcode;                         // 指令操作码
wire[`INST_FUNC3Bus]    func3;                          // func3
wire[`INST_FUNC7Bus]    func7;                          // func7
wire[`INST_REGBus]      rs1, rs2, rd;                   // 指令操作数
wire[`INST_IMMBus]      immI, immS, immB, immU, immJ;   // 指令立即数
wire[`INST_SHAMTBus]    shamt;                          // 指令移位数

// 这一大坨对着手册写了半个多小时，看吐了🤮
assign opcode   =       inst_in[6:0];
assign func3    =       inst_in[14:12];
assign func7    =       inst_in[31:25];
assign rs1      =       inst_in[19:15];
assign rs2      =       inst_in[24:20];
assign rd       =       inst_in[11:7];
assign immI     =       {{20{inst_in[31]}}, inst_in[31:20]}; 
assign immS     =       {{20{inst_in[31]}}, inst_in[31:25], inst_in[11:7]};
assign immB     =       {{20{inst_in[12]}}, inst_in[11], inst_in[30:25], inst_in[11:8], 1'b0};
assign immU     =       inst_in[31:12];
assign immJ     =       {{12{inst_in[31]}}, inst_in[19:12], inst_in[20], inst_in[30:21], 1'b0};
assign shamt    =       {27'b0, inst_in[24:20]};

// 一个巨大的组合逻辑电路用来解析指令
always @(*) begin
    inst_out            = inst_in;
    inst_addr_out       = inst_addr_in;
    reg1_data_out       = read_reg1_data_in;
    reg2_data_out       = read_reg2_data_in;

    // 判断指令操作码
    case(opcode)
        `INST_TYPE_R      : begin
            casex (func3)
                
            endcase
        end

        `INST_TYPE_I      : begin
            
        end

        default:
            reg_we_out          = `WriteDisable;
            reg_write_addr_out  = `ZeroReg;
            write_reg1_addr_out = `ZeroReg,
            write_reg2_addr_out = `ZeroReg;,
    endcase
end

endmodule
