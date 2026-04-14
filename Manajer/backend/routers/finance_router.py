from fastapi import APIRouter
from database import get_db
from datetime import datetime, timedelta

router = APIRouter(prefix="/finance-report", tags=["Finance Report"])


# =========================
# SYNC DATA KE FINANCE
# =========================
def sync_finance(cursor):
    # ======================
    # NORMALISASI TIPE DATA
    # ======================
    cursor.execute("UPDATE finance SET tipe='pemasukan' WHERE tipe='masuk'")
    cursor.execute("UPDATE finance SET tipe='pengeluaran' WHERE tipe='keluar'")

    cursor.execute("""
        UPDATE finance 
        SET tipe = 'pemasukan'
        WHERE order_id IS NOT NULL
    """)

    cursor.execute("""
        UPDATE finance 
        SET tipe = 'pengeluaran'
        WHERE stock_movement_id IS NOT NULL
    """)

    # ======================
    # ORDERS → PEMASUKAN
    # ======================
    cursor.execute("""
        INSERT INTO finance (order_id, tipe, jumlah, keterangan, created_at)
        SELECT 
            o.id,
            'pemasukan',
            o.total,
            'Pendapatan Order',
            o.created_at
        FROM orders o
        LEFT JOIN finance f ON f.order_id = o.id
        WHERE f.order_id IS NULL
    """)

    # ======================
    # STOCK → PENGELUARAN
    # ======================
    cursor.execute("""
        INSERT INTO finance (stock_movement_id, tipe, jumlah, keterangan, created_at)
        SELECT 
            sm.id,
            'pengeluaran',
            CASE 
                WHEN sm.product_id = 1 THEN sm.qty * 40000
                WHEN sm.product_id = 2 THEN sm.qty * 50000
                ELSE 0
            END,
            'Pengadaan Stok',
            sm.created_at
        FROM stock_movements sm
        LEFT JOIN finance f ON f.stock_movement_id = sm.id
        WHERE sm.tipe = 'masuk' 
        AND f.stock_movement_id IS NULL
    """)


# =========================
# GET LAPORAN KEUANGAN
# =========================
@router.get("/")
def get_finance_report(filter: str = "all"):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    try:
        # 🔥 Sync dulu
        sync_finance(cursor)
        db.commit()

        today = datetime.now()

        date_filter = ""
        params = []

        if filter == "minggu":
            date_filter = "AND created_at >= %s"
            params.append(today - timedelta(days=7))

        elif filter == "bulan":
            date_filter = "AND created_at >= %s"
            params.append(today - timedelta(days=30))

        # ======================
        # PEMASUKAN
        # ======================
        cursor.execute(f"""
            SELECT SUM(jumlah) as total
            FROM finance
            WHERE tipe='pemasukan' {date_filter}
        """, params)

        pemasukan = cursor.fetchone()["total"] or 0

        # ======================
        # PENGELUARAN
        # ======================
        cursor.execute(f"""
            SELECT SUM(jumlah) as total
            FROM finance
            WHERE tipe='pengeluaran' {date_filter}
        """, params)

        pengeluaran = cursor.fetchone()["total"] or 0

        # ======================
        # SALDO
        # ======================
        modal_awal = 12000000
        saldo = modal_awal + pemasukan - pengeluaran

        # ======================
        # LIST TRANSAKSI
        # ======================
        cursor.execute(f"""
            SELECT 
                tipe,
                jumlah,
                keterangan,
                created_at AS tanggal
            FROM finance
            WHERE 1=1 {date_filter}
            ORDER BY created_at DESC
        """, params)

        transaksi = cursor.fetchall()

        return {
            "pemasukan": int(pemasukan),
            "pengeluaran": int(pengeluaran),
            "saldo": int(saldo),
            "transaksi": transaksi
        }

    except Exception as e:
        db.rollback()
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()