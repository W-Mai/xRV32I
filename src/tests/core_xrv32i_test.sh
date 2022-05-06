# Copyright (c) 2022 W-Mai
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

iverilog -o core_xrv32i_test.vvp \
                                ../utils/gen_ff.v \
                                ../core/core_pc_reg.v \
                                ../core/core_if.v \
                                ../core/core_if_id.v \
                                ../core/core_id.v \
                                ../core/core_regs.v \
                                ../core/core_id_ex.v \
                                ../core/core_alu.v \
                                ../core/core_ex.v \
                                ../core/core_ctrl.v \
                                core_xrv32i_test.v

vvp core_xrv32i_test.vvp