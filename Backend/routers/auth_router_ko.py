from fastapi import APIRouter, HTTPException
from passlib.context import CryptContext

from schemas.auth_schema_ko import RegisterSchema, LoginSchema
from models.user_model_ko import create_user, get_user_by_username

router = APIRouter(prefix="/auth", tags=["Auth"])

# CONFIG HASHING (WAJIB)
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)

# REGISTER
@router.post("/register/konsumen")
def register(data: RegisterSchema):
    try:
        # cek user sudah ada
        existing = get_user_by_username(data.username)

        if existing:
            return {
                "success": False,
                "message": "Username sudah digunakan"
            }

        # limit password max 72 char (bcrypt limit)
        password = data.password[:72]

        # hashing password
        hashed_password = pwd_context.hash(password)

        # simpan ke database
        create_user(
            data.username,
            hashed_password,
            data.alamat,
            data.telepon
        )

        return {
            "success": True,
            "message": "Registrasi berhasil"
        }

    except Exception as e:
        print("ERROR REGISTER:", e)
        raise HTTPException(
            status_code=500,
            detail="Terjadi kesalahan server"
        )


# LOGIN
@router.post("/login/konsumen")
def login(data: LoginSchema):
    try:
        user = get_user_by_username(data.username)

        if not user:
            return {
                "success": False,
                "message": "User tidak ditemukan"
            }

        # limit password
        password = data.password[:72]

        # verifikasi password
        if not pwd_context.verify(password, user["password"]):
            return {
                "success": False,
                "message": "Password salah"
            }

        return {
            "success": True,
            "message": "Login berhasil",
            "data": {
                "id": user["id"],
                "username": user["username"]
            }
        }

    except Exception as e:
        print("ERROR LOGIN:", e)
        raise HTTPException(
            status_code=500,
            detail="Terjadi kesalahan server"
        )