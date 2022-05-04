import random

from FrameworkDrawer.FrameworkNode import ModelBoxBaseModel, Reg, Wire, CONFIGURE, Connector

from color_utils import hsl_to_rgb, color_hex


class Core_PC_REG(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Jump_Flag_In = Wire('Jump_Flag_In')
    Jump_Addr_In = Wire('Jump_Addr_In', (0, 31))
    Hold_Flag_In = Wire('Hold_Flag_In', (0, 2))

    PC_Out = Reg('PC(PC_REG, IF)', (0, 31))

    class Meta:
        name = 'Core/PC_REG'


class Core_IF(ModelBoxBaseModel):
    PC_Addr_In = Wire('PC(PC_REG, IF)', (0, 31))

    ROM_Addr_Out = Wire('Inst_Addr(IF, TOP)', (0, 31))
    ROM_Data_In = Wire('Inst(TOP, IF)', (0, 31))

    Inst_Addr_Out = Wire('Inst_Addr(IF, IF_ID)', (0, 31))
    Int_Out = Wire('Int(IF, IF_ID)', (0, 31))

    class Meta:
        name = 'Core/IF'


class Core_IF_ID(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Inst_Addr_In = Wire('Inst_Addr(IF, IF_ID)', (0, 31))
    Inst_In = Wire('Int(IF, IF_ID)', (0, 31))

    Inst_Out = Wire('Inst(IF_ID, ID)', (0, 31))
    Inst_Addr_Out = Wire('Inst_Addr(IF_ID, ID)', (0, 31))

    class Meta:
        name = 'Core/IF_ID'


class Core_REGS(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Write_En_In = Wire('Write_En_In')
    Write_Addr_In = Wire('Write_Addr_In', (0, 31))
    Write_Data_In = Wire('Write_Data_In', (0, 31))

    Read_Addr1_In = Wire('Reg1_Addr(ID, REGS)', (0, 31))
    Read_Addr2_In = Wire('Reg2_Addr(ID, REGS)', (0, 31))

    Read_Data1_Out = Wire('Reg1_Data(ID, REGS)', (0, 31))
    Read_Data2_Out = Wire('Reg2_Data(ID, REGS)', (0, 31))

    class Meta:
        name = 'Core/REGS'


class Core_ID(ModelBoxBaseModel):
    RST = Wire('RST')

    Inst_In = Wire('Inst(IF_ID, ID)', (0, 31))
    Inst_Addr_In = Wire('Inst_Addr(IF_ID, ID)', (0, 31))

    Write_Reg1_Addr_Out = Wire('Reg1_Addr(ID, REGS)', (0, 31))
    Write_Reg2_Addr_Out = Wire('Reg2_Addr(ID, REGS)', (0, 31))

    Read_Reg1_Data_In = Wire('Reg1_Data(ID, REGS)', (0, 31))
    Read_Reg2_Data_In = Wire('Reg2_Data(ID, REGS)', (0, 31))

    Inst_Out = Wire('Inst(ID, ID_EX)', (0, 31))
    Inst_Addr_Out = Wire('Inst_Addr(ID, ID_EX)', (0, 31))

    Reg_We_Out = Wire('Reg_We(ID, ID_EX)')
    Reg_Write_Addr_Out = Wire('Reg_Write_Addr(ID, ID_EX)', (0, 31))
    Reg1_Data_Out = Wire('Reg1_Data(ID, ID_EX)', (0, 31))
    Reg2_Data_Out = Wire('Reg2_Data(ID, ID_EX)', (0, 31))

    Eval_Enable_Out = Wire('Eval_Enable(ID, ID_EX)')
    Opnum1_Out = Wire('Opnum1(ID, ID_EX)', (0, 31))
    Opnum2_Out = Wire('Opnum2(ID, ID_EX)', (0, 31))
    Func_Out = Wire('Func(ID, ID_EX)', (0, 31))

    Opcode_Out = Wire('Opcode(ID, ID_EX)', (0, 6))
    Func3_Out = Wire('Func3(ID, ID_EX)', (0, 2))
    Func7_Out = Wire('Func7(ID, ID_EX)', (0, 6))
    Rs1_Out = Wire('Rs1(ID, ID_EX)', (0, 4))
    Rs2_Out = Wire('Rs2(ID, ID_EX)', (0, 4))
    Rd_Out = Wire('Rd(ID, ID_EX)', (0, 4))
    ImmI_Out = Wire('ImmI(ID, ID_EX)', (0, 31))
    ImmS_Out = Wire('ImmS(ID, ID_EX)', (0, 31))
    ImmB_Out = Wire('ImmB(ID, ID_EX)', (0, 31))
    ImmU_Out = Wire('ImmU(ID, ID_EX)', (0, 31))
    ImmJ_Out = Wire('ImmJ(ID, ID_EX)', (0, 31))
    Shamt_Out = Wire('Shamt(ID, ID_EX)', (0, 4))

    class Meta:
        name = 'Core/ID'


class Core_ID_EX(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Inst_In = Wire('Inst(ID, ID_EX)', (0, 31))
    Inst_Addr_In = Wire('Inst_Addr(ID, ID_EX)', (0, 31))
    Reg_We_In = Wire('Reg_We(ID, ID_EX)')
    Reg_Write_Addr_In = Wire('Reg_Write_Addr(ID, ID_EX)', (0, 31))
    Reg1_Data_In = Wire('Reg1_Data(ID, ID_EX)', (0, 31))
    Reg2_Data_In = Wire('Reg2_Data(ID, ID_EX)', (0, 31))

    Eval_Enable_In = Wire('Eval_Enable(ID, ID_EX)')
    Opnum1_In = Wire('Opnum1(ID, ID_EX)', (0, 31))
    Opnum2_In = Wire('Opnum2(ID, ID_EX)', (0, 31))
    Func_In = Wire('Func(ID, ID_EX)', (0, 31))

    Opcode_In = Wire('Opcode(ID, ID_EX)', (0, 6))
    Func3_In = Wire('Func3(ID, ID_EX)', (0, 2))
    Func7_In = Wire('Func7(ID, ID_EX)', (0, 6))
    Rs1_In = Wire('Rs1(ID, ID_EX)', (0, 4))
    Rs2_In = Wire('Rs2(ID, ID_EX)', (0, 4))
    Rd_In = Wire('Rd(ID, ID_EX)', (0, 4))
    ImmI_In = Wire('ImmI(ID, ID_EX)', (0, 31))
    ImmS_In = Wire('ImmS(ID, ID_EX)', (0, 31))
    ImmB_In = Wire('ImmB(ID, ID_EX)', (0, 31))
    ImmU_In = Wire('ImmU(ID, ID_EX)', (0, 31))
    ImmJ_In = Wire('ImmJ(ID, ID_EX)', (0, 31))
    Shamt_In = Wire('Shamt(ID, ID_EX)', (0, 4))

    ############################################################################

    Inst_Out = Wire('Inst(ID_EX, EX)', (0, 31))
    Inst_Addr_Out = Wire('Inst_Addr(ID_EX, EX)', (0, 31))

    Reg_We_Out = Wire('Reg_We(ID_EX, EX)')
    Reg_Write_Addr_Out = Wire('Reg_Write_Addr(ID_EX, EX)', (0, 31))
    Reg1_Data_Out = Wire('Reg1_Data(ID_EX, EX)', (0, 31))
    Reg2_Data_Out = Wire('Reg2_Data(ID_EX, EX)', (0, 31))

    Eval_Enable_Out = Wire('Eval_Enable(ID_EX, ALU)')
    Opnum1_Out = Wire('Opnum1(ID_EX, ALU)', (0, 31))
    Opnum2_Out = Wire('Opnum2(ID_EX, ALU)', (0, 31))
    Func_Out = Wire('Func(ID_EX, ALU)', (0, 31))

    Opcode_Out = Wire('Opcode(ID_EX, EX)', (0, 6))
    Func3_Out = Wire('Func3(ID_EX, EX)', (0, 2))
    Func7_Out = Wire('Func7(ID_EX, EX)', (0, 6))
    Rs1_Out = Wire('Rs1(ID_EX, EX)', (0, 4))
    Rs2_Out = Wire('Rs2(ID_EX, EX)', (0, 4))
    Rd_Out = Wire('Rd(ID_EX, EX)', (0, 4))
    ImmI_Out = Wire('ImmI(ID_EX, EX)', (0, 31))
    ImmS_Out = Wire('ImmS(ID_EX, EX)', (0, 31))
    ImmB_Out = Wire('ImmB(ID_EX, EX)', (0, 31))
    ImmU_Out = Wire('ImmU(ID_EX, EX)', (0, 31))
    ImmJ_Out = Wire('ImmJ(ID_EX, EX)', (0, 31))
    Shamt_Out = Wire('Shamt(ID_EX, EX)', (0, 4))

    class Meta:
        name = 'Core/ID_EX'


class Core_ALU(ModelBoxBaseModel):
    Eval_Enable = Wire('Eval_Enable(ID_EX, ALU)')

    Opnum1_In = Wire('Opnum1(ID_EX, ALU)', (0, 31))
    Opnum2_In = Wire('Opnum2(ID_EX, ALU)', (0, 31))

    Func_In = Wire('Func(ID_EX, ALU)', (0, 4))

    Res_Out = Wire('Res(ALU, EX)', (0, 31))

    class Meta:
        name = 'Core/ALU'


class Core_EX(ModelBoxBaseModel):
    RST = Wire('RST')

    Inst_In = Wire('Inst(ID_EX, EX)', (0, 31))
    Inst_Addr_In = Wire('Inst_Addr(ID_EX, EX)', (0, 31))

    Reg_We_In = Wire('Reg_We(ID_EX, EX)')
    Reg_Write_Addr_In = Wire('Reg_Write_Addr(ID_EX, EX)', (0, 4))
    Reg1_Data_In = Wire('Reg1_Data(ID_EX, EX)', (0, 31))
    Reg2_Data_In = Wire('Reg2_Data(ID_EX, EX)', (0, 31))

    Eval_Enable_In = Wire('Eval_Enable(ID_EX, ALU)')
    Opnum1_In = Wire('Opnum1(ID_EX, ALU)', (0, 31))
    Opnum2_In = Wire('Opnum2(ID_EX, ALU)', (0, 31))
    Func_In = Wire('Func(ID_EX, ALU)', (0, 31))

    Eval_Val_In = Wire('Res(ALU, EX)', (0, 31))
    Opcode_In = Wire('Opcode(ID_EX, EX)', (0, 6))
    Func3_In = Wire('Func3(ID_EX, EX)', (0, 2))
    Func7_In = Wire('Func7(ID_EX, EX)', (0, 6))
    Rs1_In = Wire('Rs1(ID_EX, EX)', (0, 4))
    Rs2_In = Wire('Rs2(ID_EX, EX)', (0, 4))
    Rd_In = Wire('Rd(ID_EX, EX)', (0, 4))
    ImmI_In = Wire('ImmI(ID_EX, EX)', (0, 31))
    ImmS_In = Wire('ImmS(ID_EX, EX)', (0, 31))
    ImmB_In = Wire('ImmB(ID_EX, EX)', (0, 31))
    ImmU_In = Wire('ImmU(ID_EX, EX)', (0, 31))
    ImmJ_In = Wire('ImmJ(ID_EX, EX)', (0, 31))
    Shamt_In = Wire('Shamt(ID_EX, EX)', (0, 4))

    Reg_We_Out = Wire('Reg_We_Out')
    Reg_Write_Addr_Out = Wire('Reg_Write_Addr_Out', (0, 31))
    Reg_Write_Data_Out = Wire('Reg_Write_Data_Out', (0, 31))

    class Meta:
        name = 'Core/EX'


class xRV32I(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Inst_Addr_Out = Wire('Inst_Addr(IF, TOP)', (0, 31))
    Inst_In = Wire('Inst(TOP, IF)', (0, 31))

    class Meta:
        name = 'xRV32I'


CONFIG = CONFIGURE(
    node_pos_pair={
        Core_PC_REG: (-6, 0),
        Core_IF: (2, -3),
        Core_IF_ID: (12, 8.6),
        Core_REGS: (2, 8),
        Core_ID: (20, 6.8),
        Core_ID_EX: (34, 12),
        Core_ALU: (40.5, 7.8),
        Core_EX: (52, 12),

        xRV32I: (-16, 5),
    }, connector_pair={
        Connector(Core_EX.Reg_We_Out, Core_REGS.Write_En_In, (56, 14), (-1, 14)),
        Connector(Core_EX.Reg_Write_Addr_Out, Core_REGS.Write_Addr_In, (56, 14.25), (-1, 14.25)),
        Connector(Core_EX.Reg_Write_Data_Out, Core_REGS.Write_Data_In, (56, 14.5), (-1, 14.5)),
    }, other_conf={}
    , colors=[color_hex(*hsl_to_rgb(h, 0.5, 0.5)) for h in [0 + i * 1 / 32 for i in range(32)]]
)
