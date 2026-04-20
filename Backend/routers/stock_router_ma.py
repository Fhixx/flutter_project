from fastapi import APIRouter
import mysql.connector
from datetime import datetime
from schemas.stock_schema_ma import StockCreate
from database import get_db

router = APIRouter(prefix="/stock", tags=["Stock"])

db = get_db()

@router.post("/add")
def add_stock(data: StockCreate):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    try:
        # cek produk dulu
        cursor.execute("SELECT stok FROM products WHERE id=%s", (data.product_id,))
        product = cursor.fetchone()

        if not product:
            return {"error": "Produk tidak ditemukan"}

        current_stok = product["stok"]

        # validasi stok keluar
        if data.tipe == "keluar" and current_stok < data.qty:
            return {"error": "Stok tidak mencukupi"}

        # update stok
        if data.tipe == "masuk":
            cursor.execute("""
                UPDATE products 
                SET stok = stok + %s 
                WHERE id = %s
            """, (data.qty, data.product_id))

        elif data.tipe == "keluar":
            cursor.execute("""
                UPDATE products 
                SET stok = stok - %s 
                WHERE id = %s
            """, (data.qty, data.product_id))

        else:
            return {"error": "Tipe harus 'masuk' atau 'keluar'"}

        # simpan movement
        cursor.execute("""
            INSERT INTO stock_movements 
            (product_id, tipe, qty, keterangan, created_at)
            VALUES (%s, %s, %s, %s, NOW())
        """, (
            data.product_id,
            data.tipe,
            data.qty,
            data.keterangan,
        ))

        db.commit()

        return {"message": "Stok berhasil diperbarui"}

    except Exception as e:
        db.rollback()
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()