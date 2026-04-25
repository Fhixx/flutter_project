from fastapi import APIRouter
from database import get_db

router = APIRouter(prefix="/orders", tags=["Orders"])

@router.get("/diproses")
def get_orders():
    db = get_db()
    cursor = db.cursor(dictionary=True)  

    query = """
    SELECT 
        o.id AS order_id,
        u.username AS nama,
        CASE 
            WHEN oi.product_id = 1 THEN 'Produk A'
            WHEN oi.product_id = 2 THEN 'Produk B'
            ELSE 'Produk Lain'
        END AS produk,
        oi.qty AS jumlah,
        o.alamat_kirim as alamat
    FROM orders o
    JOIN users u ON o.user_id = u.id
    JOIN order_items oi ON oi.order_id = o.id
    WHERE o.status = 'diproses'
    """

    cursor.execute(query)
    result = cursor.fetchall()

    cursor.close()
    db.close()

    return result