from FrameworkDrawer.FrameworkNode import ModelBoxBaseModel, Reg, Wire, CONFIGURE


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

    ROM_Addr_Out = Wire('ROM_Addr_Out', (0, 31))
    ROM_Data_In = Wire('ROM_Data_In', (0, 31))

    Inst_Addr_Out = Wire('Inst_Addr(IF, IF_ID)', (0, 31))
    Int_Out = Wire('Int(IF, IF_ID)', (0, 31))

    class Meta:
        name = 'Core/IF'


class Core_IF_ID(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Inst_Addr_In = Wire('Inst_Addr(IF, IF_ID)', (0, 31))
    Inst_In = Wire('Int(IF, IF_ID)', (0, 31))

    Inst_Addr_Out = Wire('Inst_Addr_Out', (0, 31))
    Inst_Out = Wire('Inst_Out', (0, 31))

    class Meta:
        name = 'Core/IF_ID'


CONFIG = CONFIGURE(
    node_pos_pair={
        Core_PC_REG: (-10, 0),
        Core_IF: (0, -5),
        Core_IF_ID: (10, 0),
    }, other_conf={}
)
