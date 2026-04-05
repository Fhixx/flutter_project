from fastapi import FastAPI
from routers.auth_router import router as auth_router
from routers.product_router import router as product_router
from routers.order_router import router as order_router



app = FastAPI()

app.include_router(auth_router)

app.include_router(product_router)

app.include_router(order_router)

