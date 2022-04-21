<?xml version="1.0" encoding="UTF-8"?>
<Project Version="3" Minor="1" Path="X:/FPGA/LicheeTang/Projects/xRV32I/src">
    <Project_Created_Time></Project_Created_Time>
    <TD_Version>5.5.47752</TD_Version>
    <Name>xRV32I</Name>
    <HardWare>
        <Family>EG4</Family>
        <Device>EG4S20BG256</Device>
    </HardWare>
    <Source_Files>
        <Verilog>
            <File Path="core/pc_reg.v">
                <FileInfo>
                    <Attr Name="UsedInSyn" Val="true"/>
                    <Attr Name="UsedInP&R" Val="true"/>
                    <Attr Name="BelongTo" Val="design_1"/>
                    <Attr Name="CompileOrder" Val="1"/>
                </FileInfo>
            </File>
        </Verilog>
    </Source_Files>
    <FileSets>
        <FileSet Name="design_1" Type="DesignFiles">
        </FileSet>
        <FileSet Name="constrain_1" Type="ConstrainFiles">
        </FileSet>
    </FileSets>
    <TOP_MODULE>
        <LABEL></LABEL>
        <MODULE>pc_reg</MODULE>
        <CREATEINDEX>auto</CREATEINDEX>
    </TOP_MODULE>
    <Property>
    </Property>
    <Device_Settings>
    </Device_Settings>
    <Configurations>
    </Configurations>
    <Runs>
        <Run Name="syn_1" Type="Synthesis" ConstraintSet="constrain_1" Description="" Active="true">
            <Strategy Name="Default_Synthesis_Strategy">
                <DesignProperty>
                    <infer_fsm>onehot</infer_fsm>
                </DesignProperty>
            </Strategy>
        </Run>
        <Run Name="phy_1" Type="PhysicalDesign" ConstraintSet="constrain_1" Description="" SynRun="syn_1" Active="true">
            <Strategy Name="Default_PhysicalDesign_Strategy">
                <BitgenProperty::GeneralOption>
                    <s>off</s>
                </BitgenProperty::GeneralOption>
            </Strategy>
        </Run>
    </Runs>
    <Project_Settings>
        <Step_Last_Change>2022-04-14 18:35:43.124</Step_Last_Change>
    </Project_Settings>
</Project>
