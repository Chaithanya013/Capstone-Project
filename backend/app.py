import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return f"Hello from {os.getenv('APP_ENV')} environment!"

@app.route("/health")
def health():
    return {
        "status": "UP",
        "service": "backend"
    }, 200


if __name__ == "__main__":
    port = int(os.getenv("BACKEND_PORT", 5000))
    app.run(host="0.0.0.0", port=port)
