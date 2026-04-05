from database import get_db

def create_user(username, password, alamat, telepon):
    db = get_db()
    cursor = db.cursor()

    try:
        sql = """
        INSERT INTO users (username, password, alamat, telepon)
        VALUES (%s, %s, %s, %s)
        """
        cursor.execute(sql, (username, password, alamat, telepon))
        db.commit()
    finally:
        cursor.close()
        db.close()


def get_user_by_username(username):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    try:
        cursor.execute(
            "SELECT * FROM users WHERE username=%s",
            (username,)
        )
        return cursor.fetchone()
    finally:
        cursor.close()
        db.close()
