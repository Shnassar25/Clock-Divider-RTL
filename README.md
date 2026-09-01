حقك عليّ جداً وبجد بعتذر لكِ، أنا فهمت المشكلة فين بالضبط! المشكلة إنك لما بتحددي الكلام المنسق بالماوس وتعملي له Copy، المتصفح بياخده كلام عادي من غير علامات الـ Markdown (زي `|` بتاعة الجدول و `#` بتاعة العناوين)، فيظهر كأنه كلام على بعضه ومش بيتحول لجدول على GitHub.

علشان تظبط 100%: **اضغطي على زرار "Copy Code" (نسخ الكود) اللي في زاوية المربع الأسود تحت** (ما تحدديش الكلام بإيدك)، وبعدها امسحي أي حاجة جوه `README.md` في VS Code واعملي Paste (`Ctrl + V`).

إليكِ كود الـ Markdown بالكامل من أوله لآخره شامل كل الجداول والأوفر والأركيتكشر والتنسيق:

```markdown
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

```

### 🔑 Key Hardware Features

* **Positive-Edge Sampling ($q_1$):** Generates a baseline pulse on `posedge i_ref_clk`.
* **Negative-Edge Phase Shift ($q_2$):** Samples $q_1$ on `negedge i_ref_clk` to delay the pulse by exactly $0.5 \times T_{clk}$.
* **Phase Combination ($q_1 \mid q_2$):** Merges both signals via an OR gate for odd ratios, extending the HIGH time by half a cycle ($1.5 \times T_{clk}$ for Divide-by-3).
* **Glitch-Free Bypass Mode:** Automatically routes `i_ref_clk` directly to output when `i_div_ratio <= 1` or when clock enable is low.
* **Linting Compliant (STARC05-1.3.1.3):** Asynchronous resets (`i_rst_n`) are isolated exclusively to sequential flip-flop reset pins, keeping them completely out of combinational multiplexer data paths.

---

## 📊 Duty Cycle Mathematical Comparison

| Division Ratio ($N$) | Single-Edge Logic (Initial) | Dual-Edge Phase-Shift (Enhanced) | Target Duty Cycle |
| --- | --- | --- | --- |
| **Divide-by-2 (EVEN)** | 1.0 Cycle HIGH / 1.0 Cycle LOW | Direct Counter Toggle ($q_1$) | **50.0%** |
| **Divide-by-3 (ODD)** | 2.0 Cycles HIGH / 1.0 Cycle LOW | **1.5 Cycles HIGH / 1.5 Cycles LOW** ($q_1 \mid q_2$) | **50.0%** |
| **Divide-by-4 (EVEN)** | 2.0 Cycles HIGH / 2.0 Cycles LOW | Direct Counter Toggle ($q_1$) | **50.0%** |
| **Divide-by-5 (ODD)** | 3.0 Cycles HIGH / 2.0 Cycles LOW | **2.5 Cycles HIGH / 2.5 Cycles LOW** ($q_1 \mid q_2$) | **50.0%** |

---

## 🛠️ STARC05 Linting Rule Resolution

During static linting analysis with **SpyGlass**, the initial multiplexer output assignment flagged a **STARC05-1.3.1.3** violation (*Asynchronous reset signal used as non-reset signal*):

```verilog
// Violating Code:
assign o_div_clk = (!CLK_DIV_EN || !i_rst_n) ? i_ref_clk : o_reg_div_clk;

```

**Fix Applied:** Removed `i_rst_n` from the combinational data path. Asynchronous resets are handled strictly within sequential `always` blocks:

```verilog
// ASIC-Compliant Code:
assign o_div_clk = (!CLK_DIV_EN) ? i_ref_clk : (is_odd ? (q1 | q2) : q1);

```

---

## 📄 Documentation & Verification Report

For full architectural derivations, mathematical proofs, SpyGlass linting logs, and ModelSim waveforms, refer to the full report:

📄 **[Download Design & Verification Report (PDF)](https://www.google.com/search?q=./docs/CLK_DIV_shahd_mahmoud.pdf)**

---

## 📂 Repository Structure

```text
├── rtl/
│   └── clk_div.v                  # Top RTL Design Module
├── tb/
│   └── clk_div_tb.v               # Self-Checking Verilog Testbench
├── docs/
│   └── CLK_DIV_shahd_mahmoud.pdf  # Comprehensive Design Documentation
└── README.md                      # Project Overview

```

---

## 👤 Author

**Shahd Mahmoud**

*Digital IC Design & RTL Verification Engineer*

* LinkedIn: [linkedin.com/in/shahd-mahmoud-abbass](https://www.google.com/search?q=https://linkedin.com/in/shahd-mahmoud-abbass)
* Email: [shahdnassar2542004@gmail.com](https://www.google.com/search?q=mailto%3Ashahdnassar2542004%40gmail.com)

```




