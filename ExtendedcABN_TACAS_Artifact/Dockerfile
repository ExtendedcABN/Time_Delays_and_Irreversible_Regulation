FROM python:3.12-slim-bookworm

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY benchmarks/ benchmarks/
COPY src/ src/
COPY run_readme_experiments.sh README.md ./

# Git on Windows may checkout shell scripts with CRLF; the Linux image needs LF.
RUN sed -i 's/\r$//' run_readme_experiments.sh && chmod +x run_readme_experiments.sh

ENV PYTHONUNBUFFERED=1
ENV PYTHON=python3
ENV LOG_DIR=/app/logs_docker
ENV RESULTS_DIR=/app/results_docker

# Run via bash so a CRLF shebang cannot break the container entrypoint.
ENTRYPOINT ["bash", "run_readme_experiments.sh"]
CMD []
