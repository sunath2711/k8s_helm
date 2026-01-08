from fastapi import FastAPI
import os
import socket

app = FastAPI(title="Platform API")

APP_ENV = os.getenv("APP_ENV", "dev")
SERVICE_NAME = os.getenv("SERVICE_NAME", "platform-api")

@app.get("/health")
def health():
    return {
        "status": "ok",
        "service": SERVICE_NAME,
        "env": APP_ENV,
        "host": socket.gethostname()
    }

@app.get("/")
def root():
    return {
        "message": "Platform API is running",
        "environment": APP_ENV
    }
