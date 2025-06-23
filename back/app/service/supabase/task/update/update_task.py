from fastapi import HTTPException
import requests
from app.models.task import TaskCreate
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers


def _update_task_common(task_id: str, task: TaskCreate, user_id: str = None):
    data = task.model_dump()
    url = f"{SUPABASE_DB_URL}/tasks?id=eq.{task_id}"
    if user_id is not None:
        url += f"&user_id=eq.{user_id}"
    response = requests.patch(
        url,
        headers=headers(return_representation=True),
        json=data
    )
    if response.status_code != 200 or not response.json():
        raise HTTPException(
            status_code=404,
            detail=f"Error while updating task : {response.text}"
        )
    return response.json()[0]


def update_own_task(task_id: str, user_id: str, task: TaskCreate):
    return _update_task_common(task_id, task, user_id=user_id)

def update_admin_task(task_id: str, task: TaskCreate):
    return _update_task_common(task_id, task, user_id=None)

