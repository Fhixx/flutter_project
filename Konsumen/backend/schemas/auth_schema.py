from pydantic import BaseModel

class RegisterSchema(BaseModel):
    username: str
    password: str
    alamat: str
    telepon: str

class LoginSchema(BaseModel):
    username: str
    password: str
