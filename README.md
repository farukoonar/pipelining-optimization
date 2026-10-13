# FPGA Static Timing Analysis (STA) & Pipelining Optimization on Basys 3

**[TR]** Xilinx Artix-7 (Basys 3) FPGA üzerinde 8 girişli 8-bit toplayıcı mimarisinin 250 MHz ($4.0\text{ ns}$) saat frekansındaki Statik Zamanlama Analizi (STA); kritik yol (critical path) gecikmelerinin incelenmesi ve boru hattı (pipelining / adder tree) tekniği ile zamanlama kapatma (timing closure) optimizasyonu.  
**[EN]** Static Timing Analysis (STA) of an 8-operand 8-bit adder on a Xilinx Artix-7 (Basys 3) FPGA at 250 MHz ($4.0\text{ ns}$); deep dive into critical path delays and achieving timing closure using pipelined adder-tree architecture.

---

## Karşılaştırma Özeti / Benchmark & Timing Summary

| Metrik / Metric | Unpipelined (Kombinasyonel) | Pipelined (Boru Hattı) | 
| :--- | :---: | :---: | 
| **Hedef Saat Frekansı (Target Clock)** | 250 MHz ($4.0\text{ ns}$) | 250 MHz ($4.0\text{ ns}$) |
| **Worst Negative Slack (WNS)** | **`-0.994 ns` (FAIL)** | **`+1.341 ns` (MET)** | 
| **Total Negative Slack (TNS)** | `-5.391 ns` | `0.000 ns` | 
| **Hatalı Uç Noktalar (Failing Endpoints)** | 7 / 11 | 0 / 67 | 
| **Tahmini Maks. Frekans ($F_{\max}$)** | $\approx 200\text{ MHz}$ | $\approx \mathbf{375\text{ MHz}}$ |
| **İşlem Gecikmesi (Latency)** | 1 Saat Çevrimi | 3 Saat Çevrimi | 
| **Verim (Throughput)** | 1 İşlem / Çevrim | 1 İşlem / Çevrim | 
| **Toplam Uç Nokta (Registers/Endpoints)** | 11 | 67 | 

---

## Mimari ve Pipelining / Architecture & Pipelining
**[TR]** 
* **Unpipelined Mimari (`adder.vhd`):** 8 adet 8-bitlik giriş tek bir saat çevriminde ardışık olarak toplanır. Sinyal tek bir clock periyodunda kaynak flip-floptan hedef flip-flopa ulaşmak zorunda kaldığı için kritik yol gecikmesi $4.0\text{ ns}$ sınırını aşar.
* **Pipelined Mimari (`adder_pipelined.vhd`):** Toplama işlemi **Ağaç Toplayıcı (Adder Tree)** yapısına bölünmüş ve modül içine 2 kademe boru hattı register'ı yerleştirilmiştir:
  * **Level 1:** 8 giriş ikişerli toplanarak 4 ara toplama (`sum_ab, sum_cd, sum_ef, sum_gh`) indirgenir ve register'a alınır $\rightarrow$ 36 FF.
  * **Level 2:** 4 ara toplam ikişerli toplanarak 2 ara toplama (`sum_abcd, sum_efgh`) indirgenir ve register'a alınır $\rightarrow$ 20 FF.
  * **Çıkış Katı:** Son 2 ara toplam kombinasyonel olarak toplanır (`sum_o`) ve `top.vhd` içerisindeki çıkış register'ı tarafından yakalanır $\rightarrow$ 11 FF.

**[EN]** 
* **Unpipelined Architecture (`adder.vhd`):** All 8 8-bit operands are added sequentially within a single clock cycle. Because the signal must travel from the source flip-flop to the destination flip-flop in a single clock period, the critical path delay exceeds the $4.0\text{ ns}$ limit.
* **Pipelined Architecture (`adder_pipelined.vhd`):** Partitioned into an **Adder Tree** structure with 2 internal pipeline register stages:
  * **Level 1:** Pairs 8 operands into 4 intermediate 9-bit sums (`sum_ab, sum_cd, sum_ef, sum_gh`) captured in registers $\rightarrow$ 36 FFs.
  * **Level 2:** Pairs 4 intermediate sums into 2 intermediate 10-bit sums (`sum_abcd, sum_efgh`) captured in registers $\rightarrow$ 20 FFs.
  * **Output Stage:** The final 2 sums are combined combinationally (`sum_o`) and captured by the output register in `top.vhd` $\rightarrow$ 11 FFs.


<img width="1304" height="1152" alt="WhatsApp Image 2026-10-13 at 1 45 25 PM" src="https://github.com/user-attachments/assets/a41e87ce-aef8-4013-b19c-9a39086ee21e" />


> **Throughput vs. Latency:**  
> **[TR]** Pipelining ile ilk sonucun çıkma süresi (Latency) 3 saat vuruşuna çıkmıştır; ancak boru hattı dolduktan sonra devre her saat vuruşunda yeni bir sonuç ürettiği için (Throughput = 1 işlem/çevrim) sistem 200 MHz sınırından **375 MHz** seviyesine taşınmıştır.  
> **[EN]** While latency increases from 1 to 3 cycles, throughput remains 1 result per cycle once the pipeline fills, boosting maximum operating frequency from 200 MHz to **375 MHz**.
---

## Statik Zamanlama Analizi (STA) / Static Timing Analysis Breakdown

### 1. Optimize Edilmemiş Tasarım (Zamanlama İhlali) / Unpipelined Design (Timing Violation)
**[TR]** $250\text{ MHz}$ ($4.0\text{ ns}$) hedefinde toplayıcı yolu zaman kısıtına yetişememiş ve **`-0.994 ns`** negatif slack vermiştir:  
**[EN]** At the $250\text{ MHz}$ ($4.0\text{ ns}$) target, the adder data path failed to meet the timing constraint, resulting in a negative slack of **`-0.994 ns`**:

