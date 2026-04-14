from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers.auth_router import router as auth_router

from routers.delivery_router import router as delivery_router

from routers import courier_order_router



app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# register router
app.include_router(auth_router, prefix="/api")

@app.get("/")
def root():
    return {"message": "API jalan"}

#ambil data delivery
app.include_router(delivery_router, prefix="/api")

#tampilkan tugas
app.include_router(courier_order_router.router)