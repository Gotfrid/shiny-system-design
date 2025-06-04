from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from logic.predict import predict


class PredictionInput(BaseModel):
    x: list[list[float]]
    y: list[str]


app = FastAPI()


@app.post("/predict")
def get_prediction(body: PredictionInput):
    try:
        return predict(body.x, body.y)
    except Exception as e:
        print(e)
        raise HTTPException(500, "Failed to run prediction")
