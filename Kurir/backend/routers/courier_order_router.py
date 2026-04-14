from fastapi import APIRouter
from database import get_db
from pydantic import BaseModel

router = APIRouter(prefix="/courier-orders", tags=["Courier Orders"])

# GET ORDER BY COURIER
@router.get("/{courier_id}")
def get_orders_by_courier(courier_id: int):
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
        o.alamat_kirim AS alamat,
        p.metode AS metode_pembayaran,
        d.status AS status_pengiriman
    FROM deliveries d
    JOIN orders o ON d.order_id = o.id
    JOIN users u ON o.user_id = u.id
    JOIN order_items oi ON oi.order_id = o.id
    LEFT JOIN payments p ON p.order_id = o.id
    WHERE d.courier_id = %s
    """

    cursor.execute(query, (courier_id,))
    result = cursor.fetchall()

    cursor.close()
    db.close()

    return result


# GET DETAIL ORDER
@router.get("/detail/{order_id}")
def get_order_detail(order_id: int):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    query = """
    SELECT 
        o.id AS order_id,
        o.status,
        o.catatan,
        o.alamat_kirim,
        u.username AS nama,
        u.telepon,
        oi.qty,
        CASE 
            WHEN oi.product_id = 1 THEN 'Produk A'
            WHEN oi.product_id = 2 THEN 'Produk B'
        END AS produk,
        p.metode,
        p.jumlah,
        p.status AS status_pembayaran
    FROM orders o
    JOIN users u ON o.user_id = u.id
    JOIN order_items oi ON oi.order_id = o.id
    LEFT JOIN payments p ON p.order_id = o.id
    WHERE o.id = %s
    """

    cursor.execute(query, (order_id,))
    result = cursor.fetchone()

    cursor.close()
    db.close()

    return result


# PICKUP (AMBIL BARANG)
@router.put("/pickup/{order_id}")
def pickup_order(order_id: int):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    try:
        # ambil semua item dalam order
        cursor.execute("""
        SELECT product_id, qty
        FROM order_items
        WHERE order_id = %s
        """, (order_id,))
        items = cursor.fetchall()

        # loop tiap produk
        for item in items:
            product_id = item["product_id"]
            qty = item["qty"]

            # kurangi stok
            cursor.execute("""
            UPDATE products
            SET stok = stok - %s
            WHERE id = %s
            """, (qty, product_id))

            # catat ke stock_movements
            cursor.execute("""
            INSERT INTO stock_movements
            (product_id, tipe, qty, keterangan, created_at)
            VALUES (%s, 'keluar', %s, %s, NOW())
            """, (
                product_id,
                qty,
                f"Pengiriman order #{order_id}"
            ))

        # update orders
        cursor.execute("""
        UPDATE orders 
        SET status='dikirim' 
        WHERE id=%s
        """, (order_id,))

        # update deliveries
        cursor.execute("""
        UPDATE deliveries 
        SET status='dikirim', dikirim_at=NOW()
        WHERE order_id=%s
        """, (order_id,))

        db.commit()
        return {"success": True}

    except Exception as e:
        db.rollback()
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()


# SELESAI ORDER (QRIS / FINAL)
@router.put("/finish/{order_id}")
def finish_order(order_id: int):
    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute("""
        UPDATE orders 
        SET status='selesai' 
        WHERE id=%s
        """, (order_id,))

        cursor.execute("""
        UPDATE deliveries 
        SET status='selesai', sampai_at=NOW()
        WHERE order_id=%s
        """, (order_id,))

        db.commit()
        return {"success": True}

    except Exception as e:
        db.rollback()
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()


# COD PAYMENT
class CodRequest(BaseModel):
    jumlah: int

@router.put("/cod/{order_id}")
def bayar_cod(order_id: int, data: CodRequest):
    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute("""
        UPDATE payments 
        SET status='dibayar', jumlah=%s, paid_at=NOW()
        WHERE order_id=%s
        """, (data.jumlah, order_id))

        db.commit()
        return {"success": True}

    except Exception as e:
        db.rollback()
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()


# (OPTIONAL) UPDATE STATUS MANUAL
class UpdateStatus(BaseModel):
    status: str

@router.put("/update-status/{order_id}")
def update_status(order_id: int, data: UpdateStatus):
    db = get_db()
    cursor = db.cursor()

    try:
        cursor.execute("""
        UPDATE deliveries
        SET status = %s
        WHERE order_id = %s
        """, (data.status, order_id))

        db.commit()
        return {"message": "Status berhasil diupdate"}

    except Exception as e:
        db.rollback()
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()