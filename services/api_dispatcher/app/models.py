from sqlmodel import SQLModel, Field
from datetime import datetime


class ApiLog(SQLModel, table=True):
    __tablename__: str = "api_dispatcher_log"

    id: int | None = Field(default=None, primary_key=True)
    path: str
    method: str
    status_code: int
    header: str | None
    process_time: float
    created_at: datetime

    class Config:
        allow_arbitrary_types = True
