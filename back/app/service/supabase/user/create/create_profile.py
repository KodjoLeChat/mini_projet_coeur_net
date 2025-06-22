import requests
from fastapi import HTTPException
from app.config import  SUPABASE_DB_URL
from app.utils.headers import headers


def create_profile(user_id, username, bio):
    response = requests.post(
        f"{SUPABASE_DB_URL}/profiles",
        headers=headers(return_representation=True),
        json={
            "id": user_id,
            "username": username,
            "bio": bio,
        }
    )
    if response.status_code not in [200, 201]:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while creating profile: {response.text}"
        )
    return response.json()
