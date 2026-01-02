import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        connect_timeout=5
    )

def run_migrations():
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        with open("migrations/001_create_users.sql", "r") as f:
            cur.execute(f.read())

        conn.commit()
        cur.close()
        conn.close()
        print("Database migrations completed")
    except Exception as e:
        print("Migration error:", e)

@app.route("/")
def home():
    return f"Hello from {os.getenv('APP_ENV')} environment!"

@app.route("/health")
def health():
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
    run_migrations()
    port = int(os.getenv("BACKEND_PORT", 5000))
    app.run(host="0.0.0.0", port=port)
