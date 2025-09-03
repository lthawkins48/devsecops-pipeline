# syntax=docker/dockerfile:1


# ---- Builder stage ----
FROM python:3.12-slim AS builder
WORKDIR /app


# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
gcc build-essential ca-certificates && \
rm -rf /var/lib/apt/lists/*


COPY app/requirements.txt ./requirements.txt
RUN python -m venv /venv && /venv/bin/pip install --upgrade pip && \
/venv/bin/pip install -r requirements.txt


# ---- Runtime stage ----
FROM python:3.12-slim
ENV VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
WORKDIR /app


# Add a non-root user
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser


COPY --from=builder /venv /venv
COPY app/ /app/app/


EXPOSE 8000
USER appuser


CMD ["uvicorn", "app.app:app", "--host", "0.0.0.0", "--port", "8000"]
