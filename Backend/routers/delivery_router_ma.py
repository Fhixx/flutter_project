from fastapi import APIRouter
from database import get_db
from pydantic import BaseModel

router = APIRouter(prefix="/deliveries", tags=["Deliveries"])

class DeliveryRequest(BaseModel):
    order_id: int
    courier_id: int

@router.post("/")
def assign_delivery(data: DeliveryRequest):
    db = get_db()
    cursor = db.cursor()

    try:
        # INSERT ke deliveries
        insert_query = """
        INSERT INTO deliveries (order_id, courier_id, status)
        VALUES (%s, %s, 'menunggu')
        """
        cursor.execute(insert_query, (data.order_id, data.courier_id))

        # UPDATE status order
        update_query = """
        UPDATE orders
        SET status = 'menunggu_kurir'
        WHERE id = %s
        """
        cursor.execute(update_query, (data.order_id,))

        db.commit()

        return {"message": "Berhasil assign kurir"}

    except Exception as e:
        db.rollback()  
        return {"error": str(e)}

    finally:
        cursor.close()
        db.close()