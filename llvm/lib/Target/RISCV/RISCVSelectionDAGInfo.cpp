//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "RISCVSelectionDAGInfo.h"
#include "MCTargetDesc/RISCVMCTargetDesc.h"
#include "RISCVISelLowering.h"
#include "RISCVSubtarget.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/Support/Casting.h"
#include <utility>

using namespace llvm;

RISCVSelectionDAGInfo::~RISCVSelectionDAGInfo() = default;

bool RISCVSelectionDAGInfo::isTargetMemoryOpcode(unsigned Opcode) const {
  return Opcode >= RISCVISD::FIRST_MEMORY_OPCODE &&
         Opcode <= RISCVISD::LAST_MEMORY_OPCODE;
}

bool RISCVSelectionDAGInfo::isTargetStrictFPOpcode(unsigned Opcode) const {
  return Opcode >= RISCVISD::FIRST_STRICTFP_OPCODE &&
         Opcode <= RISCVISD::LAST_STRICTFP_OPCODE;
}

std::pair<SDValue, SDValue>
RISCVSelectionDAGInfo::EmitTargetCodeForMalloc(SelectionDAG &DAG, const SDLoc &DL, SDValue Chain,
                        SDValue Src) const {
  if (!DAG.getSubtarget<RISCVSubtarget>().hasStdExtZhm())
    return std::make_pair(SDValue(), SDValue());

  EVT PtrVT = MVT::getIntegerVT(DAG.getDataLayout().getPointerSizeInBits());
  
  SDValue AlcInstr;
  if (ConstantSDNode* Int = dyn_cast<ConstantSDNode>(Src.getNode())) {
    if (Int->getConstantIntValue()->getZExtValue() >= 4 && Int->getConstantIntValue()->getZExtValue() < (1<<14)) {
      AlcInstr = SDValue(DAG.getMachineNode(RISCV::ALCI, DL, PtrVT, DAG.getTargetConstant(*Int->getConstantIntValue(), DL, MVT::i32)), 0);
      return std::make_pair(AlcInstr, Chain);
    }
  }

  AlcInstr = SDValue(DAG.getMachineNode(RISCV::ALC, DL, PtrVT, Src), 0);
  return std::make_pair(AlcInstr, Chain);
}