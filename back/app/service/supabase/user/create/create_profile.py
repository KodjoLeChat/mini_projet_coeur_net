import requests
from fastapi import HTTPException
from app.config import  SUPABASE_DB_URL
from app.utils.headers import headers
from app.models.create_user_request import CreateUserRequest

def create_profile(user_id, payload : CreateUserRequest, role : str):
    response = requests.post(
        f"{SUPABASE_DB_URL}/profiles",
        headers=headers(return_representation=True),
        json={
            "id": user_id,
            "username": payload.username,
            "bio": payload.bio,
            "role":role,
            "email" : payload.email
        }
    )
    if response.status_code not in [200, 201]:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Error while creating profile: {response.text}"
        )
    return response.json()
