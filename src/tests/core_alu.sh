# Copyright (c) 2022 W-Mai
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

iverilog -o core_alu_test.vvp core_alu_test.v
vvp core_alu_test.vvp