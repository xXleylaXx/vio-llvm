add_llvm_component_group(ObjectiveRISC)

set(LLVM_TARGET_DEFINITIONS ObjectiveRISC.td)

tablegen(LLVM ObjectiveRISCGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM ObjectiveRISC.inc -gen-register-info)

add_llvm_target(
  
)

