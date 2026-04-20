from fastapi import FastAPI

from routers.auth_router_ko import router as auth_router_ko
from routers.product_router_ko import router as product_router
from routers.order_router_ko import router as order_router

from fastapi.middleware.cors import CORSMiddleware
from routers.auth_router_ku import router as auth_router_ku
from routers.delivery_router_ku import router as delivery_router
from routers import courier_order_router_ku

from routers.dashboard_router_ma import router as dashboard_router
from routers.stock_router_ma import router as stock_router
from routers.verification_router_ma import router as verification_router
from routers import order_router_ma, courier_router_ma, delivery_router_ma
from routers.finance_router_ma import router as finance_router

app = FastAPI()

#
# konsumen
#
app.include_router(auth_router_ko)
app.include_router(product_router)
app.include_router(order_router)


#
# kurir
#
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# register router
app.include_router(auth_router_ku, prefix="/api")

@app.get("/")
def root():
    return {"message": "API jalan"}

app.include_router(delivery_router, prefix="/api")
app.include_router(courier_order_router_ku.router)



#
# manajer
#
app.include_router(stock_router)
app.include_router(dashboard_router) 
app.include_router(verification_router) 
app.include_router(order_router_ma.router)
app.include_router(courier_router_ma.router)
app.include_router(delivery_router_ma.router)
app.include_router(finance_router)