# ---------- Build stage ----------
FROM python:3.11-slim AS builder

ARG APP_HOME=/app

WORKDIR ${APP_HOME}

COPY app/api/requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ---------- Runtime stage ----------
FROM python:3.11-slim

ARG APP_HOME=/app
ENV APP_ENV=production
ENV PYTHONUNBUFFERED=1

WORKDIR ${APP_HOME}

# Create non-root user
RUN useradd -m appuser

COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=builder /usr/local/bin /usr/local/bin

COPY app/api ${APP_HOME}

USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
