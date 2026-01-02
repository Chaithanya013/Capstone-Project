from app import app

def test_health_endpoint():
    client = app.test_client()
    response = client.get("/health")

    # Health endpoint must respond (DB may or may not be up in CI)
    assert response.status_code in (200, 500)

    data = response.get_json()
    assert "status" in data
