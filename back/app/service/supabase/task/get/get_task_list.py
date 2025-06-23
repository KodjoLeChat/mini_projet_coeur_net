from fastapi import HTTPException
import requests

from app.config import SUPABASE_DB_URL
from app.utils.headers import headers


def _get_task_list_common(user_id: str = None, exclude_user_id: str = None):
    url = f"{SUPABASE_DB_URL}/tasks"
    params = []
    if user_id is not None:
        params.append(f"user_id=eq.{user_id}")
    elif exclude_user_id is not None:
        params.append(f"user_id=neq.{exclude_user_id}")
    if params:
        url += "?" + "&".join(params)
    response = requests.get(
        url,
        headers=headers()
    )
    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while retrieving tasks : {response.text}"
        )
    return sorted(response.json(), key=lambda t: (t.get("title") or "").lower())

def get_own_task_list(user_id: str):
    return _get_task_list_common(user_id=user_id)

def get_all_tasks(admin_id: str):
    return _get_task_list_common(exclude_user_id=admin_id)


