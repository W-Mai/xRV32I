# Copyright (c) 2022 W-Mai
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

iverilog -o core_xrv32i_soc_test.vvp \
                                ../utils/xencdr.v \
                                ../utils/xmuln.v \
                                ../utils/xmulnm.v \
                                ../utils/gen_ff.v \
                                ../periph/per_rom.v \
                                ../periph/per_ram.v \
                                ../core/core_pc_reg.v \
                                ../core/core_if.v \
                                ../core/core_if_id.v \
                                ../core/core_id.v \
                                ../core/core_regs.v \
                                ../core/core_id_ex.v \
                                ../core/core_alu.v \
                                ../core/core_ex.v \
                                ../core/core_ctrl.v \
                                ../core/xrv32i.v \
                                ../core/xSimBus.v \
                                ../soc/xrv32i_soc.v \
                                core_xrv32i_soc_test.v

vvp core_xrv32i_soc_test.vvp