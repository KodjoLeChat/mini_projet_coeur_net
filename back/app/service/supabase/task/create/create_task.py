from fastapi import HTTPException
import requests
from app.config import SUPABASE_DB_URL
from app.models.task import TaskCreate
from app.utils.headers import headers


def create_task(user_id: str, task: TaskCreate):
    payload = {
        "user_id": user_id,
        "title": task.title,
        "description": task.description,
        "status": task.status
    }
    response = requests.post(
        f"{SUPABASE_DB_URL}/tasks",
        headers=headers(return_representation=True),
        json=payload
    )
    if response.status_code not in [200, 201]:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while creating task : {response.text}"
        )
    return response.json()
