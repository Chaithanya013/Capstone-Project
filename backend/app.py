import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

# -----------------------
# Database connection
# -----------------------
def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT", 5432),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=3
    )

# -----------------------
# Home
# -----------------------
@app.route("/")
def home():
    env = os.getenv("APP_ENV", "unknown")
    return f"Hello from {env} environment!", 200

# -----------------------
# CI / Load Balancer health check
# (NO dependencies)
# -----------------------
@app.route("/health")
def health():
    """
    CI/CD & Docker health endpoint.
    MUST be fast and dependency-free.
    """
    return jsonify(
        status="UP",
        service="backend"
    ), 200

# -----------------------
# Database health check
# (for debugging / monitoring)
# -----------------------
@app.route("/health/db")
def db_health():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify(
            db="CONNECTED"
        ), 200
    except Exception as e:
        return jsonify(
            db="NOT_CONNECTED",
            error=str(e)
        ), 500

# -----------------------
# App start
# -----------------------
if __name__ == "__main__":
    # Backend MUST always listen on 5000 inside container
    app.run(host="0.0.0.0", port=5000)
