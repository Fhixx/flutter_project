from database import get_db

def create_order(userId, productId, qty, address, paymentMethod):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    # ambil harga produk
    cursor.execute(
        "SELECT harga FROM products WHERE id=%s",
        (productId,)
    )
    product = cursor.fetchone()

    harga = product["harga"]
    subtotal = harga * qty

    # 1️⃣ insert orders
    sql_order = """
    INSERT INTO orders (user_id, status, total, alamat_kirim, catatan)
    VALUES (%s, 'menunggu', %s, %s, %s)
    """
    cursor.execute(sql_order, (userId, subtotal, address, paymentMethod))
    orderId = cursor.lastrowid

    # 2️⃣ insert order_items
    sql_item = """
    INSERT INTO order_items (order_id, product_id, qty, harga, subtotal)
    VALUES (%s, %s, %s, %s, %s)
    """
    cursor.execute(sql_item, (orderId, productId, qty, harga, subtotal))

    db.commit()
