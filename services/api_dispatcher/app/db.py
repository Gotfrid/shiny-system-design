import os

from sqlmodel import create_engine, SQLModel, Session

DB_URL = os.environ.get("DB_URL", "sqlite:///db.sqlite")
engine = create_engine(DB_URL, echo=True)


def init_db():
    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session
