echo "compiling llvm and lld"
mkdir install ; cd install
cmake -G Ninja -DCMAKE_BUILD_TYPE="MinSizeRel"  -DLLVM_USE_SPLIT_DWARF=True  -DCMAKE_INSTALL_PREFIX="../install"  -DLLVM_OPTIMIZED_TABLEGEN=True  -DLLVM_BUILD_TESTS=False  -DLLVM_DEFAULT_TARGET_TRIPLE="riscv32-unknown-linux-gnu" -DDEFAULT_SYSROOT="../../riscvio_gnu/riscv32-unknown-linux-gnu" -DLLVM_TARGETS_TO_BUILD="RISCV" -DLLVM_ENABLE_PROJECTS="clang;lld" ../llvm
cmake --build 
echo "moving components to swkit"
cp -rf bin ../../riscvio-swkit/misc/bintools
cp -rf include ../../riscvio-swkit/misc/bintools
cp -rf lib ../../riscvio-swkit/misc/bintools
cp -rf libexec ../../riscvio-swkit/misc/bintools
cp -rf share ../../riscvio-swkit/misc/bintools
