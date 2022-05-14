// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xrv32i(
    input clk,
    input rst,

    input  wire[`InstByteBus]    inst_in         , // 指令输入

    output wire[`MemAddressBus]  inst_addr_out     // 指令地址输出
);

wire[`InstAddressBus] pc_reg_pc_out;

// 来自core_ctrl的输出信号
wire                 ctrl_jump_flag_out     ;
wire[`MemAddressBus] ctrl_jump_addr_out     ;
wire                 ctrl_hold_flag_out     ;

core_pc_reg pc_reg_inst(
	.clk(clk),
	.rst(rst),

	.jump_flag_in 	(ctrl_jump_flag_out)    , // 跳转标志
	.jump_addr_in 	(ctrl_jump_addr_out)    , // 跳转地址
	
	.pc_out 		(pc_reg_pc_out )        , // 当前程序计数器

	// 其他杂项
	.hold_flag_in	(ctrl_hold_flag_out)      // 暂停标志
);

wire[`InstAddressBus]   if_inst_addr_out    ;
wire[`InstByteBus]      if_inst_out         ;

core_if if_inst(
	.pc_addr_in      (pc_reg_pc_out)        , // 程序计数器地址

    .rom_addr_out    (inst_addr_out)        , // ROM地址
    .rom_data_in     (inst_in      )        , // ROM数据

    .inst_addr_out   (if_inst_addr_out  )   , // 指令地址
    .inst_out        (if_inst_out       )     // 指令
);

wire[`InstAddressBus]   if_id_addr_out;
wire[`InstByteBus]      if_id_out     ;

core_if_id if_id_inst(
	.clk(clk),
	.rst(rst),

    // 从core_ctrl取得的信号
    .hold_flag_in	 (ctrl_hold_flag_out)       , // 流水线暂停标志

    .inst_addr_in    (if_inst_addr_out  )       , // 指令地址
    .inst_in         (if_inst_out       )       , // 指令

    .inst_addr_out   (if_id_addr_out)           , // 指令地址
    .inst_out        (if_id_out     )             // 指令
);


wire[`RegistersAddressBus]  id_write_reg1_addr_out  ;
wire[`RegistersAddressBus]  id_write_reg2_addr_out  ;

wire[`InstByteBus]          id_inst_out             ;
wire[`InstAddressBus]       id_inst_addr_out        ;
   // regs
wire                        id_reg_we_out           ;
wire[`RegistersAddressBus]  id_reg_write_addr_out   ;
wire[`RegistersByteBus]     id_reg1_data_out        ;
wire[`RegistersByteBus]     id_reg2_data_out        ;
   // data
wire                        id_eval_en              ;
wire[`MemByteBus]           id_opnum1_out           ;
wire[`MemByteBus]           id_opnum2_out           ;
wire[`ALUFuncBus]           id_func_out             ;
   // decoded signals
wire[`INST_OPCODEBus]       id_opcode_out           ;
wire[`INST_FUNC3Bus]        id_func3_out            ;
wire[`INST_FUNC7Bus]        id_func7_out            ;
wire[`INST_REGBus]          id_rs1_out              ;
wire[`INST_REGBus]          id_rs2_out              ;
wire[`INST_REGBus]          id_rd_out               ;
wire[`INST_IMMBus]          id_immI_out             ;
wire[`INST_IMMBus]          id_immS_out             ;
wire[`INST_IMMBus]          id_immB_out             ;
wire[`INST_IMMBus]          id_immU_out             ;
wire[`INST_IMMBus]          id_immJ_out             ;
wire[`INST_SHAMTBus]        id_shamt_out            ;


wire[`RegistersByteBus]     regs_read_data1_out     ;
wire[`RegistersByteBus]     regs_read_data2_out     ;

wire                        ex_reg_we_out           ;
wire[`RegistersAddressBus]  ex_reg_write_addr_out   ;
wire[`RegistersByteBus]     ex_reg_write_data_out   ;

