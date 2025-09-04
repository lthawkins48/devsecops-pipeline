#!/usr/bin/env bash
set -euo pipefail

IMAGE=devsecops-demo
NEW_TAG=${GITHUB_SHA:-local}
LATEST=${IMAGE}:latest
STABLE=${IMAGE}:stable
NEW=${IMAGE}:${NEW_TAG}

echo "[+] Linting Dockerfile (hadolint)"
command -v hadolint >/dev/null || { echo "hadolint missing"; exit 1; }
hadolint Dockerfile || true

echo "[+] Preserving current as :stable (if exists)"
if docker image inspect "${LATEST}" >/dev/null 2>&1; then
  docker tag "${LATEST}" "${STABLE}"
  echo "    Tagged ${LATEST} -> ${STABLE}"
else
  echo "    No :latest yet; skipping"
fi

echo "[+] Building new image ${NEW}"
docker build -t "${NEW}" .

echo "[+] Scanning image with Trivy"
command -v trivy >/dev/null || { echo "trivy missing"; exit 1; }
trivy image --exit-code 0 --severity HIGH,CRITICAL "${NEW}"

echo "[+] Updating :latest -> ${NEW_TAG}"
docker tag "${NEW}" "${LATEST}"

echo "[+] Deploying with docker compose"
export IMAGE_TAG=latest
docker compose down || true
docker compose up -d

echo "[+] Done. Visit http://localhost:8000"

