from flask import Flask
import psycopg2
import os

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "capstone_db")
DB_USER = os.getenv("DB_USER", "capstone_user")
DB_PASSWORD = os.getenv("DB_PASSWORD", "capstone_pass")

def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )

@app.route("/")
def home():
    return "Hello from Flask Backend with DB!"

@app.route("/health")
def health():
    try:
        conn = get_db_connection()
        conn.close()
        return {"status": "UP", "database": "CONNECTED"}, 200
    except Exception as e:
        return {"status": "DOWN", "error": str(e)}, 500

@app.route("/db-test")
def db_test():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT 1;")
    result = cur.fetchone()
    cur.close()
    conn.close()
    return {"db_response": result[0]}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
