import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT", 5432),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=3
    )

@app.route("/")
def home():
    return f"Hello from {os.getenv('APP_ENV', 'unknown')} environment!"

# ✅ CI-SAFE HEALTH CHECK (NO DB)
@app.route("/health")
def health():
    return jsonify({
        "status": "UP",
        "service": "backend"
    }), 200

# ✅ DB HEALTH (OPTIONAL, NOT USED BY JENKINS)
@app.route("/health/db")
def health_db():
    try:
        conn = get_db_connection()
        conn.close()
        return jsonify({
            "status": "UP",
            "db": "CONNECTED"
        }), 200
    except Exception as e:
        return jsonify({
            "status": "DOWN",
            "db": "NOT_CONNECTED",
            "error": str(e)
        }), 500

if __name__ == "__main__":
    port = int(os.getenv("BACKEND_PORT", 5000))
    app.run(host="0.0.0.0", port=port)
