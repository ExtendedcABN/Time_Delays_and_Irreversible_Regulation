# Time Delays and Irreversible Regulation (Docker)

## Running the code
Always run these commands, regardless of which test you want to run:

**Linux:**

```bash
docker build -t time-delays-artifact:latest .
mkdir -p logs_docker
mkdir -p results_docker
```

**Windows (in PowerShell)**:

```powershell
docker build -t time-delays-artifact:latest .
mkdir logs_docker, results_docker
```

### Smoke test (abstract benchmark)
In order to run smoke test, run the following command:

**Linux:**
```bash
docker run --rm \
  -v "$(pwd)/logs_docker:/app/logs_docker" \
  -v "$(pwd)/results_docker:/app/results_docker" \
  time-delays-artifact:latest smoke
```

**Windows (in PowerShell)**:

```powershell
docker run --rm `
  -v "${PWD}/logs_docker:/app/logs_docker" `
  -v "${PWD}/results_docker:/app/results_docker" `
  time-delays-artifact:latest smoke
```

Log: `logs_docker/smoke_abstract.log`  
Results: `results_docker/[id-035]__[var-11]__[in-5]__[BT474-BREAST-CELL-LINE-SHORT-TERM] - abstract/`

### All experiments
In order to run all the experiments, run the following command:

**Linux**

```bash
docker run --rm \
  -v "$(pwd)/logs_docker:/app/logs_docker" \
  -v "$(pwd)/results_docker:/app/results_docker" \
  time-delays-artifact:latest
```

**Windows (in PowerShell)**
```powershell
docker run --rm `
  -v "${PWD}/logs_docker:/app/logs_docker" `
  -v "${PWD}/results_docker:/app/results_docker" `
  time-delays-artifact:latest
```

Logs: `logs_docker/*.log`  
Results: `results_docker/<benchmark-folder>/`
