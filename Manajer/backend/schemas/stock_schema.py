from pydantic import BaseModel

class StockCreate(BaseModel):
    product_id: int
    qty: int
    tipe: str   # masuk / keluar
    keterangan: str