import requests
from fastapi import HTTPException
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers

def get_user_list(exclude_id: str = None):
    response = requests.get(
        f"{SUPABASE_DB_URL}/profiles",
        headers=headers()
    )
    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while retrieving profiles: {response.text}"
        )
    profiles = response.json()
    if exclude_id:
        profiles = [p for p in profiles if p.get("id") != exclude_id]
    profiles = sorted(profiles, key=lambda p: p.get("username", "").lower())
    return profiles
