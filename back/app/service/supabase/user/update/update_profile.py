from fastapi import HTTPException
import requests

from app.config import SUPABASE_DB_URL
from app.utils.headers import headers
from app.models.create_user_request import CreateUserRequest


def update_profile(user_id: str, payload: CreateUserRequest):
    data = {
        "username": payload.username,
        "bio": payload.bio,
        "email": payload.email
    }

    role = payload.role

    if role:
        data["role"] = role

    response = requests.patch(
        f"{SUPABASE_DB_URL}/profiles?id=eq.{user_id}",
        headers=headers(return_representation=True),
        json=data
    )
    if response.status_code not in [200, 201]:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while updating profile: {response.text}"
        )
    return response.json()
