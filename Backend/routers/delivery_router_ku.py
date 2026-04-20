from fastapi import APIRouter
from database import get_db

router = APIRouter()

@router.get("/statistik/{courier_id}")
def get_statistik(courier_id: int):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    query = """
        SELECT 
            SUM(CASE WHEN status = 'menunggu' THEN 1 ELSE 0 END) AS tugas,
            SUM(CASE WHEN status = 'dikirim' THEN 1 ELSE 0 END) AS proses,
            SUM(CASE WHEN status = 'selesai' THEN 1 ELSE 0 END) AS selesai
        FROM deliveries
        WHERE courier_id = %s
    """

    cursor.execute(query, (courier_id,))
    result = cursor.fetchone()

    cursor.close()
    db.close()

    return {
        "success": True,
        "data": result
    }