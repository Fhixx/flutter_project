from fastapi import APIRouter
import mysql.connector
from database import get_db

router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"]
)

@router.get("/")
def get_dashboard():
    db = get_db()
    cursor = db.cursor(dictionary=True)

    try:
        # stok produk A
        cursor.execute("""
            SELECT stok FROM products 
            WHERE id = 1
            LIMIT 1
        """)
        result_a = cursor.fetchone()
        stokA = result_a["stok"] if result_a else 0

        # stok produk B
        cursor.execute("""
            SELECT stok FROM products 
            WHERE id = 2
            LIMIT 1
        """)
        result_b = cursor.fetchone()
        stokB = result_b["stok"] if result_b else 0

        # pesanan masuk (menunggu verifikasi)
        cursor.execute("""
            SELECT COUNT(*) AS pesananMasuk 
            FROM orders 
            WHERE status = 'menunggu_verifikasi'
        """)
        pesananMasuk = cursor.fetchone()["pesananMasuk"]

        # ditolak
        cursor.execute("""
            SELECT COUNT(*) AS ditolak 
            FROM orders 
            WHERE status = 'ditolak'
        """)
        ditolak = cursor.fetchone()["ditolak"]

        return {
            "stokA": stokA,
            "stokB": stokB,
            "pesananMasuk": pesananMasuk,
            "ditolak": ditolak
        }

    except Exception as e:
        return {"error": str(e)}
    
    finally:
        cursor.close()
        db.close()