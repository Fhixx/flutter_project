from fastapi import APIRouter
from database import get_db

router = APIRouter(prefix="/couriers", tags=["Couriers"])

@router.get("/")
def get_couriers():
    db = get_db()
    cursor = db.cursor(dictionary=True)

    query = "SELECT * FROM couriers WHERE aktif = true"

    cursor.execute(query)
    result = cursor.fetchall()

    cursor.close()
    db.close()

    return result