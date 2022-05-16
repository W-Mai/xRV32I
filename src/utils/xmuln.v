// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xmuln #(
	parameter width = 5    
)(
    input wire[width - 1 : 0]           who    ,

    input wire[(1 << width) - 1 : 0]    val_in ,
    output wire                         val_out
);

assign val_out = val_in[who];

endmodule
