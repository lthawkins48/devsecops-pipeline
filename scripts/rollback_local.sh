#!/usr/bin/env bash
set -euo pipefail

IMAGE=devsecops-demo
STABLE=${IMAGE}:stable
LATEST=${IMAGE}:latest

if ! docker image inspect "${STABLE}" >/dev/null 2>&1; then
  echo "[-] No :stable image available to roll back to."
  exit 1
fi

echo "[+] Rolling back: ${STABLE} -> ${LATEST}"
docker tag "${STABLE}" "${LATEST}"
export IMAGE_TAG=latest
docker compose up -d
echo "[+] Rollback complete."