core_id id_inst(
    .rst(rst),

    // 来自core_if_id的信号
    .inst_in                 (if_id_out     )           , // 指令内容
    .inst_addr_in            (if_id_addr_out)           , // 指令地址

    // 从core_regs获取的信号
    .read_reg1_data_in       (regs_read_data1_out)      , // 通用寄存器1输入数据
    .read_reg2_data_in       (regs_read_data2_out)      , // 通用寄存器2输入数据

    // 向core_regs写入的信号
    .write_reg1_addr_out     (id_write_reg1_addr_out)   , // 读通用寄存器1地址
    .write_reg2_addr_out     (id_write_reg2_addr_out)   , // 读通用寄存器2地址

    // 向core_ex模块写入的信号
        // inst
    .inst_out                (id_inst_out     )         , // 指令内容
    .inst_addr_out           (id_inst_addr_out)         , // 指令地址
        // regs
    .reg_we_out              (id_reg_we_out        )    , // 写通用寄存器标志
    .reg_write_addr_out      (id_reg_write_addr_out)    , // 写通用寄存器地址
    .reg1_data_out           (id_reg1_data_out     )    , // 通用寄存器1数据
    .reg2_data_out           (id_reg2_data_out     )    , // 通用寄存器2数据
        // data
    .eval_en                 (id_eval_en   )            , // 计算使能
    .opnum1_out              (id_opnum1_out)            , // 操作数1
    .opnum2_out              (id_opnum2_out)            , // 操作数2
    .func_out                (id_func_out  )            , // ALU功能
        // decoded signals
    .opcode_out              (id_opcode_out)            , // 指令操作码
    .func3_out               (id_func3_out )            , // func3
    .func7_out               (id_func7_out )            , // func7
    .rs1_out                 (id_rs1_out   )            , // rs1
    .rs2_out                 (id_rs2_out   )            , // rs2
    .rd_out                  (id_rd_out    )            , // rd
    .immI_out                (id_immI_out  )            , // 指令立即数I型
    .immS_out                (id_immS_out  )            , // 指令立即数S型
    .immB_out                (id_immB_out  )            , // 指令立即数B型
    .immU_out                (id_immU_out  )            , // 指令立即数U型
    .immJ_out                (id_immJ_out  )            , // 指令立即数J型
    .shamt_out               (id_shamt_out )              // 指令移位数
);

core_regs regs_inst(
    .clk(clk),
    .rst(rst),

    // core_ex传入
    .we_in           (ex_reg_we_out        )            , // 写寄存器使能
    .write_addr_in   (ex_reg_write_addr_out)            , // 写寄存器地址
    .write_data_in   (ex_reg_write_data_out)            , // 写寄存器数据

    // core_id传入
    .read_addr1_in   (id_write_reg1_addr_out)           , // 读寄存器地址1
    .read_addr2_in   (id_write_reg2_addr_out)           , // 读寄存器地址2

    // 传到core_id
    .read_data1_out  (regs_read_data1_out)              , // 读寄存器1数据
    .read_data2_out  (regs_read_data2_out)                // 读寄存器2数据
);

wire[`InstByteBus]          id_ex_inst_out             ;
wire[`InstAddressBus]       id_ex_inst_addr_out        ;
   // regs
wire                        id_ex_reg_we_out           ;
wire[`RegistersAddressBus]  id_ex_reg_write_addr_out   ;
wire[`RegistersByteBus]     id_ex_reg1_data_out        ;
wire[`RegistersByteBus]     id_ex_reg2_data_out        ;
   // data
wire                        id_ex_eval_en              ;
wire[`MemByteBus]           id_ex_opnum1_out           ;
wire[`MemByteBus]           id_ex_opnum2_out           ;
wire[`ALUFuncBus]           id_ex_func_out             ;
   // decoded signals
