// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xrv32i(
    input clk,
    input rst,

    input [`InstByteBus]    inst_in         , // 指令输入

    output [`MemAddressBus] inst_addr_out     // 指令地址输出
);

core_pc_reg pc_reg_inst(
	.clk(),
	.rst(),

	.jump_flag_in 	(), // 跳转标志
	.jump_addr_in 	(), // 跳转地址
	
	.pc_out 		(), // 当前程序计数器

	// 其他杂项
	.hold_flag_in	()  // 暂停标志
);

core_if if_inst(
	.pc_addr_in      (), // 程序计数器地址

    .rom_addr_out    (), // ROM地址
    .rom_data_in     (), // ROM数据

    .inst_addr_out   (), // 指令地址
    .inst_out        ()  // 指令
);

core_if_id if_id_inst(
	.clk(),
	.rst(),

    .inst_addr_in    (), // 指令地址
    .inst_in         (), // 指令

    .inst_addr_out   (), // 指令地址
    .inst_out        ()  // 指令
);

core_id id_inst(
    .rst(),

    // 来自core_if_id的信号
    .inst_in                 (), // 指令内容
    .inst_addr_in            (), // 指令地址

    // 从core_regs获取的信号
    .read_reg1_data_in       (), // 通用寄存器1输入数据
    .read_reg2_data_in       (), // 通用寄存器2输入数据

    // 向core_regs写入的信号
    .write_reg1_addr_out     (), // 读通用寄存器1地址
    .write_reg2_addr_out     (), // 读通用寄存器2地址

    // 向core_ex模块写入的信号
        // inst
    .inst_out                (), // 指令内容
    .inst_addr_out           (), // 指令地址
        // regs
    .reg_we_out              (), // 写通用寄存器标志
    .reg_write_addr_out      (), // 写通用寄存器地址
    .reg1_data_out           (), // 通用寄存器1数据
    .reg2_data_out           (), // 通用寄存器2数据
        // data
    .eval_en                 (), // 计算使能
    .opnum1_out              (), // 操作数1
    .opnum2_out              (), // 操作数2
    .func_out                (), // ALU功能
        // decoded signals
    .opcode_out              (), // 指令操作码
    .func3_out               (), // func3
    .func7_out               (), // func7
    .rs1_out                 (), // rs1
    .rs2_out                 (), // rs2
    .rd_out                  (), // rd
    .immI_out                (), // 指令立即数I型
    .immS_out                (), // 指令立即数S型
    .immB_out                (), // 指令立即数B型
    .immU_out                (), // 指令立即数U型
    .immJ_out                (), // 指令立即数J型
    .shamt_out               ()  // 指令移位数
);

core_regs regs_inst(
    .clk(),
    .rst(),

    // core_ex传入
    .we_in           (), // 写寄存器使能
    .write_addr_in   (), // 写寄存器地址
    .write_data_in   (), // 写寄存器数据

    // core_id传入
    .read_addr1_in   (), // 读寄存器地址1
    .read_addr2_in   (), // 读寄存器地址2

    // 传到core_id
    .read_data1_out  (), // 读寄存器1数据
    .read_data2_out  ()  // 读寄存器2数据
);

core_id_ex id_ex(
    .clk(),
    .rst(),

    // 从core_id接收的信号
        // inst
    .inst_in                (), // 指令内容
    .inst_addr_in           (), // 指令地址
        // regs
    .reg_we_in              (), // 写通用寄存器标志
    .reg_write_addr_in      (), // 写通用寄存器地址
    .reg1_data_in           (), // 通用寄存器1数据
    .reg2_data_in           (), // 通用寄存器2数据
        // data
    .eval_en_in             (), // 计算使能
    .opnum1_in              (), // 操作数1
    .opnum2_in              (), // 操作数2
    .func_in                (), // ALU功能
        // decoded signals
    .opcode_in              (), // 指令操作码
    .func3_in               (), // func3
    .func7_in               (), // func7
    .rs1_in                 (), // rs1
    .rs2_in                 (), // rs2
    .rd_in                  (), // rd
    .immI_in                (), // 指令立即数I型
    .immS_in                (), // 指令立即数S型
    .immB_in                (), // 指令立即数B型
    .immU_in                (), // 指令立即数U型
    .immJ_in                (), // 指令立即数J型
    .shamt_in               (), // 指令移位数

////////////////////////////////////////////////////////////////////////////////////
    
    // 向core_id等后级发送的信号
    .inst_out               (), // 指令内容
    .inst_addr_out          (), // 指令地址
        // regs
    .reg_we_out             (), // 写通用寄存器标志
    .reg_write_addr_out     (), // 写通用寄存器地址
    .reg1_data_out          (), // 通用寄存器1数据
    .reg2_data_out          (), // 通用寄存器2数据
        // data
    .eval_en_out            (), // 计算使能
    .opnum1_out             (), // 操作数1
    .opnum2_out             (), // 操作数2
    .func_out               (), // ALU功能
        // decoded signals
    .opcode_out             (), // 指令操作码
    .func3_out              (), // func3
    .func7_out              (), // func7
    .rs1_out                (), // rs1
    .rs2_out                (), // rs2
    .rd_out                 (), // rd
    .immI_out               (), // 指令立即数I型
    .immS_out               (), // 指令立即数S型
    .immB_out               (), // 指令立即数B型
    .immU_out               (), // 指令立即数U型
    .immJ_out               (), // 指令立即数J型
    .shamt_out              ()  // 指令移位数
);

core_alu alu_inst(
    .eval_en(),

    .opnum1_in   (), // 操作数1
    .opnum2_in   (), // operand 2

    .func_in     (), // ALU功能

    .res_out     ()  // 结果
);

core_ex ex_inst(
    .rst(),

    // 从core_id接收的信号
        // inst
    .inst_in                (), // 指令内容
    .inst_addr_in           (), // 指令地址
        // regs
    .reg_we_in              (), // 写通用寄存器标志
    .reg_write_addr_in      (), // 写通用寄存器地址
    .reg1_data_in           (), // 通用寄存器1数据
    .reg2_data_in           (), // 通用寄存器2数据
        // data
    .eval_en_in             (), // 计算使能
    .opnum1_in              (), // 操作数1
    .opnum2_in              (), // 操作数2
    .func_in                (), // ALU功能
    .eval_val_in            (), // 计算结果
        // decoded signals 
    .opcode_in              (), // 指令操作码
    .func3_in               (), // func3
    .func7_in               (), // func7
    .rs1_in                 (), // rs1
    .rs2_in                 (), // rs2
    .rd_in                  (), // rd
    .immI_in                (), // 指令立即数I型
    .immS_in                (), // 指令立即数S型
    .immB_in                (), // 指令立即数B型
    .immU_in                (), // 指令立即数U型
    .immJ_in                (), // 指令立即数J型
    .shamt_in               (), // 指令移位数,
    // 向core_regs发送的信号
    .reg_we_out             (), // 是否要写通用寄存器
    .reg_write_addr_out     (), // 写通用寄存器地址
    .reg_write_data_out     ()  // 写寄存器数据
);

endmodule
