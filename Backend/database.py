import os
import mysql.connector
from urllib.parse import urlparse

def get_db():
    url = os.getenv("DATABASE_URL")

    parsed = urlparse(url)

    return mysql.connector.connect(
        host=parsed.hostname,
        user=parsed.username,
        password=parsed.password,
        database=parsed.path[1:],  # hapus '/'
        port=parsed.port
    )