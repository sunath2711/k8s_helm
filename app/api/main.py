from fastapi import FastAPI
import os
import socket
import psycopg2

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

@app.get("/db-check")
def db_check():
    conn = psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
    )
    conn.close()
    return {"db": "connected"}