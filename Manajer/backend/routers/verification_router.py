from fastapi import APIRouter
from database import get_db

router = APIRouter(
    prefix="/verification",
    tags=["Verification"]
)

@router.get("/pending")
def get_pending_orders():
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            o.id,
            o.total,
            o.alamat_kirim,
            p.nama as product_name,
            oi.qty
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        JOIN products p ON oi.product_id = p.id
        WHERE o.status = 'menunggu_verifikasi'
    """)

    rows = cursor.fetchall()

    cursor.close()
    db.close()

    return rows


@router.put("/approve/{order_id}")
def approve_order(order_id: int):
    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        "UPDATE orders SET status='diproses' WHERE id=%s",
        (order_id,)
    )
    db.commit()

    if cursor.rowcount == 0:
        return {"status": "not_found"}

    cursor.close()
    db.close()

    return {"status": "success"}


@router.put("/reject/{order_id}")
def reject_order(order_id: int):
    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        "UPDATE orders SET status='ditolak' WHERE id=%s",
        (order_id,)
    )
    db.commit()

    if cursor.rowcount == 0:
        return {"status": "not_found"}

    cursor.close()
    db.close()

    return {"status": "success"}

@router.get("/{status}")
def get_orders_by_status(status: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            o.id,
            o.total,
            o.alamat_kirim,
            p.nama as product_name,
            oi.qty
        FROM orders o
        JOIN order_items oi ON o.id = oi.order_id
        JOIN products p ON oi.product_id = p.id
        WHERE o.status = %s
        ORDER BY o.created_at DESC
    """, (status,))

    result = cursor.fetchall()

    cursor.close()
    db.close()

    return result