import requests
from fastapi import HTTPException
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers

def get_user_list():
    response = requests.get(
        f"{SUPABASE_DB_URL}/profiles",
        headers=headers()
    )
    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while retrieving profiles: {response.text}"
        )
    return response.json()
