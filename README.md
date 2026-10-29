# Time Delays and Irreversible Regulation (TACAS Artifact # 4490)

This artifact accompanies the paper submitted to TACAS (EasyChair Submission # 4490). It provides a self-contained Dockerized environment to replicate all computational experiments, proofs of delay relationships, and dynamic delay searches reported in the paper.

---

## Artifact Hyperlinks & Badges

### Hyperlink to Artifact
- **GitHub Repository**: [https://github.com/ExtendedcABN/Time_Delays_and_Irreversible_Regulation](https://github.com/ExtendedcABN/Time_Delays_and_Irreversible_Regulation)
- **Archival DOI (Zenodo)**: [https://doi.org/10.5281/zenodo.23762195](https://doi.org/10.5281/zenodo.23762195)

### Badges Applied For
- **Artifacts Available**: **Yes** (Archived with permanent identifier on Zenodo and public on GitHub).
- **Artifacts Evaluated – Functional**: **Yes** (All benchmark models and empirical results from the paper can be executed and verified using the provided automated scripts).
- **Artifacts Evaluated – Reusable**: **Yes** (Provides an extensible Python/Z3 synthesis engine, step-by-step custom model tutorial, minimal toy example, and full input/output specifications).

---

## System Requirements & Tested Platforms

- **Host Architectures**: 
  - Tested on `amd64` (x86_64).
  - *Apple Silicon (`arm64` / macOS M-series)*: Docker automatically runs via emulation, or you can add `--platform linux/amd64` to the `docker build` and `docker run` commands.
- **Operating Systems Tested**:
  - Ubuntu 22.04 LTS (Docker Engine 24.x)
  - Windows 11 (Docker Desktop with WSL2 backend, tested in PowerShell)
- **Prerequisites**: Docker (v20.10 or newer). No proprietary software is required.
- **Hardware Resources**:
  - **RAM**: Minimum 4 GB RAM (8 GB recommended for the full suite).
  - **CPU**: Multi-core x86_64 CPU (2+ cores recommended).
  - **Disk Space**: ~2 GB free disk space for the Docker image, logs, and generated result models.

---

## Running the Code

### Step 1: Ensure the Docker Daemon is Running
Before running any commands, make sure that the Docker service is running on your machine:
- **Windows / macOS (Docker Desktop)**:
  Launch the **Docker Desktop** application from your Start Menu / Applications folder and confirm that the status indicator in the bottom-left corner is green (**"Engine running"**).
- **Linux / TACAS VirtualBox VM (Docker Engine via systemd)**:
  Ensure the Docker service is active:
  ```bash
  sudo systemctl start docker
  ```
  *(Tip: To run Docker without `sudo`, ensure your user is in the docker group via `sudo usermod -aG docker $USER` and open a new terminal).*
- **Quick Verification (All Platforms)**:
  Run `docker info` or `docker ps` in your terminal. If it executes without connection errors, the Docker daemon is ready.

### Step 2: Initial Build & Setup
Always run these build and directory setup commands once, regardless of which test you want to run:

**Linux / macOS:**

```bash
docker build -t time-delays-artifact:latest .
mkdir -p logs_docker
mkdir -p results_docker
```

**Windows (in PowerShell):**

```powershell
docker build -t time-delays-artifact:latest .
mkdir logs_docker, results_docker
```

---

## Early Smoke Test Review (~1 minute)

The smoke test runs an early evaluation using the fast Root Stem Cell benchmark model (`id-133`, 8 variables). It allows AEC reviewers to verify that:
1. The Docker container builds and executes properly.
2. The Python runtime and Z3 SMT solver initialize without error.
3. Trajectories, permutations, and proven relative delay relationships are computed and written to the mounted volume.

### Running the Smoke Test:

**Linux / macOS:**

```bash
docker run --rm \
  -v "$(pwd)/logs_docker:/app/logs_docker" \
  -v "$(pwd)/results_docker:/app/results_docker" \
  time-delays-artifact:latest smoke
```

**Windows (in PowerShell):**

```powershell
docker run --rm `
  -v "${PWD}/logs_docker:/app/logs_docker" `
  -v "${PWD}/results_docker:/app/results_docker" `
  time-delays-artifact:latest smoke
```

### Expected Smoke Test Outputs & Verification:
- **Estimated Execution Time**: ~5–10 seconds.
- **Log File**: `logs_docker/smoke_id-133.log`
  - Verify that the log concludes with:
    ```text
    --- DONE: Extracted 10 Concrete Models ---
    Scanning for Delays That Remain Constant Across All Time Steps
    Scanning for Relative Delay Relationships Between Interactions
     v_AUXIAA->v_ARF MUST ALWAYS BE GREATER THAN v_AUXIN->v_AUXIAA at every time step.
     ...
    --- Runtime: 0.2842 seconds ---
    -> Saved 10 permutations to /app/results_docker/[id-133]__[var-8]__[in-2]__[ROOT-STEM-CELL-2010]/delay_permutations_non_constant.json
    -> Saved trajectories to /app/results_docker/[id-133]__[var-8]__[in-2]__[ROOT-STEM-CELL-2010]/trajectories_non_constant.txt
    -> Saved relationships to /app/results_docker/[id-133]__[var-8]__[in-2]__[ROOT-STEM-CELL-2010]/Relationships.txt
    --- exit 0 ---
    ```
- **Results Directory**: `results_docker/[id-133]__[var-8]__[in-2]__[ROOT-STEM-CELL-2010]/`
  - Check that the directory contains:
    - `delay_permutations_non_constant.json`: Concrete delay solutions.
    - `trajectories_non_constant.txt`: Trajectory state transitions.
    - `Relationships.txt`: Summary of proven relationships (matching Table 1 in the paper).

---

## Replication of Paper Results

Reviewers can reproduce the experiments either by running the entire benchmark suite at once or by running individual experiments one by one.

### Option A: Run All Experiments (Full Benchmark Suite)

Runs all 7 benchmark models sequentially and logs outputs.

**Linux / macOS:**

```bash
docker run --rm \
  -v "$(pwd)/logs_docker:/app/logs_docker" \
  -v "$(pwd)/results_docker:/app/results_docker" \
  time-delays-artifact:latest
```

**Windows (in PowerShell):**

```powershell
docker run --rm `
  -v "${PWD}/logs_docker:/app/logs_docker" `
  -v "${PWD}/results_docker:/app/results_docker" `
  time-delays-artifact:latest
```

- **Estimated Total Runtime**: ~10–20 minutes *(typically ~7–10 minutes on native modern CPUs; up to 15–20 minutes inside the TACAS VirtualBox VM).*
- **Logs**: `logs_docker/*.log`
- **Results**: `results_docker/<benchmark-folder>/`

---

### Option B: Run Individual Experiments

Reviewers can also run and inspect any specific benchmark model independently by passing the model identifier as an argument:

#### 1. Root Stem Cell (`id-133`) — Table 1
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest id-133
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest id-133
  ```
- **Log**: `logs_docker/single_id-133.log` (or `logs_docker/T1_id-133.log` when run via full suite)
- **Results**: `results_docker/[id-133]__[var-8]__[in-2]__[ROOT-STEM-CELL-2010]/Relationships.txt`
- **Estimated Runtime**: ~5–10 seconds.

#### 2. Neurotransmitter Signaling Pathway (`id-015`) — Table 1
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest id-015
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest id-015
  ```
- **Log**: `logs_docker/single_id-015.log` (or `logs_docker/T1_id-015.log`)
- **Results**: `results_docker/[id-015]__[var-14]__[in-2]__[NEUROTRANSMITTER-SIGNALING-PATHWAY]/Relationships.txt`
- **Estimated Runtime**: ~10–15 seconds.

#### 3. Apoptosis (`id-111`) — Table 1
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest id-111
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest id-111
  ```
- **Log**: `logs_docker/single_id-111.log` (or `logs_docker/T1_id-111.log`)
- **Results**: `results_docker/[id-111]__[var-18]__[in-15]__[APOPTOSIS]/Relationships.txt`
- **Estimated Runtime**: ~10–15 seconds.

#### 4. Hepatocyte Growth Factor (`id-230`) — Table 1
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest id-230
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest id-230
  ```
- **Log**: `logs_docker/single_id-230.log` (or `logs_docker/T1_id-230.log`)
- **Results**: `results_docker/[id-230]__[var-50]__[in-5]__[HEPATOCYTE-GROWTH-FACTOR]/Relationships.txt`
- **Estimated Runtime**: ~5–10 seconds.

#### 5. Breast Cell Line (`id-035`) — Section 5 (Variable Delay Elimination)
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest id-035
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest id-035
  ```
- **Log**: `logs_docker/single_id-035.log` (or `logs_docker/VE_id-035.log`)
- **Results**: `results_docker/[id-035]__[var-11]__[in-5]__[BT474-BREAST-CELL-LINE-SHORT-TERM]/Relationships.txt`
- **Estimated Runtime**: ~10–15 seconds.

#### 6. Abstract Benchmark (`abstract`) — Section 5
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest abstract
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest abstract
  ```
- **Log**: `logs_docker/single_abstract.log` (or `logs_docker/VE_abstract.log`)
- **Results**: `results_docker/[id-035]__[var-11]__[in-5]__[BT474-BREAST-CELL-LINE-SHORT-TERM] - abstract/Relationships.txt`
- **Estimated Runtime**: ~5–10 seconds.

#### 7. Sea Urchin Embryo (`Sea Urchin`) — Section 5 / Scalability
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest "Sea Urchin"
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest "Sea Urchin"
  ```
- **Log**: `logs_docker/single_Sea Urchin.log` (or `logs_docker/Sea_Urchin.log`)
- **Results**: `results_docker/Sea Urchin Embryo/Relationships.txt`
- **Estimated Runtime**:
  - **Total Wall-Clock Time (End-to-End)**: ~10–20 minutes *(~7 minutes on a native modern CPU; up to 15–20 minutes inside the VirtualBox evaluation VM).*
  - **Internal Solver Runtime (Printed in output)**: ~10–30 seconds.
  > **Note on Wall-Clock Time vs. Reported Solver Runtime**:  
  > The `RUNTIME` recorded in `Relationships.txt` and the console logs measures only the **active SMT solving, model extraction, and hypothesis-proving phase** (the timer starts immediately prior to `solver.check()`). It does **not** include the initial constraint construction and formula-encoding phase in Python (parsing the configuration, unrolling multi-step dynamic delay trajectories, and formatting SMT constraints). While formula construction is instantaneous (< 1s) for smaller models, the high-dimensional `Sea Urchin Embryo` network requires several minutes of symbolic constraint construction before the Z3 solver search begins.

#### 8. Minimal Toy Example (`toy_example`) — Reusability Walkthrough
- **Linux:**
  ```bash
  docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest toy_example
  ```
- **Windows (PowerShell):**
  ```powershell
  docker run --rm -v "${PWD}/logs_docker:/app/logs_docker" -v "${PWD}/results_docker:/app/results_docker" time-delays-artifact:latest toy_example
  ```
- **Log**: `logs_docker/single_toy_example.log`
- **Results**: `results_docker/toy_example/Relationships.txt`
- **Estimated Runtime**: < 2 seconds.
- **Description**: A minimal 3-component network (`v_A`, `v_B`, `v_C`) demonstrating how third-party researchers can configure and run custom biological models.

---

## Mapping Between Artifact Outputs and Paper Claims

The table below maps each experiment to the corresponding section and table in the paper:

| Experiment / Model Name | Paper Reference | Primary Output File | Evaluated Result in Paper |
| :--- | :--- | :--- | :--- |
| `id-133` (Root Stem Cell) | **Table 1** (Row 1) | `results_docker/[id-133].../Relationships.txt` | Universal relative delay relationships between regulatory interactions |
| `id-015` (Neurotransmitter) | **Table 1** (Row 2) | `results_docker/[id-015].../Relationships.txt` | Delay constraints and proven relationships under dynamic delays |
| `id-111` (Apoptosis) | **Table 1** (Row 3) | `results_docker/[id-111].../Relationships.txt` | Universal relative delay inequalities |
| `id-230` (Hepatocyte Growth Factor) | **Table 1** (Row 4) | `results_docker/[id-230].../Relationships.txt` | Consistency of synthesized delay permutations |
| `id-035` (BT474 Breast Cell) | **Section 5** | `results_docker/[id-035].../Relationships.txt` | Detection and elimination of variable delays |
| `abstract` (Breast Cell Abstract) | **Section 5** | `results_docker/[id-035]... - abstract/Relationships.txt` | Baseline comparison under abstract delay constraints |
| `Sea Urchin` (Sea Urchin Embryo) | **Section 5** | `results_docker/Sea Urchin Embryo/Relationships.txt` | Solver scalability on high-dimensional biological network |

---

## Reusability & Extensibility Guide

This artifact is designed to be easily extensible, adaptable, and reusable for investigating dynamic time delays and irreversible regulation in arbitrary biological Boolean networks.

### 1. How to Run on Custom Models (Step-by-Step Tutorial)

To run the framework on your own Boolean network, create a folder under `benchmarks/<my_model_name>/` containing the following three standard files:

#### File A: `model.bnet` (Boolean Logic Rules)
Specify update functions using standard BoolNet / PyBoolNet syntax (`target, factors`):
```text
targets,factors
v_A, !v_C
v_B, v_A
v_C, v_B
```
- Supported Boolean operators: `!` (NOT), `&` (AND), `|` (OR), parentheses `(...)`.

#### File B: `config.json` (Delay Bounds & Network Topology)
Specify the simulation horizon, internal vs. external variables, and lower/upper delay bounds `[d_min, d_max]` for each interaction:
```json
{
    "num_steps": 10,
    "time_resolution": 1,
    "initialize_components_false": false,
    "internal_components": ["v_A", "v_B", "v_C"],
    "external_inputs": [],
    "interactions": [
        {
            "src": "v_C",
            "tgt": "v_A",
            "type": -1,
            "d_min": 1,
            "d_max": 2,
            "definite": true
        },
        {
            "src": "v_A",
            "tgt": "v_B",
            "type": 1,
            "d_min": 1,
            "d_max": 2,
            "definite": true
        },
        {
            "src": "v_B",
            "tgt": "v_C",
            "type": 1,
            "d_min": 1,
            "d_max": 2,
            "definite": true
        }
    ]
}
```
- `type`: `1` for activation, `-1` for repression.
- `definite`: Set to `false` for indefinite interactions (the synthesizer will prove whether the interaction is strictly necessary or prohibited).

#### File C: `<my_model_name>.json` (Time-Series Observations)
Provide experimental trajectory time-series with observed Boolean state vectors:
```json
{
    "model_id": "my_model_name",
    "observations": {
        "time_series_trajectories": [
            [
                {"v_A": 0, "v_B": 0, "v_C": 0},
                {"v_A": 1, "v_B": 0, "v_C": 0},
                {"v_A": 1, "v_B": 1, "v_C": 0},
                {"v_A": 1, "v_B": 1, "v_C": 1},
                {"v_A": 0, "v_B": 1, "v_C": 1}
            ]
        ]
    }
}
```

#### Running Your Custom Model
Once the folder `benchmarks/<my_model_name>/` is created, run:
```bash
# Via Docker:
docker run --rm -v "$(pwd)/logs_docker:/app/logs_docker" -v "$(pwd)/results_docker:/app/results_docker" time-delays-artifact:latest <my_model_name>

# Via native Python:
python3 src/parallel_run_AllUpdateFuncs_varrying_delays.py --models_dir benchmarks --results_dir results --model_name <my_model_name>
```

---

### 2. Running Directly with Native Python (No Docker Required)

If you wish to integrate the synthesizer into a Python pipeline, develop custom solvers, or run experiments natively without Docker:

```bash
# 1. Create and activate a Python virtual environment
python3 -m venv .venv
source .venv/bin/activate       # On Windows PowerShell: .venv\Scripts\Activate.ps1

# 2. Install dependencies (Z3 SMT solver)
pip install -r requirements.txt

# 3. Run any benchmark
python3 src/parallel_run_AllUpdateFuncs_varrying_delays.py --models_dir benchmarks --results_dir results --model_name toy_example
```

---

### 3. Output Data Specifications

The tool generates three structured files per evaluated model under `results_docker/<model_folder>/`:

1. **`delay_permutations_non_constant.json`**:
   - Contains concrete solutions satisfying all dynamic delay trajectory constraints.
   - For each solution ID, maps `(src->tgt)` interactions to their synthesized integer delays at every discrete time step $t$, as well as structural edge inclusions (`true`/`false`).
2. **`trajectories_non_constant.txt`**:
   - Records the total valid universal solutions found and solver runtime.
   - Details full global state trajectories, listing all active components (`Step t: ['v_A', 'v_B']`) across all experiments.
3. **`Relationships.txt`**:
   - Lists all universally proven invariants and relative delay inequalities:
     - Constancy across time: `Delay of X->Y MUST BE CONSTANT across all time steps.`
     - Relative synchrony: `X->Y MUST ALWAYS BE GREATER THAN Z->W at every time step.`
     - Structural necessity: `INTERACTION X->Y IS STRICTLY NECESSARY` or `STRICTLY PROHIBITED`.

---

### 4. Code Architecture & Extensibility Guide

The core synthesis engine is located in `src/parallel_run_AllUpdateFuncs_varrying_delays.py`:

- **`ParallelCABN_Synthesis` (Class)**:
  - **Dynamic Delay Encoding (`build_constraints`)**: Instantiates time-indexed integer variables $d_{u \to v}^t \in [d_{\min}, d_{\max}]$ for every regulatory interaction at every time step $t$.
  - **Buffer Unrolling (`buffers_map`)**: Maintains delay buffer variables (`Buf_...`) for past historical states up to $d_{\max}$.
  - **Zero-Delay Acyclicity Ranking**: Enforces strict topological order constraints on all instantaneous zero-delay interactions to prevent combinational cycles.
  - **Hypothesis and Proof Engine (`run`)**:
    1. Extracts concrete models via iterative Z3 constraint satisfaction (`self.solver.check() == sat`) and blocking clauses.
    2. Forms empirical hypotheses for delay constancy and relative ordering ($d_1 > d_2$).
    3. Formally proves or refutes hypotheses by asserting the negation and checking for `unsat`.
- **Extending the Framework**:
  - *Adding Custom Constraints*: Researchers can inject additional domain-specific constraints (e.g., biological knowledge of known signal bounds or reaction kinetics) by adding assertions directly to `sys.solver.add(...)` in `src/parallel_run_AllUpdateFuncs_varrying_delays.py`.
  - *Alternative Solvers*: The Z3 interface can be interfaced with SMT-LIB2 format via `sys.print_solver_constraints()` which dumps the full assertions to `smt_constraints_dump.txt`.

---

## License

This artifact is distributed under the **MIT License**. See the [LICENSE](LICENSE) file for the full license text.
