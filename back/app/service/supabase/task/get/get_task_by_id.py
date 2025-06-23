from fastapi import HTTPException
import requests
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers


def get_task_by_id(task_id : str, user_id : str):
    response = requests.get(
        f"{SUPABASE_DB_URL}/tasks?id=eq.{task_id}&user_id=eq.{user_id}",
        headers=headers()
    )
    if response.status_code != 200 or not response.json():
        raise HTTPException(
            status_code=404,
            detail="Task not found"
        )
    return response.json()[0]


