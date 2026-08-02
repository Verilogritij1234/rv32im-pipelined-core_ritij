# RV32IM 5-Stage Pipelined CPU 🚀

A robust, 32-bit RISC-V processor core implemented in Verilog. This core utilizes a classic 5-stage pipeline architecture (Fetch, Decode, Execute, Memory, Writeback) and supports the base Integer instruction set alongside the **M-extension** (hardware multiplication and division). 

It is designed with complete hazard management, including dynamic data forwarding and pipeline stalling, making it an excellent reference for advanced digital logic and computer architecture studies.

## ✨ Key Features

* **5-Stage Pipeline:** Implements standard IF, ID, EX, MEM, and WB stages with dedicated pipeline registers.
* **RISC-V RV32IM ISA:** Supports standard logic, arithmetic, branching, and jump instructions, plus hardware multiplication and division.
* **Hardware Divider & Multiplier:** Includes dedicated M-extension blocks with stall logic to handle multi-cycle division seamlessly.
* **Advanced Hazard Detection:** Prevents structural and data hazards with dynamic pipeline stalling and flushing on branch mispredictions.
* **Data Forwarding Unit:** Minimizes pipeline stalls by routing `EX/MEM` and `MEM/WB` results directly to the ALU inputs.
* **Memory Interconnect:** Clean abstraction for hooking up instruction ROM, data RAM, and memory-mapped peripherals (like UART).

## 🏗️ Architecture Overview

The CPU (`cpu_top.v`) is broken down into modular components:

1. **Instruction Fetch (IF):** 
   - `program_counter`: Manages the current execution address.
   - `rom`: Instruction memory (1024x32).
2. **Instruction Decode (ID):**
   - `control_unit`: Decodes opcodes and drives control signals.
   - `regfile`: 32x32-bit dual-port register file.
3. **Execute (EX):**
   - `ALU`: Computes arithmetic, logic, and branch target calculations.
   - `hardware_multiplier` / `divider`: Handles RV32M instructions. Stalls the pipeline automatically while dividing.
   - `forwarding_unit`: Muxes in data from later stages to resolve read-after-write (RAW) dependencies.
4. **Memory (MEM):**
   - `memory_interconnect`: Unified bus handling reads/writes to external memory/peripherals.
5. **Writeback (WB):**
   - Routes memory data or ALU results back into the register file.

## 📂 Project Structure

\`\`\`text
├── rtl/
│   ├── cpu_top.v             # Top-level CPU wrapper (The file above)
│   ├── alu.v                 # Arithmetic Logic Unit
│   ├── control_unit.v        # Main instruction decoder
│   ├── divider.v             # Hardware divider module
│   ├── forwarding_unit.v     # Data forwarding logic
│   ├── hazard_detection.v    # Stalls and flushes
│   ├── regfile.v             # 32-bit Register file
│   └── pipeline_regs/        # if_id, id_ex, ex_mem, mem_wb registers
├── tb/
│   └── cpu_top_tb.v          # Main testbench
├── programs/
│   └── firmware.hex          # Compiled RISC-V machine code
└── README.md
\`\`\`

## 🚀 Getting Started

### Prerequisites

To simulate and synthesize this core, you will need:
* **Icarus Verilog (iverilog)** for simulation.
* **GTKWave** for viewing waveform `.vcd` files.
* A RISC-V GNU Toolchain (if you plan to write and compile your own C/Assembly code).

### Running a Simulation

1. **Clone the repository:**
   \`\`\`bash
   git clone https://github.com/yourusername/rv32im-pipelined-core.git
   cd rv32im-pipelined-core
   \`\`\`

2. **Compile the Verilog files:**
   \`\`\`bash
   iverilog -o cpu_sim tb/cpu_top_tb.v rtl/*.v rtl/pipeline_regs/*.v
   \`\`\`

3. **Run the simulation:**
   \`\`\`bash
   vvp cpu_sim
   \`\`\`

4. **View the waveforms:**
   \`\`\`bash
   gtkwave waveforms.vcd
   \`\`\`

## 🛠️ Future Improvements

- [ ] Add support for the **C (Compressed)** instruction extension.
- [ ] Implement a basic L1 Cache (Instruction / Data).
- [ ] Integrate a UART peripheral into the memory map for console output.
- [ ] Port to an FPGA (e.g., Artix-7) and test on hardware.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
