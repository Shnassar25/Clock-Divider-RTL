# ⏱️ Configurable Clock Divider (EVEN & ODD 50% Duty Cycle)

An ASIC-compliant, parameterized **Clock Divider** implemented in Verilog HDL. This module dynamically derives lower-frequency clocks from a primary reference clock (`i_ref_clk`) across configurable integer division ratios (`i_div_ratio`), guaranteeing a **strict 50% Duty Cycle** for both **EVEN** and **ODD** division ratios.

---

## 📌 Project Overview & The Engineering Challenge

Standard single-edge clock dividers rely exclusively on `posedge i_ref_clk`. While this works seamlessly for EVEN division ratios, ODD ratios (Divide-by-3, 5, 7...) present a unique hardware bottleneck:
* **The Problem:** Because output state transitions occur only on full integer clock cycles ($1.0, 2.0, 3.0 \dots$), an odd ratio $N$ cannot be evenly split by 2 using single-edge logic alone. This results in non-symmetric outputs (e.g., **66.7% Duty Cycle** for Divide-by-3 with 2 cycles HIGH / 1 cycle LOW).
* **The Impact:** In high-speed SoC architectures, non-50% duty cycles degrade setup and hold time margins for dual-edge logic and inter-domain communications.

---

## 💡 Architectural Solution: Dual-Edge Phase-Shifting

To achieve a true 50% duty cycle ($N/2$ HIGH time), fractional $0.5 \times T_{clk}$ clock phases must be generated using **both positive and negative clock edges**:

```text
               +---+   +---+   +---+   +---+   +---+   +---+
i_ref_clk      |   |___|   |___|   |___|   |___|   |___|   |___
               
q1 (posedge)   +-------+               +-------+
               |       |_______________|       |_______________ (1.0 cycle HIGH)
               
q2 (negedge)       +-------+               +-------+
               ____|       |_______________|       |___________ (0.5 cycle phase shift)
               
o_div_clk      +-----------+           +-----------+
(q1 | q2)      |           |___________|           |___________ (1.5 cycles HIGH / 1.5 cycles LOW = 50%)