<img width="1024" height="192" alt="image" src="https://github.com/user-attachments/assets/6d06608c-3ca5-44ab-ab99-ac365382b070" />



#### Kritik Yol Analizi (Critical Path Detail):
**[TR]**
* **Arrival Time (Varış Zamanı) = 9.616 ns:** Sinyal `reg_g_reg[1]` kaynak noktasından çıkıp 4 LUT ve 4 CARRY4 bloğunu aşarak hedef `sum_o_reg[9]` kapısına ancak $9.616\text{ ns}$ anında varabilmiştir.
* **Required Time (Gereken Zaman) = 8.622 ns:** Saat kenarı ve kurulum süresi (setup time) gereği sinyalin en geç $8.622\text{ ns}$ anında hazır olması gerekirdi.
* $$\text{Slack} = \text{Required Time} - \text{Arrival Time} = 8.622\text{ ns} - 9.616\text{ ns} = \mathbf{-0.994\text{ ns}}\quad (\text{Setup Violation!})$$

**[EN]**
* **Data Arrival Time = 9.616 ns:** The signal launches from `reg_g_reg[1]`, traverses through 4 LUTs and 4 CARRY4 blocks, and arrives at the destination `sum_o_reg[9]` pin at $9.616\text{ ns}$.
* **Data Required Time = 8.622 ns:** Considering the destination clock edge and internal setup time, the signal was required to be stable at the pin by $8.622\text{ ns}$ at the latest.
* $$\text{Slack} = \text{Required Time} - \text{Arrival Time} = 8.622\text{ ns} - 9.616\text{ ns} = \mathbf{-0.994\text{ ns}}\quad (\text{Setup Violation!})$$

<img width="1024" height="534" alt="image" src="https://github.com/user-attachments/assets/8c9511bc-be40-40a1-bf47-bc15ccc49715" />
<img width="1024" height="444" alt="image" src="https://github.com/user-attachments/assets/8f80fa79-eeda-48e4-80d6-3bac6e5fa0a9" />




#### Maksimum Frekans Hesabı / Maximum Frequency Calculation ($F_{\max}$):
**[TR]** 250 MHz saat periyodumuz $4.000\text{ ns}$ olmasına rağmen, sinyalin hedefe ulaşabilmesi için yaklaşık $1\text{ ns}$ daha zamana ($0.994\text{ ns}$) ihtiyaç vardır. Bu da devrenin çalışabileceği minimum saat periyodunu ve maksimum frekansı belirler:


**[EN]** Although the target clock period is $4.000\text{ ns}$ (250 MHz), the signal requires approximately $1\text{ ns}$ more time ($0.994\text{ ns}$) to safely arrive at the destination. This determines the minimum achievable clock period and maximum frequency:

$$T_{\min} = T_{\text{target}} - \text{WNS} = 4.000\text{ ns} - (-0.994\text{ ns}) = \mathbf{4.994\text{ ns}} \approx \mathbf{5.0\text{ ns}}$$
$$F_{\max} = \frac{1}{T_{\min}} = \frac{1}{4.994\text{ ns}} \approx \mathbf{200.2\text{ MHz}} \approx \mathbf{200\text{ MHz}}$$

---

### 2. Pipelined Tasarım / Pipelined Design
**[TR]** Boru hattı register'ları (Level 1, Level 2 ve Top modül çıkış register'ı) ile uzun kombinasyonel yol bölünmüş, her saat vuruşuna sadece tek bir toplama düşürülmüştür. Tasarım 250 MHz zamanlama kısıtını fazlasıyla karşılayarak **`+1.341 ns`** pozitif slack elde etmiştir:  
**[EN]** The long combinational path is broken down using pipeline registers (Level 1, Level 2, and the Top module output register), isolating the logic to just a single addition per clock cycle. The design comfortably achieves timing closure at 250 MHz with a positive slack of **`+1.341 ns`**:

<img width="1498" height="339" alt="image" src="https://github.com/user-attachments/assets/fc8451b9-286a-4ea7-8a64-d312707b8199" />



* **WNS:** `+1.341 ns` (Timing Met)
* **Failing Endpoints:** `0` (Hatasız)
* **Total Endpoints:** `67` (36 Seviye 1 + 20 Seviye 2 + 11 Çıkış)

#### Maksimum Frekans Hesabı / Maximum Frequency Calculation ($F_{\max}$):
**[TR]** 250 MHz ($4.000\text{ ns}$) hedefinde sinyal hedef kapıya gereken zamandan $1.341\text{ ns}$ daha erken varmıştır. Bu pozitif marjin sayesinde saat periyodu çok daha fazla kısaltılabilir:


**[EN]** At the 250 MHz ($4.000\text{ ns}$) target, the signal arrives $1.341\text{ ns}$ earlier than required. Thanks to this positive slack margin, the clock period can be tightened significantly:

$$T_{\min} = T_{\text{target}} - \text{WNS} = 4.000\text{ ns} - 1.341\text{ ns} = \mathbf{2.659\text{ ns}} \approx \mathbf{2.66\text{ ns}}$$
$$F_{\max} = \frac{1}{T_{\min}} = \frac{1}{2.659\text{ ns}} \approx \mathbf{376.1\text{ MHz}} \approx \mathbf{375\text{ MHz}}$$

---

## Proje Klasör Yapısı / Project Structure

```text
├── rtl/
│   ├── top.vhd               
│   ├── adder.vhd             
│   └── adder_pipelined.vhd   
├── constrs/
│   └── timing.xdc            
└── README.md
