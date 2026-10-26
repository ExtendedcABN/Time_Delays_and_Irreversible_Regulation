# Time Delays and Irreversible Regulation (TACAS Artifact # 4490)

This artifact accompanies the paper submitted to TACAS (EasyChair Submission # 4490). It provides a self-contained Dockerized environment to replicate all computational experiments, proofs of delay relationships, and dynamic delay searches reported in the paper.

---

## Artifact Hyperlinks & Badges

### Hyperlink to Artifact
- **GitHub Repository**: [https://github.com/ExtendedcABN/Time_Delays_and_Irreversible_Regulation](https://github.com/ExtendedcABN/Time_Delays_and_Irreversible_Regulation)
- **Archival DOI (Zenodo)**: `https://doi.org/10.5281/zenodo.XXXXXXX`

### Badges Applied For
- **Artifacts Available**: **Yes** (Archived with permanent identifier on Zenodo and public on GitHub).
- **Artifacts Evaluated – Functional**: **Yes** (All benchmark models and empirical results from the paper can be executed and verified using the provided automated scripts).
- **Artifacts Evaluated – Reusable**: **No**

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

## License

This artifact is distributed under the **MIT License**. See the [LICENSE](LICENSE) file for the full license text.
