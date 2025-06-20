from fastapi import FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def get_root():
    return "FastAPI: up and running"


@app.get("/hello")
def get_hello():
    return "FastAPI (Python) says hi!"
