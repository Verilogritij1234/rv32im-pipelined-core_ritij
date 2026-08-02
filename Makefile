# Variables
VERILOG_FILES = cpu_top.v divider.v alu_control.v program_counter.v \
                hardware_multiplier.v memory_interconnect.v if_id_reg.v \
                ex_mem_reg.v forwarding_unit.v hazard_detection.v \
                id_ex_reg.v mem_wb_reg.v ALU.v control_unit.v \
                parameterized_RAM.v regfile.v rom.v cpu_top_tb.v
        
OUTPUT = cpu_top_tb.out

# Default target (Modified to exclude 'waves')
all: compile run

compile:
	iverilog -o $(OUTPUT) $(VERILOG_FILES)

run:
	vvp $(OUTPUT)

waves:
	gtkwave cpu_trace.vcd &

clean:
	rm -f $(OUTPUT) cpu_trace.vcd