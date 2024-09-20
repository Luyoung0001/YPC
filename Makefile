VERILATOR = verilator
SRC = main.cpp YPC.v
OBJ_SRC = hello.c
OBJ_BIN = prog.bin
OBJ_TARGET = prog
OBJ_DIR = obj_dir
RV32GCC = riscv64-linux-gnu-gcc -march=rv32g -mabi=ilp32
CFLAGS = -ffreestanding -nostdlib -static -Wl,-Ttext=0 -O2

RV64OBJCOPY = riscv64-linux-gnu-objcopy
RV64CP_FLAGS = -j .text -O binary

EXE = $(OBJ_DIR)/VYPC

build: $(EXE)

$(EXE): $(SRC)
	bear -- $(VERILATOR) --cc --trace --exe --build $^
	make -C $(OBJ_DIR) -f VYPC.mk

run: $(EXE) $(OBJ_BIN)
	@$(EXE) $(OBJ_BIN)

$(OBJ_TARGET): $(OBJ_SRC)
	$(RV32GCC) $(CFLAGS) -o $@ $^

$(OBJ_BIN): $(OBJ_TARGET)
	$(RV64OBJCOPY) $(RV64CP_FLAGS) $^ $@
clean:
	@rm -rf $(OBJ_DIR) prog* 

.PHONY: build run clean
