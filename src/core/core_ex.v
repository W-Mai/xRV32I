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
    output reg                          reg_we_out             , // 是否要写通用寄存器
    output reg[`RegistersAddressBus]    reg_write_addr_out     , // 写通用寄存器地址
    output reg[`RegistersByteBus]       reg_write_data_out     , // 写寄存器数据
    // 向core_ctrl发送的信号
    output reg                          hold_flag_out          , // 是否要暂停
    output reg                          jump_flag_out          , // 是否要跳转
    output reg[`MemByteBus]             jump_addr_out          , // 跳转地址

    // 内存操作相关信号
    output reg[`MemAddressBus]          mem_addr_out           , // 访存地址
    input wire[`MemByteBus]             mem_data_in            , // 内存数据输入
    output reg[`MemByteBus]             mem_data_out           , // 内存数据输出
    output reg                          mem_req_out            , // 是否要请求内存
    output reg                          mem_rw_out               // 是否要写内存
);

always @(*) begin
    reg_we_out          = reg_we_in;
    reg_write_addr_out  = reg_write_addr_in;

    if (opcode_in == `INST_TYPE_I || opcode_in == `INST_TYPE_R) begin
       case (func_in)
           `ALUFunc_ADD, `ALUFunc_SUB, 
           `ALUFunc_XOR, `ALUFunc_OR , `ALUFunc_AND, 
           `ALUFunc_SLL, `ALUFunc_SRL, `ALUFunc_SRA, 
           `ALUFunc_SLT, `ALUFunc_SLTU :
                reg_write_data_out = eval_val_in;
           default: 
                reg_write_data_out = `ZeroWord;
       endcase 
    end else begin
        reg_write_data_out = `ZeroWord;
    end

    // core_ctrl默认值
    hold_flag_out   = `HoldNone;
    jump_flag_out   = `JumpDisable;
    jump_addr_out   = `CPURstAddress;

    mem_addr_out    = `CPURstAddress;
    mem_req_out     = `DeviceNotSel;
    mem_data_out    = `ZeroWord;
    mem_rw_out      = `RWInoutR;

    case (opcode_in) 
        `INST_TYPE_IL : begin
            mem_addr_out = {eval_val_in[`MemAddressBusWidth-1:2], 2'b0};
            mem_req_out  = `DeviceSelect;

            case (func3_in)
                `INST_FUNC3_LB, `INST_FUNC3_LBU : 
                    case (eval_val_in[1:0])
                        2'b00: reg_write_data_out = {{24{ func3_in == `INST_FUNC3_LBU ? 1'b0 : mem_data_in[7] }}, mem_data_in[7:0]}  ;
                        2'b01: reg_write_data_out = {{24{ func3_in == `INST_FUNC3_LBU ? 1'b0 : mem_data_in[15]}}, mem_data_in[15:8]} ;
                        2'b10: reg_write_data_out = {{24{ func3_in == `INST_FUNC3_LBU ? 1'b0 : mem_data_in[23]}}, mem_data_in[23:16]};
                        2'b11: reg_write_data_out = {{24{ func3_in == `INST_FUNC3_LBU ? 1'b0 : mem_data_in[31]}}, mem_data_in[31:24]};
                    endcase
                `INST_FUNC3_LH, `INST_FUNC3_LHU :
                    case (eval_val_in[1:0])
                        2'b00, 2'b01: reg_write_data_out = {{16{ func3_in == `INST_FUNC3_LHU ? 1'b0 : mem_data_in[7] }}, mem_data_in[15:0]} ;
                        2'b10, 2'b11: reg_write_data_out = {{16{ func3_in == `INST_FUNC3_LHU ? 1'b0 : mem_data_in[23]}}, mem_data_in[31:16]};
                    endcase
                `INST_FUNC3_LW :
                    reg_write_data_out = mem_data_in;
            endcase
        end

        `INST_TYPE_IJ : begin
            case (func3_in)
                `INST_FUNC3_JALR : begin
                    jump_flag_out      = `JumpEnable;
                    jump_addr_out      = reg1_data_in + immI_in;

                    reg_write_data_out = eval_val_in;
                end
            endcase
        end

        `INST_TYPE_S : begin
            mem_addr_out = {eval_val_in[`MemAddressBusWidth-1:2], 2'b0};
            mem_req_out  = `DeviceSelect;
            mem_rw_out   = `RWInoutW;

            case (func3_in)
                `INST_FUNC3_SB : begin
                    case (eval_val_in[1:0])
                        2'b00: mem_data_out = {mem_data_in[31:8], reg2_data_in}                         ;
                        2'b01: mem_data_out = {mem_data_in[31:16], reg2_data_in[7:0], mem_data_in[7:0]} ;
                        2'b10: mem_data_out = {mem_data_in[31:24], reg2_data_in[7:0], mem_data_in[15:0]};
                        2'b11: mem_data_out = {reg2_data_in[7:0], mem_data_in[23:0]}                    ;
                    endcase
                end
                `INST_FUNC3_SH : begin
                    case (eval_val_in[1:0])
                        2'b00: mem_data_out = {mem_data_in[31:16], reg2_data_in[15:0]}                    ;
                        2'b01: mem_data_out = {mem_data_in[31:24], reg2_data_in[15:0], mem_data_in[7:0]}  ;
                        2'b10, 2'b11: mem_data_out = {reg2_data_in[15:0], mem_data_in[23:0]}              ;
                    endcase
                end
                `INST_FUNC3_SW : begin
                    mem_data_out = reg2_data_in;
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
                jump_flag_out = `JumpEnable;
                jump_addr_out = inst_addr_in + immB_in;
            end
        end

        `INST_TYPE_U_lui, `INST_TYPE_U_auipc : begin
            reg_write_data_out = eval_val_in;
        end

        `INST_TYPE_J : begin
            jump_flag_out      = `JumpEnable;
            jump_addr_out      = inst_addr_in + immJ_in;

            reg_write_data_out = eval_val_in;
        end
    endcase
end

endmodule