wire[`INST_OPCODEBus]       id_ex_opcode_out           ;
wire[`INST_FUNC3Bus]        id_ex_func3_out            ;
wire[`INST_FUNC7Bus]        id_ex_func7_out            ;
wire[`INST_REGBus]          id_ex_rs1_out              ;
wire[`INST_REGBus]          id_ex_rs2_out              ;
wire[`INST_REGBus]          id_ex_rd_out               ;
wire[`INST_IMMBus]          id_ex_immI_out             ;
wire[`INST_IMMBus]          id_ex_immS_out             ;
wire[`INST_IMMBus]          id_ex_immB_out             ;
wire[`INST_IMMBus]          id_ex_immU_out             ;
wire[`INST_IMMBus]          id_ex_immJ_out             ;
wire[`INST_SHAMTBus]        id_ex_shamt_out            ;

core_id_ex id_ex(
    .clk(clk),
    .rst(rst),

    // 从core_ctrl取得的信号
    .hold_flag_in	        (ctrl_hold_flag_out)        , // 流水线暂停标志

    // 从core_id接收的信号
        // inst
    .inst_in                (id_inst_out     )          , // 指令内容
    .inst_addr_in           (id_inst_addr_out)          , // 指令地址
        // regs
    .reg_we_in              (id_reg_we_out        )     , // 写通用寄存器标志
    .reg_write_addr_in      (id_reg_write_addr_out)     , // 写通用寄存器地址
    .reg1_data_in           (id_reg1_data_out     )     , // 通用寄存器1数据
    .reg2_data_in           (id_reg2_data_out     )     , // 通用寄存器2数据
        // data
    .eval_en_in             (id_eval_en   )             , // 计算使能
    .opnum1_in              (id_opnum1_out)             , // 操作数1
    .opnum2_in              (id_opnum2_out)             , // 操作数2
    .func_in                (id_func_out  )             , // ALU功能
        // decoded signals
    .opcode_in              (id_opcode_out)             , // 指令操作码
    .func3_in               (id_func3_out )             , // func3
    .func7_in               (id_func7_out )             , // func7
    .rs1_in                 (id_rs1_out   )             , // rs1
    .rs2_in                 (id_rs2_out   )             , // rs2
    .rd_in                  (id_rd_out    )             , // rd
    .immI_in                (id_immI_out  )             , // 指令立即数I型
    .immS_in                (id_immS_out  )             , // 指令立即数S型
    .immB_in                (id_immB_out  )             , // 指令立即数B型
    .immU_in                (id_immU_out  )             , // 指令立即数U型
    .immJ_in                (id_immJ_out  )             , // 指令立即数J型
    .shamt_in               (id_shamt_out )             , // 指令移位数

////////////////////////////////////////////////////////////////////////////////////
    
    // 向core_id等后级发送的信号
    .inst_out               (id_ex_inst_out     )       , // 指令内容
    .inst_addr_out          (id_ex_inst_addr_out)       , // 指令地址
        // regs
    .reg_we_out             (id_ex_reg_we_out        )  , // 写通用寄存器标志
    .reg_write_addr_out     (id_ex_reg_write_addr_out)  , // 写通用寄存器地址
    .reg1_data_out          (id_ex_reg1_data_out     )  , // 通用寄存器1数据
    .reg2_data_out          (id_ex_reg2_data_out     )  , // 通用寄存器2数据
        // data
    .eval_en_out            (id_ex_eval_en   )          , // 计算使能
    .opnum1_out             (id_ex_opnum1_out)          , // 操作数1
    .opnum2_out             (id_ex_opnum2_out)          , // 操作数2
    .func_out               (id_ex_func_out  )          , // ALU功能
        // decoded signals
    .opcode_out             (id_ex_opcode_out)          , // 指令操作码
    .func3_out              (id_ex_func3_out )          , // func3
    .func7_out              (id_ex_func7_out )          , // func7
    .rs1_out                (id_ex_rs1_out   )          , // rs1
    .rs2_out                (id_ex_rs2_out   )          , // rs2
    .rd_out                 (id_ex_rd_out    )          , // rd
    .immI_out               (id_ex_immI_out  )          , // 指令立即数I型
    .immS_out               (id_ex_immS_out  )          , // 指令立即数S型
    .immB_out               (id_ex_immB_out  )          , // 指令立即数B型
    .immU_out               (id_ex_immU_out  )          , // 指令立即数U型
    .immJ_out               (id_ex_immJ_out  )          , // 指令立即数J型
    .shamt_out              (id_ex_shamt_out )            // 指令移位数
);

