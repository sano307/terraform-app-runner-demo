import os

from fastapi import FastAPI

greetings = os.getenv("GREETINGS", "Hello World!")

app = FastAPI()


@app.get("/")
def root():
    return {
        "message": greetings
    }

@app.get("/hc")
def health_check():
    return {
        "status": "200"
    }
