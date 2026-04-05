from fastapi import APIRouter
import mysql.connector
from database import get_db

router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"]
)

db = get_db()

@router.get("/")
def get_dashboard():
    cursor = db.cursor(dictionary=True)

    try:
        # stok produk A
        cursor.execute("""
            SELECT stok FROM products 
            WHERE id = 1
            LIMIT 1
        """)
        result_a = cursor.fetchone()
        stok_a = result_a["stok"] if result_a else 0

        # stok produk B
        cursor.execute("""
            SELECT stok FROM products 
            WHERE id = 2
            LIMIT 1
        """)
        result_b = cursor.fetchone()
        stok_b = result_b["stok"] if result_b else 0

        # pesanan masuk (menunggu verifikasi)
        cursor.execute("""
            SELECT COUNT(*) AS pesanan_masuk 
            FROM orders 
            WHERE status = 'menunggu_verifikasi'
        """)
        pesanan_masuk = cursor.fetchone()["pesanan_masuk"]

        # ditolak
        cursor.execute("""
            SELECT COUNT(*) AS ditolak 
            FROM orders 
            WHERE status = 'ditolak'
        """)
        ditolak = cursor.fetchone()["ditolak"]

        return {
            "stok_a": stok_a,
            "stok_b": stok_b,
            "pesanan_masuk": pesanan_masuk,
            "ditolak": ditolak
        }

    except Exception as e:
        return {"error": str(e)}