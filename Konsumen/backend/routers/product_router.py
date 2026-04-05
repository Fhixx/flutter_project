from fastapi import APIRouter
from models.product_model import get_all_products

router = APIRouter(prefix="/products", tags=["Products"])

@router.get("/")
def products():
    return get_all_products()
