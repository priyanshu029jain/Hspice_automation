# CMOS Inverter PVT Characterization Framework (65nm, HSPICE)

A command-line framework for simulating and characterizing basic CMOS logic cells with **Synopsys HSPICE**. You pick a circuit, an analysis, a sweep parameter and a process corner. The framework then:

1. builds the top-level netlist,
2. runs HSPICE,
3. checks the log for errors,
4. pulls the `.MEASURE` results into a clean table,
5. opens the waveforms in **WaveView**.

The `runall` command runs the same flow over many corners, parameters, circuits or analyses with one command.

---

## Directory Structure

```
invertor/
├── run                  # Run one simulation
├── runall               # Run a batch sweep (corner / param / schem / anal)
├── clean                # Delete raw simulation outputs (asks for confirmation and a passcode)
├── open                 # Open a netlist, or create one from a template
├── error                # Scan an HSPICE log for errors
│
├── schematic/           # Circuit netlists (.sp)
├── analysis/            # Stimulus + analysis statements (dc, tran, ac, noise, static, dynamic)
├── measure/             # .MEASURE statements, one file per analysis
├── parameter/           # .DATA sweep tables (vdd, temp, cload, wnmos, ...)
├── corner/              # Process corner settings (tt, ff, ss, sf, fs)
│
├── script/
│   ├── run/             # parse_args, build_top.sp, run_hspice, format_measure, display, launch_wv
│   ├── runall/          # sweep_corner, sweep_param, sweep_schem, sweep_anal
│   ├── clean/           # clean_target, clean_latest, clean_old, clean_all, security
│   └── utils/           # error_parser, launch_batch_wv
│
├── data/                # Formatted measurement tables (<schem>_<anal>_<param>_<corner>_measure.txt)
├── output/              # Raw HSPICE output (.lis, .tr0, .sw0, .ac0, .mt0, ...), created when you run
├── waveform/            # Saved waveform screenshots
├── diagram/             # Circuit diagrams
└── top.sp               # Generated master netlist (rewritten on every run)
```

The process model file is [`65nm.pm`](65nm.pm), a customized PTM 65nm BSIM4 model. Every netlist loads it with `.INCLUDE`.

---

## Requirements

- Linux/Unix shell (Bash). The scripts use `awk`, `sed`, `column`, `sha256sum` or `openssl`.
- Synopsys **HSPICE** (`hspice` must be on `PATH`)
- Synopsys **WaveView** (`wv`). Optional; only used to view waveforms.

Make the scripts executable once:

```bash
chmod +x run runall clean open error script/*/*.sh
```

---

## Usage

### Single run

```bash
./run <schematic> <analysis> <parameter> <corner> [batch]
```

| Argument      | Options                                                                            |
|---------------|------------------------------------------------------------------------------------|
| `schematic`   | `cmos`, `nand`, `pseudo_nmos`, `pseudo_pmos`, `buffer_nmos`, `buffer_pmos`          |
| `analysis`    | `dc`, `tran`, `ac`, `noise`, `static`, `dynamic`                                   |
| `parameter`   | `none`, `vdd`, `vss`, `temp`, `cload`, `lmos`, `wnmos`, `wpmos`, `res`             |
| `corner`      | `tt`, `ff`, `ss`, `sf`, `fs`                                                       |
| `batch`       | `1` skips opening WaveView (`runall` uses this)                                    |

If you leave arguments out, the defaults are `cmos dc none tt`.

```bash
./run cmos tran vdd tt      # Transient response of the CMOS inverter across VDD
./run cmos dc temp ff       # VTC across temperature at the FF corner
./run pseudo_nmos dc res tt # Pseudo-NMOS VTC vs. pull-up resistance
```

Each run:
1. Checks that the input files exist (`parse_args.sh`).
2. Writes `top.sp`, which includes the corner, schematic, analysis and measure files, and adds `SWEEP DATA=param_data` or `SWEEP temp` to the analysis line (`build_top.sp.sh`).
3. Runs `hspice top.sp -o output/<run_name>` (`run_hspice.sh`).
4. If HSPICE fails or the `.lis` contains `**error**`, runs the error parser and stops.
5. Converts the raw `.mt0/.ms0/.ma0` file into a table in `data/` (`format_measure.sh`).
6. Prints the table and opens WaveView.

### Batch sweeps

```bash
./runall corner <schem> <analysis> <param>               # Runs all 5 corners
./runall param  <schem> <analysis> <corner> <p1> <p2>... # Runs several parameters
./runall schem  <analysis> <param> <corner> <s1> <s2>... # Runs several circuits
./runall anal   <schem> <param> <corner> [a1 a2 ...]     # Runs several analyses (all 6 if none given)
```

The sweep stops at the first failed run. When it finishes, all the waveforms open together in one WaveView session.

```bash
./runall corner cmos tran none
./runall param cmos tran tt vdd cload wpmos
./runall schem dc none tt cmos pseudo_nmos pseudo_pmos
./runall anal cmos none tt
```

### Other utilities

```bash
./open <name>         # Open schematic/<name>.sp, or create a new one from a template with a syntax cheat sheet
./error [log.lis]     # Scan a log for errors (defaults to the newest .lis in output/)
./clean latest        # Delete raw outputs of the most recent run
./clean old [N]       # Delete raw outputs of all runs except the newest N (default 1)
./clean all           # Delete everything in output/
./clean cmos tran vdd ss   # Delete one specific run
```

Before deleting anything, `clean` lists the files it will remove, asks for y/n, and asks for a passcode whose SHA-256 hash it checks. Formatted tables in `data/` are never deleted.

---

## Circuits

