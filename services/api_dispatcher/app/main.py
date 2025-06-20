from typing import Annotated

import requests
from fastapi import FastAPI, Header, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.logger import log


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
    return "API Dispatcher: up and running"


@app.get("/hello")
def get_hello(ApiTarget: Annotated[str, Header()]):
    log.info(f"Dispatching: {ApiTarget}")
    try:
        api_url = f"http://{ApiTarget}:8000/hello"
        response = requests.get(api_url)
        data = response.json()
        if response.status_code != 200:
            raise Exception(data)
        return data
    except Exception as e:
        log.error(e)
        raise HTTPException(400, f"Failed to dispatch request to {ApiTarget}")
