# FPGA-Projects
Repo containing all my fpga projects. No matter, how big or small
### Hardware & Software used

| Category       | Details                                                                 |
|----------------|-------------------------------------------------------------------------|
| **FPGA Board** | [Zybo Z7 – Zynq-7000 ARM/FPGA SoC Development Board](https://digilent.com/reference/programmable-logic/zybo-z7/start) |
| **Software**   | Xilinx **Vivado**                                                       |

## Foundation Projects
These projects were completed to build convidence when using my FPGA board and to learn the basics of verilog. Below is a table each of my projects in this directory.

| Project Name            | Description                                                      | Directory Link                                     | Topics Covered                     |
|--------------------------|------------------------------------------------------------------|----------------------------------------------------|------------------------------------|
| Blinking LED             | First FPGA project: simple clock divider toggling an LED.        | [Foundation/Blinking LED](Foundation/Blinking%20LED) | Clock dividers, sequential logic   |
| Random Number Generator  | Generates a pseudo-random number displayed via LEDs.             | [Foundation/Random Number Generator](Foundation/Random%20Number%20Generator) | LFSR, state machines   |
| LED PWM                  | Implements pulse-width modulation to control LED brightness.     | [Foundation/LED PWM](Foundation/LED%20PWM)         | Pulse width modulation  |
| Basic UART Operation     | UART transmitter to send data between FPGA and PC terminal.      | [Foundation/Basic UART operation](Foundation/Basic%20UART%20operation) | Serial comms, FSM, baud generation |

These are the projects that then lead me to develop reusable modules I can use in later more advanced projects.

### TABLE OF DIRS FOR MY REUSABLE MODULES


