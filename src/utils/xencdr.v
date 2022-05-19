// Copyright (c) 2022 W-Mai
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

`include "../core/defines.v"

module xencdr(
    input wire[31: 0]   val_in,

    output reg[4: 0]    val_out
);

always @(*) begin
    if (val_in[0] == 1)
        val_out = 0;
    else if(val_in[1]   == 1)
        val_out = 1;
    else if(val_in[2]   == 1)
        val_out = 2;
    else if(val_in[3]   == 1)
        val_out = 3;
    else if(val_in[4]   == 1)
        val_out = 4;
    else if(val_in[5]   == 1)
        val_out = 5;
    else if(val_in[6]   == 1)
        val_out = 6;
    else if(val_in[7]   == 1)
        val_out = 7;
    else if(val_in[8]   == 1)
        val_out = 8;
    else if(val_in[9]   == 1)
        val_out = 9;
    else if(val_in[10]  == 1)
        val_out = 10;
    else if(val_in[11]  == 1)
        val_out = 11;
    else if(val_in[12]  == 1)
        val_out = 12;
    else if(val_in[13]  == 1)
        val_out = 13;
    else if(val_in[14]  == 1)
        val_out = 14;
    else if(val_in[15]  == 1)
        val_out = 15;
    else if(val_in[16]  == 1)
        val_out = 16;
    else if(val_in[17]  == 1)
        val_out = 17;
    else if(val_in[18]  == 1)
        val_out = 18;
    else if(val_in[19]  == 1)
        val_out = 19;
    else if(val_in[20]  == 1)
        val_out = 20;
    else if(val_in[21]  == 1)
        val_out = 21;
    else if(val_in[22]  == 1)
        val_out = 22;
    else if(val_in[23]  == 1)
        val_out = 23;
    else if(val_in[24]  == 1)
        val_out = 24;
    else if(val_in[25]  == 1)
        val_out = 25;
    else if(val_in[26]  == 1)
        val_out = 26;
    else if(val_in[27]  == 1)
        val_out = 27;
    else if(val_in[28]  == 1)
        val_out = 28;
    else if(val_in[29]  == 1)
        val_out = 29;
    else if(val_in[30]  == 1)
        val_out = 30;
    else if(val_in[31]  == 1)
        val_out = 31;
    else
        val_out = 0;
end

endmodule
