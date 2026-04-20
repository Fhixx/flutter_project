from fastapi import APIRouter
from passlib.hash import bcrypt
from schemas.auth_schema_ko import RegisterSchema, LoginSchema
from models.user_model_ko import create_user, get_user_by_username

router = APIRouter(prefix="/auth", tags=["Auth"])

# REGISTER
@router.post("/register/konsumen")
def register(data: RegisterSchema):
    existing = get_user_by_username(data.username)

    if existing:
        return {"status": "user_exists"}

    hashed = bcrypt.hash(data.password)

    create_user(
        data.username,
        hashed,
        data.alamat,
        data.telepon
    )

    return {"status": "success"}


# LOGIN
@router.post("/login/konsumen")
def login(data: LoginSchema):
    user = get_user_by_username(data.username)

    if not user:
        return {"status": "not_found"}

    if not bcrypt.verify(data.password, user["password"]):
        return {"status": "wrong_password"}

    return {
        "status": "success",
        "id": user["id"],
        "username": user["username"]
    }
