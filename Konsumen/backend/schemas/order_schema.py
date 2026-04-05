from pydantic import BaseModel

class OrderCreateSchema(BaseModel):
    user_id: int
    product_id: int
    qty: int
    alamat_kirim: str
    metode: str
    catatan: str | None = None