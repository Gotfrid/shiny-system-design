import pytest


def test_root(client):
    response = client.get("/")
    assert response.status_code == 200
    data = response.json()
    assert data == "API Dispatcher: up and running"


@pytest.mark.parametrize(("api_target"), ["oxygen", "fastapi", "plumber"])
def test_hello(client, api_target):
    response = client.get("/hello", headers={"ApiTarget": api_target})
    assert response.status_code == 400
    data = response.json()
    assert "detail" in data
    assert api_target in data["detail"]
