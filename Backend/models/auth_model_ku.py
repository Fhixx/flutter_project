from pydantic import BaseModel

class LoginRequest(BaseModel):
    nama: str
    telepon: str