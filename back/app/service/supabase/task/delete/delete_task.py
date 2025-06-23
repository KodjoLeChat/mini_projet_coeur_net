from fastapi import HTTPException
import requests
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers


def _delete_task_common(task_id: str, user_id: str = None):
    url = f"{SUPABASE_DB_URL}/tasks?id=eq.{task_id}"
    if user_id is not None:
        url += f"&user_id=eq.{user_id}"
    response = requests.delete(
        url,
        headers=headers()
    )
    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while deleting task : {response.text}"
        )
    return {"ok": True}

def delete_own_task(task_id: str, user_id: str):
    return _delete_task_common(task_id, user_id=user_id)

def delete_admin_task(task_id: str):
    return _delete_task_common(task_id, user_id=None)
