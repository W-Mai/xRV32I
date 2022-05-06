// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module core_ctrl(
    input wire                  jump_flag_in    , // 跳转标志
    input wire[`MemAddressBus]  jump_addr_in    , // 跳转地址
    input wire                  hold_flag_ex_in , // core_ex暂停流水标志

    output wire                 jump_flag_out   , // 跳转标志
    output wire[`MemAddressBus] jump_addr_out   , // 跳转地址
    output wire                 hold_flag_out     // 暂停流水标志
);

always @(*) begin
    jump_flag_out = jump_flag_in;
    jump_addr_out = jump_addr_in;

    if (jump_flag_in == `JumpEnable || hold_flag_ex_in == `HoldEnable) begin
        hold_flag_out = `HoldEnable;
    end else begin
        hold_flag_out = `HoldDisable;
    end
end

endmodule
