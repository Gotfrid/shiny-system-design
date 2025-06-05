import logging

from fastapi.logger import logger


def create_logger():
    uvicorn_logger = logging.getLogger("uvicorn")
    application_logger = logger
    application_logger.handlers = uvicorn_logger.handlers
    application_logger.setLevel(logging.INFO)

    return application_logger


log = create_logger()
