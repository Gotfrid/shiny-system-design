FROM python:3.12-slim-bookworm

COPY --from=ghcr.io/astral-sh/uv:0.7.10 /uv /uvx /bin/

COPY . .

RUN uv sync --frozen

CMD [ "uv", "run", "fastapi", "run", "--workers", "1" ]
