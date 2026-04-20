from fastapi import APIRouter
from database import get_db
from schemas.order_schema_ko import OrderCreateSchema

router = APIRouter(prefix="/orders", tags=["Orders"])

@router.post("/")
def create_order(data: OrderCreateSchema):
    db = get_db()
    cursor = db.cursor()

    # ambil harga produk
    cursor.execute(
        "SELECT harga FROM products WHERE id=%s",
        (data.product_id,)
    )
    product = cursor.fetchone()

    if not product:
        return {"status": "product_not_found"}

    harga = product[0]
    total = harga * data.qty

    # orders
    cursor.execute("""
        INSERT INTO orders (user_id, status, total, alamat_kirim, catatan)
        VALUES (%s, %s, %s, %s, %s)
    """, (
        data.user_id,
        "menunggu_verifikasi",
        total,
        data.alamat_kirim,
        data.catatan
    ))

    order_id = cursor.lastrowid

    # order_items
    cursor.execute("""
        INSERT INTO order_items (order_id, product_id, qty, harga, subtotal)
        VALUES (%s, %s, %s, %s, %s)
    """, (
        order_id,
        data.product_id,
        data.qty,
        harga,
        total
    ))

    # payments
    cursor.execute("""
        INSERT INTO payments (order_id, metode, status, jumlah)
        VALUES (%s, %s, %s, %s)
    """, (
        order_id,
        data.metode,
        "menunggu",
        total
    ))

    db.commit()

    return {
        "status": "success",
        "order_id": order_id
    }
    

# confirm pembayaran
@router.put("/confirm/{order_id}")
def confirm_payment(order_id: int):
    db = get_db()
    cursor = db.cursor()

    cursor.execute("""
        UPDATE payments 
        SET status=%s 
        WHERE order_id=%s
    """, ("dibayar", order_id))

    db.commit()

    return {"status": "success"}

# status pemesanan
@router.get("/user/{user_id}")
def get_user_orders(user_id: int):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    query = """
    SELECT 
        o.id,
        o.status,
        o.total,
        o.alamat_kirim,
        o.catatan,
        oi.product_id,
        oi.qty
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE o.user_id = %s
    ORDER BY o.created_at DESC
    LIMIT 2
    """

    cursor.execute(query, (user_id,))
    rows = cursor.fetchall()

    result = []

    for row in rows:
        product_name = "Produk A" if row["product_id"] == 1 else "Produk B"

        result.append({
            "id": row["id"],
            "status": row["status"],
            "total": row["total"],
            "alamat_kirim": row["alamat_kirim"],
            "catatan": row["catatan"],
            "product_id": row["product_id"],
            "product_name": product_name,
            "qty": row["qty"],
        })

    return result