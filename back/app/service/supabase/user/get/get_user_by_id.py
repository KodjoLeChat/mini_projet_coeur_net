from fastapi import HTTPException
import requests
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers


def get_user_by_id(user_id: str):
    response = requests.get(
        f"{SUPABASE_DB_URL}/profiles?id=eq.{user_id}",
        headers=headers()
    )
    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while retrieving profile: {response.text}"
        )

    profiles = response.json()

    if not profiles:
        raise HTTPException(
            status_code=404,
            detail="Profile not found"
        )

    return profiles[0]
