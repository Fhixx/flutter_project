from fastapi import FastAPI

from routers.dashboardM_router import router as dashboard_router
from routers.stock_router import router as stock_router


app = FastAPI()


app.include_router(stock_router)

app.include_router(dashboard_router)