// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_alu(
    input eval_en,

    input wire[`MemByteBus] opnum1_in   , // 操作数1
    input wire[`MemByteBus] opnum2_in   , // operand 2

    input wire[`ALUFuncBus] func_in     , // ALU功能

    output reg[`MemByteBus] res_out       // 结果
);


always @(*) begin
    if (eval_en == `ALUEnable) begin
        case (func_in)
            `ALUFunc_ADD:   res_out <= opnum1_in + opnum2_in;
            `ALUFunc_SUB:   res_out <= opnum1_in - opnum2_in;
            `ALUFunc_XOR:   res_out <= opnum1_in ^ opnum2_in;
            `ALUFunc_OR:    res_out <= opnum1_in | opnum2_in;
            `ALUFunc_AND:   res_out <= opnum1_in & opnum2_in;
            `ALUFunc_SLL:   res_out <= opnum1_in << opnum2_in[4:0];
            `ALUFunc_SRL:   res_out <= opnum1_in >> opnum2_in[4:0];
            `ALUFunc_SRA:   res_out <= $signed(opnum1_in) >>> (opnum2_in);
            `ALUFunc_SLT:   res_out <= ($signed(opnum1_in) < $signed(opnum2_in)) ? 1 : 0;
            `ALUFunc_SLTU:  res_out <= (opnum1_in < opnum2_in) ? 1 : 0;

            default: 
                res_out <= `MemByteWidth'b0;
        endcase
    end else begin
        res_out <= `MemByteWidth'b0;
    end
end


endmodule
