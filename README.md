# RISCV32 Core From Scratch

This repository contains a simple single-cycle 32-bit RISC-V core written in Verilog, along with unit-level and top-level testbenches.

## Project overview

The design models the core datapath stages in a compact way:

1. **Fetch**  
   The program counter (`program_counter.v`) provides the current instruction address.  
   Instruction memory (`Instruction_memory.v`) returns the instruction from `instruction.hex`.

2. **Decode**  
   The instruction decoder (`instruction_decoder.v`) extracts opcode/register/function fields and generates sign-extended immediates.  
   The control unit (`control_unit.v`) generates main control signals from opcode.  
   The register file (`register_file.v`) provides source operands and accepts write-back data.

3. **Execute**  
   ALU control (`alu_control_unit.v`) converts high-level ALUOp + funct fields into a concrete ALU select signal.  
   The ALU (`alu_32bit.v`) performs arithmetic/logic/shift/compare operations and generates status flags.

4. **Memory**  
   Data memory (`data_memory.v`) supports word-aligned read/write behavior for load/store flow.

5. **Write-back**  
   The core selects ALU result or memory read data and writes it back to `rd` when `reg_write` is enabled.

The top-level integration is in `riscv_core.v`, where control and datapath wiring are connected.

## Supported instruction groups in this implementation

- **R-type arithmetic/logic** (opcode `0110011`)
- **I-type arithmetic/immediate** (opcode `0010011`)
- **Load** (opcode `0000011`)
- **Store** (opcode `0100011`)
- **Branch** (opcode `1100011`, branch decision uses `branch & zero`)

## Register x0 behavior

`x0` is hardwired to zero in `register_file.v`:
- Reads from `x0` always return `0`
- Writes to `x0` are blocked

This matches standard RISC-V behavior and simplifies many instruction patterns.

## File-by-file explanation

### Core design files

- **`riscv_core.v`**  
  Top-level CPU integration. Instantiates all modules and connects fetch, decode, execute, memory, and write-back paths.

- **`program_counter.v`**  
  PC register with async reset; updates PC to `next_pc` on clock edge.

- **`Instruction_memory.v`**  
  Instruction ROM-style memory. Loads program using `$readmemh("instruction.hex", memory)` and fetches by `pc[31:2]`.

- **`instruction_decoder.v`**  
  Breaks instruction into opcode/rd/rs1/rs2/funct fields and builds sign-extended immediates for I/S/B formats.

- **`control_unit.v`**  
  Main decoder from opcode to control signals (`branch`, `mem_read`, `mem_to_reg`, `alu_op`, `mem_write`, `alu_src`, `reg_write`).

- **`alu_control_unit.v`**  
  Maps `alu_op` + `funct3` + `funct7` bit into 4-bit ALU select codes.

- **`alu_32bit.v`**  
  32-bit ALU implementing add, sub, and/or/xor, shifts, signed/unsigned set-less-than, plus `zero/carry/overflow`.

- **`register_file.v`**  
  32×32 register array with two combinational read ports and one synchronous write port.

- **`data_memory.v`**  
  Word-addressed RAM array for load/store operations, with synchronous write and combinational read.

### Program input file

- **`instruction.hex`**  
  Hex-encoded instruction words loaded into instruction memory at simulation start.

### Testbench files

- **`tb_program_counter.v`**  
  Verifies reset and sequential PC updates.

- **`tb_instruction_memory.v`**  
  Verifies instruction fetch behavior for multiple PC values and out-of-range access.

- **`tb_instruction_decoder.v`**  
  Tests field extraction and immediate generation across R/I/S/B examples.

- **`tb_control_unit.v`**  
  Validates control signal outputs for supported opcode classes.

- **`tb_alucontrol_unit.v`**  
  Validates ALU select output mapping for load/store, branch, and ALU instruction cases.

- **`tb_data_memory.v`**  
  Tests store and load behavior and write-enable safety checks.

- **`tb_register_file.v`**  
  Tests register writes/reads and confirms `x0` remains zero.

- **`tb_riscv_core.v`**  
  System-level simulation of the integrated core and internal signal observation.

## How to use this project

1. Put your program instructions in `instruction.hex`.
2. Run module-level testbenches for focused debugging.
3. Run `tb_riscv_core.v` for end-to-end core behavior.
4. Inspect waveform/console output to validate datapath and control flow.