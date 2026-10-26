#!/usr/bin/env bash
# Run Python experiments from README.md; capture stdout/stderr under LOG_DIR/.
# Override for Docker: LOG_DIR=/app/logs_docker
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

LOG_DIR="${LOG_DIR:-${ROOT}/logs_original}"
mkdir -p "$LOG_DIR"
export PYTHONUNBUFFERED=1

SCRIPT="src/parallel_run_AllUpdateFuncs_varrying_delays.py"
RESULTS_DIR="${RESULTS_DIR:-${ROOT}/results}"
mkdir -p "${RESULTS_DIR}"
RUN_ARGS=(--models_dir benchmarks --results_dir "${RESULTS_DIR}")

if [[ -n "${PYTHON:-}" ]]; then
  PYTHON=("${PYTHON}")
elif [[ -x "${ROOT}/.venv/bin/python" ]]; then
  PYTHON=("${ROOT}/.venv/bin/python")
elif command -v uv >/dev/null 2>&1; then
  PYTHON=(uv run python)
else
  PYTHON=(python3)
fi

run_logged() {
  local log_stem="$1"
  shift
  local log_file="${LOG_DIR}/${log_stem}.log"
  echo "[$(date -Iseconds)] ${log_stem} -> ${log_file}"
  echo "Command: ${PYTHON[*]} $*" >>"${log_file}"
  echo "---" >>"${log_file}"
  "${PYTHON[@]}" "$@" >>"${log_file}" 2>&1
  local status=$?
  echo "--- exit ${status} ---" >>"${log_file}"
  return "${status}"
}

failures=0

record() {
  if ! run_logged "$@"; then
    failures=$((failures + 1))
  fi
}

MODE="${1:-all}"

if [[ "${MODE}" == "smoke" ]]; then
  record "smoke_id-133" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "id-133"
elif [[ "${MODE}" == "all" ]]; then
  record "T1_id-133" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "id-133"
  record "T1_id-015" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "id-015"
  record "T1_id-111" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "id-111"
  record "T1_id-230" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "id-230"
  record "VE_id-035" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "id-035"
  record "VE_abstract" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "abstract"
  record "Sea_Urchin" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "Sea Urchin"
elif [[ "${MODE}" == "id-133" || "${MODE}" == "id-015" || "${MODE}" == "id-111" || "${MODE}" == "id-230" || "${MODE}" == "id-035" || "${MODE}" == "abstract" || "${MODE}" == "Sea Urchin" ]]; then
  record "single_${MODE}" "${SCRIPT}" "${RUN_ARGS[@]}" --model_name "${MODE}"
else
  exec "$@"
fi

echo "Done. Logs in ${LOG_DIR}/ (*.log)"
if ((failures > 0)); then
  echo "${failures} run(s) exited non-zero (see logs)."
  exit 1
fi
