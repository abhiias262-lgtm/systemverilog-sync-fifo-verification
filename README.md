# 🚀 SystemVerilog Synchronous FIFO Verification

A class-based verification environment for a parameterized **Synchronous FIFO** designed and verified using **SystemVerilog**. This project demonstrates an industry-style verification methodology using Generator, Driver, Monitor, Scoreboard, Mailboxes, Virtual Interface, and constrained-random stimulus.

---

# 📌 Project Overview

The objective of this project is to verify the functionality of a parameterized synchronous FIFO using a modular class-based verification environment.

The verification environment has been developed from scratch without using UVM, allowing a deeper understanding of SystemVerilog-based verification concepts.

---

# ✨ Features

- Parameterized Synchronous FIFO RTL
- Class-Based Verification Environment
- Generator
- Driver
- Monitor
- Scoreboard
- Mailbox Communication
- Virtual Interface
- Randomized Test Generation
- Self-Checking Testbench
- FIFO Reference Model using Queue

---

# 📂 Repository Structure

```
systemverilog-sync-fifo-verification
│
├── rtl/
│   └── sync_fifo.sv
│
├── tb/
│   ├── interface.sv
│   ├── transaction.sv
│   ├── generator.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── environment.sv
│   ├── test.sv
│   └── tb_top.sv
│
├── assertions/
│
├── README.md
└── .gitignore
```

---

# 🏗 Verification Architecture

```
          +-------------+
          |  Generator  |
          +-------------+
                 |
                 |
          Mailbox (gen2drv)
                 |
                 v
          +-------------+
          |   Driver    |
          +-------------+
                 |
          Virtual Interface
                 |
                 v
          +-------------+
          |     DUT     |
          | Sync FIFO   |
          +-------------+
                 |
          Virtual Interface
                 |
                 v
          +-------------+
          |   Monitor   |
          +-------------+
                 |
          Mailbox (mon2scb)
                 |
                 v
          +-------------+
          | Scoreboard  |
          +-------------+
```

---

# 🔍 Verification Flow

1. Generator creates randomized FIFO transactions.
2. Driver converts transactions into pin-level DUT signals.
3. DUT performs FIFO operations.
4. Monitor captures DUT activity.
5. Scoreboard compares DUT output against a queue-based reference model.
6. PASS/FAIL messages are generated automatically.

---

# 🧪 Test Cases Verified

- FIFO Reset
- Write Operation
- Read Operation
- Simultaneous Read & Write
- Empty FIFO Read
- Full FIFO Write
- Randomized Transactions
- Queue-Based Data Checking

---

# 🛠 Tools Used

- SystemVerilog
- AMD Vivado Simulator (XSim)
- Git
- GitHub

---

# 📈 Current Status

| Feature | Status |
|----------|--------|
| RTL Design | ✅ Completed |
| Verification Environment | ✅ Completed |
| Randomized Testing | ✅ Completed |
| Scoreboard | ✅ Completed |
| Assertions | 🚧 In Progress |
| Functional Coverage | 🚧 Planned |
| UVM Migration | 🚧 Planned |

---

# 📚 Concepts Practiced

- Object-Oriented Programming (OOP)
- Class-Based Verification
- Mailboxes
- Virtual Interface
- Constrained Random Verification
- Queue-Based Reference Model
- Driver-Monitor Synchronization
- Testbench Architecture
- Debugging Methodology

---

# ⚠ Known Issue

A corner-case mismatch has been observed during the first registered read operation of the FIFO. The issue is currently under investigation and will be addressed in a future revision. This repository is intended to demonstrate the verification methodology and development process.

---

# 🚀 Future Improvements

- SystemVerilog Assertions (SVA)
- Functional Coverage
- Coverage-Driven Verification
- UVM Testbench Migration
- Regression Testing
- Protocol-Based Verification Projects

---

# 👨‍💻 Author

**Abhishek Kumar**

Electronics & Telecommunication Engineering

Interested in RTL Design, Functional Verification, and ASIC Design Flow.

---

# ⭐ If you found this repository useful, consider giving it a Star.
