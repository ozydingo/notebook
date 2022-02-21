import pytest
import requests_mock

# @pytest.fixture(autouse=True)
# def disable_requests():
#     with requests_mock.Mocker():
#         yield

@pytest.fixture(autouse=True)
def stub_or_disable_requests():
    with requests_mock.Mocker() as mocker:
        mocker.get('//example.com/mock1', text='example.com mock 1')
        mocker.get('/mock2', text='any domain mock 2')
        yield
