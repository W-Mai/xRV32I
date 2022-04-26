// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT


`timescale 1ns/1ns

`include "../core/core_if.v"
`include "../core/defines.v"

module pc_reg_test();
    reg [`InstAddressBus] pc_addr;
	wire [`InstAddressBus] rom_addr;
	wire [`InstAddressBus] rom_index;
	reg [`InstByteBus] rom_data;
	reg [`InstAddressBus] rom[0:15];

	wire [`InstAddressBus] pc;
	wire [`InstByteBus] inst;

	core_if core_if_inst(
		.pc_addr_in		(pc_addr),
		.rom_addr_out	(rom_addr),
		.rom_data_in	(rom[rom_index]),
		.inst_addr_out	(pc),
		.inst_out	 	(inst)
    );

	assign rom_index = rom_addr >> 2;

	always begin
		pc_addr = 0; #10 $display("pc_addr = %d, inst = %x", pc_addr, rom[rom_index]);
		pc_addr = 4; #10 $display("pc_addr = %d, inst = %x", pc_addr, rom[rom_index]);
		pc_addr = 8; #10 $display("pc_addr = %d, inst = %x", pc_addr, rom[rom_index]);

		$finish;
	end

	initial begin
		$dumpfile("wave.vcd"); // 指定用作dumpfile的文件
		$dumpvars; // dump all vars

		$readmemh("rom_data.dat", rom);
	end

endmodule