| Netlist           | Description                                              |
|-------------------|----------------------------------------------------------|
| `cmos.sp`         | Static CMOS inverter (W<sub>p</sub>=130n, W<sub>n</sub>=65n, L=65n, C<sub>L</sub>=1fF) |
| `pseudo_nmos.sp`  | NMOS driver with a resistor pull-up (R<sub>LOAD</sub>=10kΩ)            |
| `pseudo_pmos.sp`  | PMOS driver with a resistor pull-down                     |
| `buffer_nmos.sp`  | NMOS source follower (common drain) with a resistive load |
| `buffer_pmos.sp`  | PMOS source follower (common drain) with a resistive load |
| `nand.sp`         | Created from the `open` template. *Currently two inverters in series; see Known Issues* |

All circuits use the same node names (`IN`, `OUT`, `VDD`, `VSS`) and the same parameter names (`VDD_VAL`, `VSS_VAL`, `W_nmos`, `W_pmos`, `L_mos`, `Cload`, `R_LOAD`). That is why any analysis or parameter file works with any circuit.

---

## Analyses and Measurements

| Analysis  | Stimulus                                    | Measured values (`measure/*.sp`) |
|-----------|---------------------------------------------|----------------------------------|
| `dc`      | V<sub>IN</sub> swept from V<sub>SS</sub> to V<sub>DD</sub> in 10 mV steps | V<sub>OH</sub>, V<sub>OL</sub>, switching threshold V<sub>M</sub>, V<sub>IL</sub>/V<sub>IH</sub> (where slope = −1), NM<sub>L</sub>, NM<sub>H</sub> |
| `tran`    | One input pulse (2 ns edges), 100 ns run    | t<sub>pHL</sub>, t<sub>pLH</sub>, t<sub>pd</sub>, skew, rise/fall time (10–90%) |
| `ac`      | 0.5 V DC bias + 1 V AC, 1 kHz – 100 GHz     | Low-frequency gain, 3 dB bandwidth, unity-gain frequency, phase at 3 dB |
| `noise`   | Same bias as `ac`, `.noise V(OUT) VIN`      | Output and input noise at 1 MHz, peak output noise, total output and input noise |
| `static`  | V<sub>IN</sub> = V<sub>SS</sub> and V<sub>IN</sub> = V<sub>DD</sub> | Leakage current at each input level, worst-case and average static power |
| `dynamic` | 100 MHz pulse train, 50 ns run              | Average and peak supply current, dynamic power, energy per cycle, PDP |

## Sweep Parameters

| Parameter | Values |
|-----------|--------|
| `vdd`     | 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.4, 1.7 V |
| `vss`     | 0, 0.05, 0.10, 0.15 V (ground bounce) |
| `temp`    | −40 to 125 °C (5 points, set with `SWEEP temp LIN`) |
| `cload`   | 1 fF – 800 fF |
| `lmos`    | 65, 90, 130, 180 nm |
| `wnmos` / `wpmos` | 65, 130, 195, 260 nm |
| `res`     | 100 Ω – 1 MΩ (pull-up/pull-down resistor) |

## Process Corners

| Corner | NMOS | PMOS | V<sub>TH</sub> offset (N / P) | Mobility temp. exponent (N / P) |
|--------|------|------|----------------------|------------------------|
| `tt`   | Typical | Typical | 0 / 0           | −1.5 / −1.5 |
| `ff`   | Fast | Fast       | −0.05 / +0.05   | −1.3 / −1.3 |
| `ss`   | Slow | Slow       | +0.05 / −0.05   | −1.7 / −1.7 |
| `sf`   | Slow | Fast       | +0.05 / +0.05   | −1.7 / −1.3 |
| `fs`   | Fast | Slow       | −0.05 / −0.05   | −1.3 / −1.7 |

---

## Sample Results: CMOS Inverter (TT, V<sub>DD</sub> = 1.0 V, C<sub>L</sub> = 1 fF)

| Metric | Value |
|--------|-------|
| t<sub>pHL</sub> / t<sub>pLH</sub> | 11.3 ps / 103.5 ps |
| t<sub>pd</sub> | 57.4 ps |
| Fall / rise time (10–90%) | 357 ps / 345 ps |
| V<sub>OH</sub> / V<sub>OL</sub> | 1.0 V / ≈ 0 V |
| V<sub>M</sub> | 0.481 V |
| V<sub>IL</sub> / V<sub>IH</sub> | 0.365 V / 0.580 V |
| NM<sub>L</sub> / NM<sub>H</sub> | 0.365 V / 0.421 V |
| AC gain / 3 dB BW / f<sub>unity</sub> (FF) | 16.3 dB / 2.49 GHz / 16.3 GHz |

The full tables are in [`data/`](data/). Waveform screenshots (VTC, switching point, t<sub>pHL</sub>, AC gain, noise, static and dynamic power) are in [`waveform/`](waveform/).

---

## Known Issues / TODO

- **The corners currently have no effect.** The `corner/*.sp` files define `VTH_OFFSET_N/P` and `UTE_N/P_VAL`, but `65nm.pm` never uses these parameters. As a result, all five corners give identical results. To fix this, change the model so `vth0` and `ute` depend on them, for example `vth0 = '0.429 + VTH_OFFSET_N'`.
- **`nand.sp` is not a NAND gate.** It is two inverters in series (a buffer). A real 2-input NAND needs two series NMOS, two parallel PMOS and a second input.
- **The `format_measure.sh` table is wrong when a measurement fails.** HSPICE writes `failed` in place of the number. The AWK parser treats any line that does not start with a digit as a header line, so the columns get misaligned. This affects some `static`, `dynamic` and `noise` tables.
- **`measure/dynamic.sp`:** `pdp` uses `t_pd`, which is only measured in `tran`, so PDP always fails in the `dynamic` analysis.
- **`measure/tran.sp`:** the comment says slew is measured at 20–80%, but the code measures 10–90%.
