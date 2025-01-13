clear
cmake --build .
bin/clang -target riscv32-unknown-elf -march=rv32i_zbb_zor -mcmodel=medany -Wno-incompatible-library-redeclaration -fno-addrsig -fomit-frame-pointer -nostdlib  -r test.c -o test.o
bin/llvm-readelf -a test.o > test.ol
bin/ld.lld -L. vio_std_lib.so -o test.elf test.o
bin/llvm-readelf -a test.elf > test.elfll
bin/llvm-objdump -D -M no-aliases test.elf > test.elfl
bin/llvm-objdump -a -s -j .got -j .got.plt test.elf >> test.elfl
