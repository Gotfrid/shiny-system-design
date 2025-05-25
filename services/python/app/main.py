from fastapi import FastAPI
from pydantic import BaseModel

from logic.predict import predict


class PredictionInput(BaseModel):
    x: list[list[float]]
    y: list[float]


app = FastAPI()


@app.post("/predict")
def get_prediction(body: PredictionInput):
    return predict(body.x, body.y)
