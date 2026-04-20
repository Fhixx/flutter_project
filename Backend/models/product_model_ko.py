from database import get_db

def get_all_products():
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT id, nama, harga, satuan FROM products")
    return cursor.fetchall()
