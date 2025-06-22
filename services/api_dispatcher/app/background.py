from datetime import datetime, UTC

from fastapi import Request
from starlette.responses import StreamingResponse

from app.db import get_session
from app.models import ApiLog


def write_log(
    req: Request,
    res: StreamingResponse,
    process_time: float,
):
    db = next(get_session())

    log = ApiLog(
        path=req.url.path,
        method=req.method,
        status_code=res.status_code,
        header=req.headers.get("ApiTarget"),
        process_time=process_time,
        created_at=datetime.now(UTC),
    )
    db.add(log)
    db.commit()

    db.close()
