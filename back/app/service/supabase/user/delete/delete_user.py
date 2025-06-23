from fastapi import HTTPException

from app.service.supabase.user.delete.delete_profile import delete_profile
from app.service.supabase.user.delete.delete_user_auth import delete_user_auth



def delete_user(user_id: str):
    try:
        delete_user_auth(user_id)
    except HTTPException as e:
        raise e

    return {"message": "User and profile deleted"}