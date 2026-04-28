import os
import mysql.connector
from urllib.parse import urlparse


def get_db():
    try:
        # Ambil DATABASE_URL dari Railway
        url = os.getenv("DATABASE_URL")

        print("=== DEBUG DATABASE CONNECTION ===")
        print("DATABASE_URL:", url)

        # kalau tidak ada env
        if not url:
            raise Exception("DATABASE_URL tidak ditemukan di environment")

        # parsing URL
        parsed = urlparse(url)

        print("HOST:", parsed.hostname)
        print("USER:", parsed.username)
        print("PASSWORD:", parsed.password)
        print("DATABASE:", parsed.path)
        print("PORT:", parsed.port)

        # ambil database name dengan aman
        db_name = parsed.path.lstrip("/")

        if not db_name:
            raise Exception("Nama database kosong")

        # koneksi ke MySQL
        conn = mysql.connector.connect(
            host=parsed.hostname,
            user=parsed.username,
            password=parsed.password,
            database=db_name,
            port=parsed.port or 3306
        )

        print("BERHASIL CONNECT DATABASE")

        return conn

    except Exception as e:
        print("ERROR DATABASE:", str(e))
        raise