import pytest
import requests
import requests_mock

def test_unmocked_get():
    with pytest.raises(requests_mock.exceptions.NoMockAddress):
        requests.get("http://www.google.com")

def test_session():
    session = requests.Session()
    with pytest.raises(requests_mock.exceptions.NoMockAddress):
        session.get("http://www.google.com")

def test_mocked_get():
    response1 = requests.get("https://example.com/mock1")
    response2 = requests.get("https://example.com/mock2")
    with pytest.raises(requests_mock.exceptions.NoMockAddress):
        requests.get("https://anything.com/mock1")
    response4 = requests.get("https://anything.com/mock2")

    assert response1.text == "example.com mock 1"
    assert response2.text == "any domain mock 2"
    assert response4.text == "any domain mock 2"
