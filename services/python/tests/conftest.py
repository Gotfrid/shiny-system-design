import pytest
from fastapi.testclient import TestClient

from app.main import app


@pytest.fixture
def client():
    return TestClient(app)


@pytest.fixture
def sample_x():
    return [[0, 1], [2, 3], [4, 5], [6, 7], [8, 9]]


@pytest.fixture
def sample_y():
    return [0, 1, 2, 3, 4]
