# RISC-V Overview

RISC-V is an open, royalty-free instruction set architecture built for simplicity, flexibility, and innovation. Its modular design makes it a strong foundation for embedded systems, research projects, and custom hardware.

Highlights:
- Open and freely implementable
- Simple instruction set for efficient processor design
- Modular extensions for floating-point, vector, and custom features
- Widely used in education, embedded development, and hardware experimentation

RISC-V continues to be a practical choice for modern CPU design.

In Register file Register x0 is hardwired to zero because having a guaranteed zero is incredibly useful for hardware tricks. For example, RISC-V doesn't have a dedicated COPY instruction. If you want to copy x5 to x6, you just tell the ALU to ADD x5 and x0, and store the result in x6.