// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module gen_ff #(
    parameter ff_width = 32
)(
	input wire clk,
	input wire rst,
    input wire hold,

    input wire [ff_width-1:0] default_val_in    ,
    input wire [ff_width-1:0] val_in            ,

    output reg [ff_width-1:0] val_out
);


always @(posedge clk) begin
	// 复位
	if (rst == `RstEnable || hold == `HoldEnable) begin
		val_out <= default_val_in;
	end else begin
        val_out <= val_in;
    end
end

endmodule
