import time
from typing import Annotated
from contextlib import asynccontextmanager

import requests
from fastapi import FastAPI, Header, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from starlette.background import BackgroundTask

from app.db import init_db
from app.background import write_log
from app.logger import log


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def middleware(request: Request, call_next):
    start_time = time.perf_counter()
    response = await call_next(request)
    process_time = time.perf_counter() - start_time

    response.background = BackgroundTask(write_log, request, response, process_time)
    return response


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
