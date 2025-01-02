// A 14-bit constant greater than 4.
def uimm14 : RISCVUImmOp<14>, ImmLeaf<XLenVT, [{
  return Imm < 16384 && Imm > 3;
}]>;

def OPC_OR : RISCVOpcode<"OR", 0b0001011>;

let hasSideEffects = 1, mayLoad = 0, mayStore = 0 in {
  class Alc_i<bits<3> funct3, string opcodestr, DAGOperand rty = GPR>
    : RVInstI<funct3, OPC_OR, (outs rty:$rd), (ins uimm14:$imm14),
              opcodestr, "$rd, ${imm14}">, Sched<[]> {
    bits<14> imm14;
    let imm12 = imm14{13-2};
    let rs1 = 0b00010;
  }
}

let Predicates = [HasStdExtZor, IsRV32] in {
  def ALCI  : Alc_i<0b010, "alci">;
  def : Pat<(int_riscv_alci uimm14:$imm14), (ALCI uimm14:$imm14)>;

  def ALC : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2 = 0b00000;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 1;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-25} = 0b0000000; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b000; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b0001011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1);
      let AsmString = "alc\t$rd, $rs1";
  }
  def : Pat<(int_riscv_alc GPR:$rs1), (ALC GPR:$rs1)>;

  def ALCI_D : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<12> imm12;
      bits<5> rs1 = 0b00010;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 1;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-20} = imm12;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b011; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b0001011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins simm12:$imm12);
      let AsmString = "alci.d\t$rd, $imm12";
  }
  def : Pat<(int_riscv_alci_d simm12:$imm12), (ALCI_D simm12:$imm12)>;

  def ALC_D : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2 = 0b00000;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 1;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-25} = 0b0000000; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b001; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b0001011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1);
      let AsmString = "alc.d\t$rd, $rs1";
  }
  def : Pat<(int_riscv_alc_d GPR:$rs1), (ALC_D GPR:$rs1)>;

  def QSZ : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2 = 0b00000;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 0;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-25} = 0b0000000; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b100; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b0001011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1);
      let AsmString = "qsz\t$rd, $rs1";
  }
  def : Pat<(int_riscv_qsz GPR:$rs1), (QSZ GPR:$rs1)>;


  def DTP : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 0;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-25} = 0b0111111; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b000; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b1110011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1, GPR:$rs2);
      let AsmString = "dtp\t$rd, $rs1,$rs2";
  }
  def : Pat<(int_riscv_dtp GPR:$rs1, GPR:$rs2), (DTP GPR:$rs1, GPR:$rs2)>;

  def BTD : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2 = 0b00000;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 0;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-25} = 0b1011111; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b000; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b1110011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1);
      let AsmString = "btd\t$rd, $rs1";
  }
  def : Pat<(int_riscv_btd GPR:$rs1), (BTD GPR:$rs1)>;

  def ITD : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2 = 0b00000;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 0;
      let mayLoad = 0;
      let mayStore = 0;
      let Inst{31-25} = 0b1101111; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b000; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b1110011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1);
      let AsmString = "itd\t$rd, $rs1";
  }
  def : Pat<(int_riscv_itd GPR:$rs1), (ITD GPR:$rs1)>;

  def LW_X : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2 = 0b00000;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 0;
      let mayLoad = 1;
      let mayStore = 0;
      let Inst{31-25} = 0b1110111; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b000; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b1110011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1);
      let AsmString = "lw.x\t$rd, $rs1";
  }
  def : Pat<(int_riscv_lw_x GPR:$rs1), (LW_X GPR:$rs1)>;

  def SW_X : Instruction {
      bits<32> Inst;
      bits<32> SoftFail = 0;
      bits<5> rs2;
      bits<5> rs1;
      bits<5> rd;
      let Namespace = "RISCV";
      let Size = 4;
      let hasSideEffects = 0;
      let mayLoad = 0;
      let mayStore = 1;
      let Inst{31-25} = 0b1111011; /*funct7*/  
      let Inst{24-20} = rs2;
      let Inst{19-15} = rs1;
      let Inst{14-12} = 0b000; /*funct3*/
      let Inst{11-7} = rd;
      let Inst{6-0} = 0b1110011; /*opcode*/
      dag OutOperandList = (outs GPR:$rd);
      dag InOperandList = (ins GPR:$rs1, GPR:$rs2);
      let AsmString = "sw.x\t$rd, $rs1,$rs2";
  }
  def : Pat<(int_riscv_sw_x GPR:$rs1, GPR:$rs2), (SW_X GPR:$rs1, GPR:$rs2)>;

}