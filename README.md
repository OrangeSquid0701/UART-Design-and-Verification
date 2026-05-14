# UART Transmitter Overview
The UART transmitter takes data (usually 8-bit parallel data) and sends it one bit at a time in a specific format. It allows devices such as microcontrollers, sensors, computers, and embedded systems to communicate using only a few wires.

## Block Digram
<div align="center">
  <img width="500" alt="AHB Logo" src="https://github.com/user-attachments/assets/66db8d70-92e4-42f8-8732-b48a551c7c78" />
  <p><i>Figure 1: UART Serial Transmission Timing Diagram</i></p>
</div>

<div align="center">
  <img width="1537" height="307" alt="image" src="https://github.com/user-attachments/assets/99049196-7116-4585-8c01-b94e81afd4c7" />
  <p><i>Figure 2: Vivado Simulation Waveform sending 8'h55 and 8'hAA</i></p>
</div>



## File Directories
UART Transmitter
   - source
        - UART_CU.v (FSM)
        - UART_DU.v (Baud Rate Counter, Bit Counter, Output Multiplexer)
        - UART_TOP.v (CUDU connection)
   - simulation
        - uart_tb.v (verilog testbench)

## Signal Descriptions
1. UART_TOP.v [parameter BAUD]

| Signal Name | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | System Clock |
| `rst` | Input | 1 | Active Low Reset |
| `tx_din` | Input | 8 | Parallel Data |
| `tx_start` | Input | 1 | Active high user-controlled start button |
| `tx_pin` | Output | 1 | Serial Data |
| `tx_ready` | Output | 1 | System in IDLE state when HIGH and ready for transmission |

2. UART_CU.v

| Signal Name | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | System Clock |
| `rst` | Input | 1 | Active Low Reset |
| `tx_start` | Input | 1 | Active high user-controlled start button |
| `baud_tick` | Input | 1 | HIGH when reached baud rate |
| `bit_done` | Input | 1 | HIGH when done bit asserted and serial data sent |
| `load_en` | output | 1 | Send HIGH to DU when loading parallel data |
| `shift_en` | output | 1 | Send HIGH to DU when shifting out the data |
| `tx_sel` | output | 2 | select pin to DU for output mux |
| `ready` | output | 1 | IDLE state and ready for transmission |

4. UART_DU.v

| Signal Name | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | System Clock |
| `rst` | Input | 1 | Active Low Reset |
| `tx_din` | Input | 8 | Parallel Data |
| `load_en` | Input | 1 | Receive HIGH from CU to load parallel data |
| `shift_en` | Input | 1 | Receive HIGH from CU to shift out the data |
| `tx_sel` | Input | 2 | Receive select pin (2'b00 = 1, 2'b01 = data, 2'b10 = 0) |
| `baud_tick` | output | 1 | Send HIGH to CU when reached baud rate |
| `bit_done` | output | 1 | Send HIGH to CU when sent all serial data |
| `tx_out` | output | 1 | output tx pin |
