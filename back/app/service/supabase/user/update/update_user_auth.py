from fastapi import HTTPException
import requests
from app.config import SUPABASE_URL
from app.utils.headers import headers


def update_user_auth(user_id : str, new_email : str, role: str):
    payload = {
        "email": new_email,
        "email_confirm": True
    }
    if role:
        payload["app_metadata"] = {"roles": [role]}

    response = requests.put(
        f"{SUPABASE_URL}/auth/v1/admin/users/{user_id}",
        headers=headers(),
        json=payload
    )
    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while updating email : {response.text}"
        )
    user = response.json()
    return {"user": user, "user_id": user.get("id") or user.get("user", {}).get("id")}
