// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xmulnm #(
	parameter width = 5,
    parameter height = 32
)(
    input wire[width - 1 : 0]                       who    ,

    input wire[(1 << width) * height - 1 : 0]       val_in ,
    output wire[height - 1: 0]                      val_out
);

wire[height - 1: 0] date_arr[0 : (1 << width) - 1];

genvar i;
generate 
for (i = 0 ; i < height ; i = i + 1) begin : ctrl_mux
    assign date_arr[i] = val_in[(i + 1) * (1 << width) - 1 : i * (1 << width)];
end
endgenerate

assign val_out = date_arr[who];

endmodule
