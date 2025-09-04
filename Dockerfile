# syntax=docker/dockerfile:1
FROM python:3.12-slim AS base
WORKDIR /app

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY app/requirements.txt ./requirements.txt
RUN python -m venv /venv && /venv/bin/pip install --upgrade pip && /venv/bin/pip install -r requirements.txt

COPY app/ /app/app/
ENV PATH="/venv/bin:$PATH"
EXPOSE 8000
USER appuser
CMD ["uvicorn", "app.app:app", "--host", "0.0.0.0", "--port", "8000"]

