# UART Protocol Implementation on Nexys A7 FPGA

This repository contains the ongoing development of a UART (Universal Asynchronous Receiver/Transmitter) protocol implementation using Verilog HDL, targeting the Digilent **Nexys A7 FPGA** development board.

---

## 🚧 Project Status: In Progress

This is an **active and ongoing project**. The repository will be updated progressively as each development stage is completed. Check back regularly for new modules, testbenches, and simulation/demo files.

---

## 📌 Project Overview

The goal of this project is to build a **fully functional UART communication module** on the Nexys A7 FPGA. The UART protocol enables serial communication between the FPGA and other devices like PCs, microcontrollers, or peripherals over RS-232 or USB-UART bridges.

---

## 🎯 Objectives

- ✅ Understand and define UART timing and protocol specifications  
- ⏳ Design transmitter (TX) and receiver (RX) modules in Verilog  
- ⏳ Create testbenches for functional simulation and verification  
- ⏳ Interface UART with on-board resources (e.g., switches, LEDs, buttons)  
- ⏳ Validate communication with external devices via USB-UART (e.g., using a terminal like PuTTY)

---

## ⚙️ Target Platform

- **FPGA Board**: Digilent Nexys A7  
- **FPGA Device**: Xilinx Artix-7 (XC7A100T)  
- **Toolchain**: Vivado Design Suite (Synthesis, Implementation, Simulation)

---

## 🗂 Planned Repository Structure

```
├── rtl/               # UART transmitter and receiver modules (in progress)
├── tb/                # Testbench files for simulation
├── README.md           
├── Sample_outputs              
```

---

## 🧪 Simulation and Testing

Simulation will be performed using Vivado's built-in simulator or ModelSim. Baud rate, parity, stop/start bits, and timing parameters will be verified against the UART spec.

---

## 📄 License

[MIT](LICENSE) – Feel free to use and modify with attribution.

---

## 📬 Updates & Contributions

This repository will be updated **step-by-step** as the design progresses:

- Module development
- Simulation testbenches
- Integration and board-level testing
- Demo videos or terminal logs

Stay tuned for new commits or raise issues/discussions if you're interested in contributing or collaborating.
