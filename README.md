# UART Protocol Implementation on Nexys A7 FPGA

This repository documents the completed development of a **Dual-FPGA UART System**: A Full Duplex Hardware Communication Design using Verilog HDL, targeting the Digilent **Nexys A7 FPGA** development board.

---

## ✅ Project Status: Completed

This project has been fully implemented, simulated, and verified on hardware. All modules, testbenches, and demo logs are available in the repository.

---

## 📌 Project Overview

The goal of this project was to build a **fully functional UART communication module** on the Nexys A7 FPGA. UART (Universal Asynchronous Receiver/Transmitter) enables serial communication between the FPGA and other devices like PCs, microcontrollers, or peripherals using RS-232 or USB-UART bridges.

---

## 🎯 Objectives Achieved

- ✅ Defined UART timing and protocol specifications  
- ✅ Designed transmitter (TX) and receiver (RX) modules in Verilog  
- ✅ Created testbenches for simulation and verification  
- ✅ Interfaced UART with on-board resources (switches, LEDs, buttons, 7-segment display)  
- ✅ Verified communication with external devices using USB-UART (PuTTY terminal)

---

## ⚙️ Target Platform

- **FPGA Board**: Digilent Nexys A7  
- **FPGA Device**: Xilinx Artix-7 (XC7A100T)  
- **Toolchain**: Vivado Design Suite (Synthesis, Implementation, Simulation)

---

## 🧩 Modules Overview

The design consists of the following Verilog modules:

- **Transmitter (uart_tx.v)**: Serially transmits data to external devices
- **Receiver (uart_rx.v)**: Receives serial data and converts to parallel
- **Top Module (uart_top.v)**: Integrates TX, RX, and display interface logic
- **ASCII to 7-Segment (ascii_to_7seg.v)**: Converts received ASCII characters to 7-segment encoding to display on the FPGA's onboard 7-segment display

---

## 🧪 Simulation and Testing

- A dedicated **testbench** is included to simulate the UART communication logic (excluding the `ascii_to_7seg` module).
- Simulations were run using Vivado's built-in simulator.
- Timing, start/stop bits, and baud rate accuracy were verified.
- Real hardware testing was done using PuTTY connected via USB-UART.

---

## 📂 Repository Structure

```
├── Design files/transmitter.v,receiver.v,uart_top_module.v and Ascii_to_7seg.v  # Verilog HDL files: uart_tx, uart_rx, uart_top, ascii_to_7seg
├── Testbench/uart_tb                                                            # Testbenches for simulation (excluding display module)
├── Nexys_A7_100T.xdc for the N/                                                 # Nexys A7 100T port-mapped XDC file
├── UART Documentation/                                                          # Detailed design documentation
├── Working video/                                                               #Added working of UART communication between 2 FPGA
├── README.md                                                                    # Project documentation
```

---

## 📄 License

[MIT](LICENSE) – Free to use, modify, and distribute with proper attribution.

---

## 👥 Contributors

- **Naveen Kumar B** – [naveenau2023@gmail.com](mailto:naveenau2023@gmail.com)  
- **Hemanth S**  -(github profile: https://github.com/hemanth028)
- **Sabarish Mohan JS** - (github profile: https://github.com/sabarishmohanjs)

---

## 📬 Feedback & Collaboration

We welcome discussions, suggestions, and contributions! Feel free to open issues or submit pull requests for improvements or extensions.
