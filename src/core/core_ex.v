// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_ex(
    input rst,

    // 从core_id接收的信号
        // inst
    input wire[`InstByteBus]            inst_in                , // 指令内容
    input wire[`InstAddressBus]         inst_addr_in           , // 指令地址
        // regs
    input wire                          reg_we_in              , // 写通用寄存器标志
    input wire[`RegistersAddressBus]    reg_write_addr_in      , // 写通用寄存器地址
    input wire[`RegistersByteBus]       reg1_data_in           , // 通用寄存器1数据
    input wire[`RegistersByteBus]       reg2_data_in           , // 通用寄存器2数据
        // data
    input wire                          eval_en_in             , // 计算使能
    input wire[`MemByteBus]             opnum1_in              , // 操作数1
    input wire[`MemByteBus]             opnum2_in              , // 操作数2
    input wire[`ALUFuncBus]             func_in                , // ALU功能
    input wire[`MemByteBus]             eval_val_in            , // 计算结果
        // decoded signals 
    input wire[`INST_OPCODEBus]         opcode_in              , // 指令操作码
    input wire[`INST_FUNC3Bus]          func3_in               , // func3
    input wire[`INST_FUNC7Bus]          func7_in               , // func7
    input wire[`INST_REGBus]            rs1_in                 , // rs1
    input wire[`INST_REGBus]            rs2_in                 , // rs2
    input wire[`INST_REGBus]            rd_in                  , // rd
    input wire[`INST_IMMBus]            immI_in                , // 指令立即数I型
    input wire[`INST_IMMBus]            immS_in                , // 指令立即数S型
    input wire[`INST_IMMBus]            immB_in                , // 指令立即数B型
    input wire[`INST_IMMBus]            immU_in                , // 指令立即数U型
    input wire[`INST_IMMBus]            immJ_in                , // 指令立即数J型
    input wire[`INST_SHAMTBus]          shamt_in               , // 指令移位数,
    
    // 向core_regs发送的信号
    output wire                         reg_we_out             , // 是否要写通用寄存器
    output wire[`RegistersAddressBus]   reg_write_addr_out     , // 写通用寄存器地址
    output wire[`RegistersByteBus]      reg_write_data_out     , // 写寄存器数据
    // 向core_ctrl发送的信号
    output wire                         hold_flag_out          , // 是否要暂停
    output wire                         jump_flag_out          , // 是否要跳转
    output wire[`MemByteBus]            jump_addr_out            // 跳转地址

);

reg                         reg_we;
reg[`RegistersAddressBus]   reg_write_addr;
reg[`RegistersByteBus]      reg_write_data;
reg                         hold_flag;
reg                         jump_flag;
reg[`MemByteBus]            jump_addr;

assign reg_we_out           = reg_we;
assign reg_write_addr_out   = reg_write_addr;
assign reg_write_data_out   = reg_write_data;
assign hold_flag_out        = hold_flag;
assign jump_flag_out        = jump_flag;
assign jump_addr_out        = jump_addr;

always @(*) begin
    reg_we          = reg_we_in;
    reg_write_addr  = reg_write_addr_in;

    if (opcode_in == `INST_TYPE_I || opcode_in == `INST_TYPE_R) begin
       case (func_in)
           `ALUFunc_ADD, `ALUFunc_SUB, 
           `ALUFunc_XOR, `ALUFunc_OR , `ALUFunc_AND, 
           `ALUFunc_SLL, `ALUFunc_SRL, `ALUFunc_SRA, 
           `ALUFunc_SLT, `ALUFunc_SLTU :
                reg_write_data = eval_val_in;
           default: 
                reg_write_data = `ZeroWord;
       endcase 
    end else begin
        reg_write_data = `ZeroWord;
    end

    // core_ctrl默认值
    hold_flag   = `HoldNone;
    jump_flag   = `JumpDisable;
    jump_addr   = `CPURstAddress;

    case (opcode_in) 
        `INST_TYPE_IJ : begin
            case (func3_in)
                `INST_FUNC3_JALR : begin
                    jump_flag      = `JumpEnable;
                    jump_addr      = reg1_data_in + immI_in;

                    reg_write_data = eval_val_in;
                end
            endcase
        end

        `INST_TYPE_B : begin
            if (`ZeroWord   
                || (func3_in == `INST_FUNC3_BEQ && eval_val_in == `CMP_EQ)
                || (func3_in == `INST_FUNC3_BNE && eval_val_in != `CMP_EQ)
                || (func3_in == `INST_FUNC3_BLT && eval_val_in == `CMP_LT)
                || (func3_in == `INST_FUNC3_BGE && (eval_val_in == `CMP_GT || eval_val_in == `CMP_EQ))
                || (func3_in == `INST_FUNC3_BLTU && eval_val_in == `CMP_LT)
                || (func3_in == `INST_FUNC3_BGEU && (eval_val_in == `CMP_GT || eval_val_in == `CMP_EQ))
                ) begin
                jump_flag = `JumpEnable;
                jump_addr = inst_addr_in + immB_in;
            end
        end

        `INST_TYPE_U_lui, `INST_TYPE_U_auipc : begin
            reg_write_data = eval_val_in;
        end

        `INST_TYPE_J : begin
            jump_flag      = `JumpEnable;
            jump_addr      = inst_addr_in + immJ_in;

            reg_write_data = eval_val_in;
        end
    endcase
end

endmodule
