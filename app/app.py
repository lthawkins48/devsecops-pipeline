from fastapi import FastAPI
import os

app = FastAPI()
API_KEY = os.getenv("DEMO_API_KEY", "demo_default_key")

@app.get("/")
async def root():
    return {"status": "ok", "message": "Big pipeline working", "api_key_present": bool(API_KEY)}

@app.get("/healthz")
async def health():
    return {"status": "healthy"}