wire[`MemByteBus] alu_res_out;

core_alu alu_inst(
    .eval_en     (id_ex_eval_en   )                     , // 计算使能   

    .opnum1_in   (id_ex_opnum1_out)                     , // 操作数1
    .opnum2_in   (id_ex_opnum2_out)                     , // operand 2

    .func_in     (id_ex_func_out  )                     , // ALU功能

    .res_out     (alu_res_out     )                       // 结果
);

// 向core_ctrl发送的信号
wire                         ex_hold_flag_out           ;
wire                         ex_jump_flag_out           ;
wire[`MemByteBus]            ex_jump_addr_out           ;

core_ex ex_inst(
    .rst(rst),

    // 从core_id接收的信号
        // inst
    .inst_in                (id_ex_inst_out     )       , // 指令内容
    .inst_addr_in           (id_ex_inst_addr_out)       , // 指令地址
        // regs
    .reg_we_in              (id_ex_reg_we_out        )  , // 写通用寄存器标志
    .reg_write_addr_in      (id_ex_reg_write_addr_out)  , // 写通用寄存器地址
    .reg1_data_in           (id_ex_reg1_data_out     )  , // 通用寄存器1数据
    .reg2_data_in           (id_ex_reg2_data_out     )  , // 通用寄存器2数据
        // data
    .eval_en_in             (id_ex_eval_en   )          , // 计算使能
    .opnum1_in              (id_ex_opnum1_out)          , // 操作数1
    .opnum2_in              (id_ex_opnum2_out)          , // 操作数2
    .func_in                (id_ex_func_out  )          , // ALU功能
    .eval_val_in            (alu_res_out)               , // 计算结果
        // decoded signals 
    .opcode_in              (id_ex_opcode_out)          , // 指令操作码
    .func3_in               (id_ex_func3_out )          , // func3
    .func7_in               (id_ex_func7_out )          , // func7
    .rs1_in                 (id_ex_rs1_out   )          , // rs1
    .rs2_in                 (id_ex_rs2_out   )          , // rs2
    .rd_in                  (id_ex_rd_out    )          , // rd
    .immI_in                (id_ex_immI_out  )          , // 指令立即数I型
    .immS_in                (id_ex_immS_out  )          , // 指令立即数S型
    .immB_in                (id_ex_immB_out  )          , // 指令立即数B型
    .immU_in                (id_ex_immU_out  )          , // 指令立即数U型
    .immJ_in                (id_ex_immJ_out  )          , // 指令立即数J型
    .shamt_in               (id_ex_shamt_out )          , // 指令移位数,
    // 向core_regs发送的信号
    .reg_we_out             (ex_reg_we_out        )     , // 是否要写通用寄存器
    .reg_write_addr_out     (ex_reg_write_addr_out)     , // 写通用寄存器地址
    .reg_write_data_out     (ex_reg_write_data_out)     , // 写寄存器数据
    // 向core_ctrl发送的信号
    .hold_flag_out          (ex_hold_flag_out)          , // 是否要暂停
    .jump_flag_out          (ex_jump_flag_out)          , // 是否要跳转
    .jump_addr_out          (ex_jump_addr_out)            // 跳转地址
);

core_ctrl ctrl_inst(
    .jump_flag_in    (ex_jump_flag_out)                 , // 跳转标志
    .jump_addr_in    (ex_jump_addr_out)                 , // 跳转地址
    .hold_flag_ex_in (ex_hold_flag_out)                 , // core_ex暂停流水标志

    .jump_flag_out   (ctrl_jump_flag_out)               , // 跳转标志
    .jump_addr_out   (ctrl_jump_addr_out)               , // 跳转地址
    .hold_flag_out   (ctrl_hold_flag_out)                 // 暂停流水标志
);

endmodule
