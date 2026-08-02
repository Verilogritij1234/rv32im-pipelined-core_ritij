Repository Name: rv32im-pipelined-core_ritij_processor
Repository Description: A 32-bit, 5-stage pipelined RISC-V processor core written in Verilog, featuring full hazard detection, data forwarding, and RV32M hardware multiplier/divider support.

-----------------------------------------------------------------------------

# RV32IM 5-Stage Pipelined CPU 🚀

A robust, 32-bit RISC-V processor core implemented in Verilog. This core utilizes a classic 5-stage pipeline architecture (Fetch, Decode, Execute, Memory, Writeback) and supports the base Integer instruction set alongside the **M-extension** (hardware multiplication and division). 

It is designed with complete hazard management, including dynamic data forwarding and pipeline stalling, making it an excellent reference for digital logic, computer architecture, and physical design workflows.

## ✨ Key Features

* **5-Stage Pipeline:** Implements standard IF, ID, EX, MEM, and WB stages with dedicated pipeline registers.
* **RISC-V RV32IM ISA:** Supports standard logic, arithmetic, branching, and jump instructions, plus hardware multiplication and division.
* **Hardware Divider & Multiplier:** Includes dedicated M-extension blocks with stall logic to handle multi-cycle division seamlessly.
* **Advanced Hazard Detection:** Prevents structural and data hazards with dynamic pipeline stalling and flushing on branch mispredictions.
* **Data Forwarding Unit:** Minimizes pipeline stalls by routing `EX/MEM` and `MEM/WB` results directly to the ALU inputs.
* **ASIC / RTL-to-GDSII Ready:** Includes generated gate-level netlists and Design Exchange Format (.def) files from logic synthesis and physical design stages.

## 📂 Project Structure

```text
├── rtl/                        # Verilog source files
│   ├── cpu_top.v               # Top-level CPU wrapper
│   ├── alu.v                   # Arithmetic Logic Unit
│   ├── control_unit.v          # Main instruction decoder
│   ├── divider.v               # Hardware divider module
│   ├── forwarding_unit.v       # Data forwarding logic
│   ├── hazard_detection.v      # Stalls and flushes
│   ├── regfile.v               # 32-bit Register file
│   └── pipeline_regs/          # Pipeline stage registers (IF/ID, ID/EX, etc.)
├── syn/                        # Synthesis and Physical Design outputs
│   ├── netlists/               # Synthesized gate-level netlists (.v)
│   └── def/                    # Design Exchange Format files (.def)
├── assets/                     # OpenROAD layout screenshots
├── tb/                         # Testbenches
│   └── cpu_top_tb.v            # Main testbench for the CPU
├── programs/                   # Software and test programs
│   └── firmware.hex            # Compiled RISC-V machine code
└── README.md                   # Project documentation
```

## 🚀 Prerequisites

To simulate, synthesize, and view the physical layouts of this core, you will need:

* **Icarus Verilog (iverilog):** For running RTL simulations.
* **GTKWave:** For viewing simulation waveforms (`.vcd` files).
* **RISC-V GNU Toolchain:** For compiling C/Assembly code into hex files.
* **Yosys:** For logic synthesis and generating gate-level netlists.
* **OpenROAD:** For the physical design flow (placement, routing) and opening `.def` layouts.

## 💻 Getting Started

### Running a Simulation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/yourusername/rv32im-pipelined-core_ritij_processor.git](https://github.com/yourusername/rv32im-pipelined-core_ritij_processor.git)
   cd rv32im-pipelined-core_ritij_processor
   ```

2. **Compile the Verilog files:**
   ```bash
   iverilog -o cpu_sim tb/cpu_top_tb.v rtl/*.v rtl/pipeline_regs/*.v
   ```

3. **Run the simulation:**
   ```bash
   vvp cpu_sim
   ```

4. **View the waveforms:**
   ```bash
   gtkwave waveforms.vcd
   ```

### Logic Synthesis & Physical Design

* **Synthesis:** Use Yosys to synthesize the design in the `rtl/` directory. Target gate-level netlists are saved in `syn/netlists/`.
* **Layout Viewing:** Use the OpenROAD GUI to open and inspect the physical layout files located in `syn/def/`.

## 🎨 Physical Design & OpenROAD Layouts

Below are the heatmaps and layout views generated during the physical design flow of `cpu_top` using OpenROAD:

| Routing Congestion | Estimated Congestion (RUDY) |
| :---: | :---: |
| <img src="processor_layout_openroad/Screenshot%202026-03-31%20224236.png" width="400"> | <img src="processor_layout_openroad/Screenshot%202026-03-31%20224329.png" width="400"> |

| IR Drop Heatmap | Instance Placement & Inspector |
| :---: | :---: |
| <img src="processor_layout_openroad/Screenshot%202026-03-31%20224350.png" width="400"> | <img src="processor_layout_openroad/Screenshot%202026-03-31%20224501.png" width="400"> |

## 🛠️ Future Improvements

- [ ] Add support for the **C (Compressed)** instruction extension.
- [ ] Implement a basic L1 Cache (Instruction / Data).
- [ ] Integrate a UART peripheral into the memory map for console output.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
