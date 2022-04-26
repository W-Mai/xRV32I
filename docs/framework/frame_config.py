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


class Core_REGS(ModelBoxBaseModel):
    CLK = Wire('CLK')
    RST = Wire('RST')

    Write_En_In = Wire('Write_En_In')
    Write_Addr_In = Wire('Write_Addr_In', (0, 31))
    Write_Data_In = Wire('Write_Data_In', (0, 31))

    Read_Addr1_In = Wire('Read_Addr1_In', (0, 31))
    Read_Addr2_In = Wire('Read_Addr2_In', (0, 31))

    Read_Data1_Out = Wire('Read_Data1_Out', (0, 31))
    Read_Data2_Out = Wire('Read_Data2_Out', (0, 31))

    class Meta:
        name = 'Core/REGS'


CONFIG = CONFIGURE(
    node_pos_pair={
        Core_PC_REG: (-10, 0),
        Core_IF: (0, -5),
        Core_IF_ID: (10, 0),
        Core_REGS: (0, 10),
    }, other_conf={}
)
