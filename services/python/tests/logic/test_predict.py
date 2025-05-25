from logic.predict import predict


def test_predict(sample_x, sample_y):
    result = predict(sample_x, sample_y)
    assert result == [2, 3]
