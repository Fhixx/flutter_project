from fastapi import APIRouter
import mysql.connector
from datetime import datetime
from schemas.stock_schema import StockCreate
from database import get_db

router = APIRouter(prefix="/stock", tags=["Stock"])

db = get_db()

@router.post("/add")
def add_stock(data: StockCreate):
    cursor = db.cursor()

    try:
        # update stok produk
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

        # simpan ke stock movement
        cursor.execute("""
            INSERT INTO stock_movements 
            (product_id, tipe, qty, keterangan, created_at)
            VALUES (%s, %s, %s, %s, %s)
        """, (
            data.product_id,
            data.tipe,
            data.qty,
            data.keterangan,
            datetime.now()
        ))

        db.commit()

        return {"message": "Stok berhasil diperbarui"}

    except Exception as e:
        db.rollback()
        return {"error": str(e)}