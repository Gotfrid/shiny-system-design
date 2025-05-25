def test_main(client, sample_x, sample_y):
    response = client.post("/predict", json=dict(x=sample_x, y=sample_y))
    assert response.status_code == 200
    data = response.json()
    assert data == [2, 3]
