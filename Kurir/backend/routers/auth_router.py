from fastapi import APIRouter
from models.auth_model import LoginRequest
from database import get_db

router = APIRouter()

@router.post("/login")
def login(data: LoginRequest):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    query = """
        SELECT * FROM couriers
        WHERE nama = %s AND telepon = %s AND aktif = 1
    """
    cursor.execute(query, (data.nama, data.telepon))
    user = cursor.fetchone()

    cursor.close()
    db.close()

    if user:
        return {
            "success": True,
            "message": "Login berhasil",
            "data": user
        }
    else:
        return {
            "success": False,
            "message": "Nama atau telepon salah"
        }